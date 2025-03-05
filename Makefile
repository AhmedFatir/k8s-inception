all:
	bash ./k8s/deploy.sh

clean:
	kubectl delete -Rf ./k8s

re: clean all