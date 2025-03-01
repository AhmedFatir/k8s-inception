all:
	kubectl apply -Rf ./k8s

clean:
	kubectl delete -Rf ./k8s

re: clean all