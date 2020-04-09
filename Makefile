.PHONY: build run

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
