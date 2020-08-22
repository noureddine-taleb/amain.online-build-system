# this project is under GPL license
# doc 
#   0- deploy <tag> |> tag = *|all|frontend|backend|backoffice
#   1- this script is made to make deploy task less overkill 🤯 🤕
#   2- if just run the script it will deploy front/back end (and rm former deploy if exists)
#   3- there is a usefull arg "all" if you want to deploy front/back end and backoffice too
#   4- there is specific tag foreach project if you want to deploy specific one
.PHONY: all frontend backend clean setup

#env
env :=prod

# ports
backendPort :=3000
frontendPort :=4000

# branchs
gitBranch :=master
server :=nginx

# tags
frontendTag :=frontend
backendTag :=backend

# colors
frontendColor :=😁$(shell tput setaf 1)$(shell tput bold) <===$(env)===> # red
backendColor :=🙃$(shell tput setaf 2)$(shell tput bold) <===$(env)===> # green
resetColor :=$(shell tput sgr0) # reset
rmColor :=$(shell tput setaf 3)$(shell tput bold) # yellow

# repos
frontendRepo :=git@github.com:noureddine-taleb/amain.online-backend.git
backendRepo :=git@github.com:noureddine-taleb/amain.online-frontend.git

# dirs
rootDir :=/var/www/html/consortuim-$(env)
frontendDir :=$(rootDir)/amain.online-frontend
backendDir :=$(rootDir)/amain.online-backend

all: frontend backend

frontend: setup
ifneq ($(wildcard $(frontendDir)),)
	-@echo -e "$(frontendColor) cd $(resetColor)"; \
	cd $(frontendDir); \
	echo -e "$(frontendColor)  checkout '$(gitBranch)' $(resetColor)"; \
	git checkout $(gitBranch) ; \
	echo -e "$(frontendColor) reset locals '$(gitBranch)' $(resetColor)"; \
	git reset --hard $(gitBranch); \
	echo -e "$(frontendColor) pull '$(gitBranch)' $(resetColor)"; \
	git pull origin $(gitBranch); \
	echo -e "$(frontendColor) clear; install $(resetColor)"; \
	npm cache clear -f; \
	npm i; \
	echo -e "$(frontendColor) build $(resetColor)"; \
	npm run build:ssr; \
	echo -e "$(frontendColor) delete $(resetColor)"; \
	pm2 delete $(frontendTag) ; \
	echo -e "$(frontendColor) deploy '$(frontendPort)' $(resetColor)"; \
	pm2 start --name $(frontendTag) "PORT=$(frontendPort) npm run serve:ssr";
else
	-@echo -e "$(frontendColor) cd $(resetColor)" ; \
	cd $(rootDir) ; \
	echo -e "$(frontendColor) clone $(resetColor)" ; \
	git clone $(frontendRepo) ; \
	echo -e "$(frontendColor) cd $(resetColor)"; \
	cd $(frontendDir) ; \
	echo -e "$(frontendColor) checkout '$(gitBranch)' $(resetColor)"; \
	git checkout $(gitBranch) ; \
	echo -e "$(frontendColor)  clear; install $(resetColor)"; \
	npm cache clear -f; \
	npm i; \
	echo -e "$(frontendColor) build $(resetColor)"; \
	npm run build:ssr; \
	echo -e "$(frontendColor) delete $(resetColor)"; \
	pm2 delete $(frontendTag) ; \
	echo -e "$(frontendColor) deploy '$(frontendPort)' $(resetColor)"; \
	pm2 start --name $(frontendTag) "PORT=$(frontendPort) npm run serve:ssr";
endif


backend: setup
ifneq ($(wildcard $(backendDir)),)
	-@echo -e "$(backendColor) cd $(resetColor)"; \
	cd $(backendDir); \
	echo -e "$(backendColor) checkout '$(gitBranch)' $(resetColor)"; \
	git checkout $(gitBranch); \
	echo -e "$(frontendColor) reset locals '$(gitBranch)' $(resetColor)"; \
	git reset --hard $(gitBranch); \
	echo -e "$(backendColor) pull $(resetColor)"; \
	git pull origin $(gitBranch); \
	echo -e "$(backendColor) clear; rm; install $(resetColor)"; \
	npm i; \
	echo -e "$(backendColor) delete $(resetColor)"; \
	pm2 delete $(backendTag); \
	echo -e "$(backendColor) deploy '$(backendPort)' $(resetColor)"; \
	pm2 start --name $(backendTag) "PORT=$(backendPort) npm start";
else
	-@echo -e "$(backendColor) cd $(resetColor)"; \
	cd $(rootDir); \
	echo -e "$(backendColor) clone $(resetColor)"; \
	git clone $(backendRepo); \
	echo -e "$(backendColor) cd $(resetColor)"; \
	cd $(backendDir); \
	echo -e "$(backendColor) checkout '$(gitBranch)' $(resetColor)"; \
	git checkout $(gitBranch); \
	echo -e "$(backendColor) clear; rm; install $(resetColfinkprodor)"; \
	npm i; \
	echo -e "$(backendColor) delete $(resetColor)"; \
	pm2 delete $(backendTag) ; \
	echo -e "$(backendColor) deploy '$(backendPort)' $(resetColor)"; \
	pm2 start --name $(backendTag) "PORT=$(backendPort) npm start";
endif

setup:
	-mkdir $(rootDir)

clean: 
	echo '$(shell tput setaf 1) no clean rules'
	-rm -rf $(rootDir)
	-pm2 delete frontend
	-pm2 delete backend
