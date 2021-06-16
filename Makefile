.PHONY: up down clean status config login provision

_VM=time vagrant

clean:
	$(call venv_exec,.venv,$(_VM) destroy)
	rm -rf .vagrant

config:
	$(call venv_exec,.venv,$(_VM) validate)

down:
	$(call venv_exec,.venv,$(_VM) suspend)

login:
	$(call venv_exec,.venv,$(_VM) ssh)

provision:
	$(call venv_exec,.venv,$(_VM) provision)

status:
	$(call venv_exec,.venv,$(_VM) status)
	
up:
	$(call venv_exec,.venv,$(_VM) up)

venv_init:
	$(call venv_exec,.venv,pip install -r requirements.txt)
	$(call venv_exec,.venv,pip install --upgrade pip)
	$(call venv_exec,.venv,ansible-galaxy collection install community.docker )

_KUBECONFIG=.ignore.admin.conf
_KUBECONFIG_LOCAL=./$(_KUBECONFIG)
_KUBECONFIG_LOCAL_SCRIPT=.ignore.src.sh
get_kubeconfig:
	mv ./ansible/$(_KUBECONFIG) .
	echo '#!/bin/bash\nexport KUBECONFIG=$(_KUBECONFIG_LOCAL)' > $(_KUBECONFIG_LOCAL_SCRIPT)

# VENV FUNCTIONS
define venv_exec
	$(if [ ! -f "$($(1)/bin/activate)" ], python3 -m venv $(1))
	( \
    	source $(1)/bin/activate; \
    	$(2) \
	)
endef
