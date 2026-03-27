#8 ERROR: failed to calculate checksum of ref ... "/go.sum": not found
cd https://github.com/Web4application/gpt-5-mini
python -m venv myenv
myenv\Scripts\activate
source myenv/bin/activate
pip install -r requirements.txt
go mod tidy
ls -la go.mod go.sum
cat .dockerignore
docker build -t myapp .
ls -la
cat go.mod
cat go.sum
ls -la
cat go.mod
cat go.sum
docker build -f deploy/Dockerfile -t myapp .
myapp/
  go.mod
  go.sum
  main.go
  cmd/
  internal/
  deploy/
    Dockerfile
    backend/
  go.mod
  go.sum
  Dockerfile
  cd deploy
docker build -f Dockerfile .
docker build -f deploy/Dockerfile .
