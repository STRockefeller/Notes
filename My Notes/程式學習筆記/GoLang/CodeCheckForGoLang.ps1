"go mod tidy"
go mod tidy
"go test ./... -count 1"
go test ./... -count 1 --race
"go vet ./..."
go vet ./...
"golint ./..."
golint ./...