IAC_PATH=./iac/

TARGET_INIT=init
TARGET_CLUSTER=cluster
TARGET_CLUSTER_CLEAN='cluster clean'
TARGET_CLUSTER_OUTPUT='cluster output'
TARGET_CLEAN=clean
TARGET_PKI=pki
TARGET_ALL=all
DEFAULT_TARGET=$(TARGET_ALL)

TERRAFORM_ENV_VARS+=AWS_PROFILE=$(AWS_PROFILE)
TERRAFORM_ENV_VARS+=AWS_SDK_LOAD_CONFIG=1

.PHONY: $(TARGET_INIT) $(TARGET_CLUSTER) $(TARGET_CLUSTER_OUTPUT) $(TARGET_CLUSTER_CLEAN) $(TARGET_PKI) $(TARGET_CLEAN) $(TARGET_ALL)

.DEFAULT_GOAL := $(DEFAULT_TARGET)

$(TARGET_INIT):
	cd $(IAC_PATH) && \
		$(TERRAFORM_ENV_VARS) terraform init
$(TARGET_CLUSTER):
	cd $(IAC_PATH) && \
		$(TERRAFORM_ENV_VARS) terraform apply
$(TARGET_CLUSTER_OUTPUT):
	cd $(IAC_PATH) && \
		$(TERRAFORM_ENV_VARS) terraform output
$(TARGET_CLUSTER_CLEAN):
	cd $(IAC_PATH) && \
		$(TERRAFORM_ENV_VARS) terraform destroy
$(TARGET_PKI):
	./scripts/pki/ca.sh && \
	./scripts/pki/admin.sh && \
	./scripts/pki/kubelet.sh && \
	./scripts/pki/controller-manager.sh && \
	./scripts/pki/kube-proxy.sh && \
	./scripts/pki/kube-scheduler.sh
$(TARGET_CLEAN): $(TARGET_CLUSTER_CLEAN)
$(TARGET_ALL): $(TARGET_INIT) $(TARGET_CLUSTER) $(TARGET_PKI)

