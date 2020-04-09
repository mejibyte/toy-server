.PHONY: build run

# Builds the Docker image locally
build:
	docker build -t amejia-toy-server .

# Runs the Docker image locally
run: build
	docker run -it --rm --name amejia-toy-server --publish 3000:3000 amejia-toy-server