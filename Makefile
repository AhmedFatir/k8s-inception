all:
	kubectl apply -f Env -f Volumes -f Deployments

clean:
	kubectl delete -f Deployments -f Volumes -f Env

re: clean all