.PHONY: run-locally build-docker-image run-docker push-public run-kubernetes

main: main.go
	go build main.go

build-locally: main

run-locally: build-locally
	go build main.go
	./main

# Builds the Docker image locally
build-docker-image:
	docker build -t toy-server .

# Runs the Docker image locally
run-docker: build-docker-image
	docker run -it --rm --name toy-server --publish 3000:3000 toy-server

# Pushes a new image to the PUBLIC Docker registry
push-public: build-docker-image
	docker tag toy-server mejibyte/toy-server:stable
	docker push mejibyte/toy-server:stable

# Builds a new image, runs it in Kubernetes and opens the URLs in the browser.
run-kubernetes: build-docker-image push-public
	kubectl delete -f k8s/deployment1.yaml
	kubectl delete -f k8s/service1.yaml
	kubectl apply -f k8s/deployment1.yaml
	kubectl apply -f k8s/service1.yaml
	kubectl wait -f k8s/deployment1.yaml --for condition=available
	minikube service toy-server-service1