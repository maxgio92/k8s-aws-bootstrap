# Misc
IAC_PATH=./iac
SCRIPTS_PATH=./scripts
DATA_PATH=./data
TERRAFORM_BIN=terraform
TERRAFORM_ENV_VARS+=AWS_PROFILE=$(AWS_PROFILE)
TERRAFORM_ENV_VARS+=AWS_SDK_LOAD_CONFIG=1

# General targets
TARGET_INIT=init
TARGET_CLUSTER=cluster
TARGET_OUTPUT=output
TARGET_CLEAN=clean
TARGET_ALL=all
DEFAULT_TARGET=$(TARGET_ALL)

# Common targets
TARGET_PKI=pki
TARGET_KUBECONFIG=kubeconfig
TARGET_KUBECTL=kubectl

# Master components targets
TARGET_MASTER=master
TARGET_ETCD=etcd
TARGET_APISERVER=apiserver
TARGET_CONTROLLER_MANAGER=controllermanager
TARGET_SCHEDULER=scheduler
TARGET_KUBELET_AUTH=kubeletauth

# Worker components targets
TARGET_WORKER=worker
TARGET_WORKER_DEPS=workerdeps
TARGET_CNI=cni
TARGET_CR=cr
TARGET_KUBELET=kubelet
TARGET_KUBE_PROXY=kubeproxy

# Phony targets (they are all phony)
.PHONY: $(TARGET_INIT) $(TARGET_CLUSTER) $(TARGET_CLUSTER_OUTPUT) $(TARGET_CLUSTER_CLEAN) $(TARGET_PKI) $(TARGET_KUBECONFIG) $(TARGET_KUBECTL) $(TARGET_ETCD) $(TARGET_APISERVER) $(TARGET_CONTROLLER_MANAGER) $(TARGET_SCHEDULER) $(TARGET_KUBELET_AUTH) $(TARGET_MASTER) $(TARGET_WORKER_DEPS) $(TARGET_CNI) $(TARGET_CR) $(TARGET_KUBELET) $(TARGET_KUBE_PROXY) $(TARGET_WORKER) $(TARGET_CLEAN) $(TARGET_ALL)

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
$(TARGET_KUBECTL):
	@$(SCRIPTS_PATH)/common/kubectl.sh
$(TARGET_ETCD):
	@$(SCRIPTS_PATH)/master/etcd.sh
$(TARGET_APISERVER):
	@$(SCRIPTS_PATH)/master/kube-apiserver.sh
$(TARGET_CONTROLLER_MANAGER):
	@$(SCRIPTS_PATH)/master/kube-controller-manager.sh
$(TARGET_SCHEDULER):
	@$(SCRIPTS_PATH)/master/kube-scheduler.sh
$(TARGET_KUBELET_AUTH):
	@$(SCRIPTS_PATH)/master/kubelet-authorization.sh
$(TARGET_MASTER): $(TARGET_ETCD) $(TARGET_APISERVER) $(TARGET_CONTROLLER_MANAGER) $(TARGET_SCHEDULER) $(TARGET_KUBECTL) $(TARGET_KUBELET_AUTH)
$(TARGET_WORKER_DEPS):
	@$(SCRIPTS_PATH)/worker/requirements.sh
$(TARGET_CNI):
	@$(SCRIPTS_PATH)/worker/cni.sh
$(TARGET_CR):
	@$(SCRIPTS_PATH)/worker/cr.sh
$(TARGET_KUBELET):
	@$(SCRIPTS_PATH)/worker/kubelet.sh
$(TARGET_KUBE_PROXY):
	@$(SCRIPTS_PATH)/worker/kube-proxy.sh
$(TARGET_WORKER): $(TARGET_WORKER_DEPS) $(TARGET_CNI) $(TARGET_CR) $(TARGET_KUBELET) $(TARGET_KUBE_PROXY)
$(TARGET_CLEAN):
	@rm -f $(DATA_PATH)/kubeconfig/* && \
	rm -f $(DATA_PATH)/pki/* && \
	cd $(IAC_PATH) && \
		$(TERRAFORM_ENV_VARS) $(TERRAFORM_BIN) destroy
$(TARGET_ALL): $(TARGET_INIT) $(TARGET_CLUSTER) $(TARGET_PKI) $(TARGET_KUBECONFIG) $(TARGET_MASTER) $(TARGET_WORKER)

