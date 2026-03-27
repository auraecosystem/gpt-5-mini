docker build -t adyen-gen .
docker run --rm -v $(pwd):/app adyen-gen
