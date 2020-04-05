IAC_PATH=./iac
SCRIPTS_PATH=./scripts
DATA_PATH=./data

TARGET_INIT=init
TARGET_CLUSTER=cluster
TARGET_OUTPUT=output
TARGET_PKI=pki
TARGET_KUBECONFIG=kubeconfig
TARGET_ETCD=etcd
TARGET_APISERVER=apiserver
TARGET_MASTER=master
TARGET_CLEAN=clean
TARGET_ALL=all
DEFAULT_TARGET=$(TARGET_ALL)

TERRAFORM_BIN=terraform
TERRAFORM_ENV_VARS+=AWS_PROFILE=$(AWS_PROFILE)
TERRAFORM_ENV_VARS+=AWS_SDK_LOAD_CONFIG=1

.PHONY: $(TARGET_INIT) $(TARGET_CLUSTER) $(TARGET_CLUSTER_OUTPUT) $(TARGET_CLUSTER_CLEAN) $(TARGET_PKI) $(TARGET_KUBECONFIG) $(TARGET_ETCD) $(TARGET_APISERVER) $(TARGET_MASTER) $(TARGET_CLEAN) $(TARGET_ALL)

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
	@$(SCRIPTS_PATH)/pki/ca.sh && \
	$(SCRIPTS_PATH)/pki/admin.sh && \
	$(SCRIPTS_PATH)/pki/kubelet.sh && \
	$(SCRIPTS_PATH)/pki/kube-controller-manager.sh && \
	$(SCRIPTS_PATH)/pki/kube-proxy.sh && \
	$(SCRIPTS_PATH)/pki/kube-scheduler.sh && \
	$(SCRIPTS_PATH)/pki/kube-apiserver.sh && \
	$(SCRIPTS_PATH)/pki/service-account-token-controller.sh && \
	$(SCRIPTS_PATH)/pki/copy.sh
$(TARGET_KUBECONFIG):
	@$(SCRIPTS_PATH)/kubeconfig/kubelet.sh && \
    $(SCRIPTS_PATH)/kubeconfig/kube-proxy.sh && \
	$(SCRIPTS_PATH)/kubeconfig/kube-controller-manager.sh && \
	$(SCRIPTS_PATH)/kubeconfig/kube-scheduler.sh && \
	$(SCRIPTS_PATH)/kubeconfig/admin.sh && \
	$(SCRIPTS_PATH)/kubeconfig/copy.sh
$(TARGET_CLEAN):
	@rm -f $(DATA_PATH)/kubeconfig/* && \
	rm -f $(DATA_PATH)/pki/* && \
	cd $(IAC_PATH) && \
		$(TERRAFORM_ENV_VARS) $(TERRAFORM_BIN) destroy
$(TARGET_ETCD):
	@$(SCRIPTS_PATH)/master/etcd.sh
$(TARGET_APISERVER):
	@$(SCRIPTS_PATH)/master/kube-apiserver.sh
$(TARGET_MASTER): $(TARGET_ETCD) $(TARGET_APISERVER)
$(TARGET_ALL): $(TARGET_INIT) $(TARGET_CLUSTER) $(TARGET_PKI) $(TARGET_KUBECONFIG)

