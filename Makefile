IAC_PATH=./iac/

TARGET_INIT=init
TARGET_CLUSTER=cluster
TARGET_OUTPUT=output
TARGET_PKI=pki
TARGET_KUBECONFIG=kubeconfig
TARGET_ETCD=etcd
TARGET_APISERVER=apiserver
TARGET_CLEAN=clean
TARGET_ALL=all
DEFAULT_TARGET=$(TARGET_ALL)

TERRAFORM_BIN=terraform
TERRAFORM_ENV_VARS+=AWS_PROFILE=$(AWS_PROFILE)
TERRAFORM_ENV_VARS+=AWS_SDK_LOAD_CONFIG=1

.PHONY: $(TARGET_INIT) $(TARGET_CLUSTER) $(TARGET_CLUSTER_OUTPUT) $(TARGET_CLUSTER_CLEAN) $(TARGET_PKI) $(TARGET_CLEAN) $(TARGET_ALL)

.DEFAULT_GOAL := $(DEFAULT_TARGET)

$(TARGET_INIT):
	@cd $(IAC_PATH) && \
		$(TERRAFORM_ENV_VARS) $(TERRAFORM_BIN) init
$(TARGET_CLUSTER):
	@cd $(IAC_PATH) && \
		$(TERRAFORM_ENV_VARS) $(TERRAFORM_BIN) apply
$(TARGET_OUTPUT):
	@cd $(IAC_PATH) && \
		$(TERRAFORM_ENV_VARS) $(TERRAFORM_BIN) output
$(TARGET_PKI):
	@./scripts/pki/ca.sh && \
	./scripts/pki/admin.sh && \
	./scripts/pki/kubelet.sh && \
	./scripts/pki/kube-controller-manager.sh && \
	./scripts/pki/kube-proxy.sh && \
	./scripts/pki/kube-scheduler.sh && \
	./scripts/pki/kube-apiserver.sh && \
	./scripts/pki/service-account-token-controller.sh && \
	./scripts/pki/copy.sh
$(TARGET_KUBECONFIG):
	@./scripts/kubeconfig/kubelet.sh && \
    ./scripts/kubeconfig/kube-proxy.sh && \
	./scripts/kubeconfig/kube-controller-manager.sh && \
	./scripts/kubeconfig/kube-scheduler.sh && \
	./scripts/kubeconfig/admin.sh && \
	./scripts/kubeconfig/copy.sh
$(TARGET_CLEAN):
	@rm -f data/kubeconfig/* && \
	rm -f data/pki/* && \
	cd $(IAC_PATH) && \
		$(TERRAFORM_ENV_VARS) $(TERRAFORM_BIN) destroy
$(TARGET_ETCD):
	@./scripts/master/etcd.sh
$(TARGET_APISERVER):
	@./scripts/master/kube-apiserver.sh
$(TARGET_ALL): $(TARGET_INIT) $(TARGET_CLUSTER) $(TARGET_PKI) $(TARGET_KUBECONFIG)

