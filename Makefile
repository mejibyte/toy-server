.PHONY: build run push-public run-kubernetes

# Builds the Docker image locally
build:
	docker build -t toy-server .

# Runs the Docker image locally
run: build
	docker run -it --rm --name toy-server --publish 3000:3000 toy-server

# Pushes a new image to the PUBLIC Docker registry
push-public: build
	docker tag toy-server mejibyte/toy-server:stable
	docker push mejibyte/toy-server:stable

# Builds a new image, runs it in Kubernetes and opens the URLs in the browser.
run-kubernetes: build push-public
	kubectl delete -f k8s/deployment1.yaml
	kubectl delete -f k8s/service1.yaml
	kubectl apply -f k8s/deployment1.yaml
	kubectl apply -f k8s/service1.yaml
	kubectl wait -f k8s/deployment1.yaml --for condition=available
	minikube service toy-server-service1