INCLUDE := $(shell readlink -f $$(dirname "$$(which protoc)")/../include)

regenerate:
	protoc --go_out=. --proto_path=./ --proto_path=$(INCLUDE) thrift.proto && \
		sed -i "thrift.pb.go" -e 's|"google/protobuf"|"github.com/golang/protobuf/protoc-gen-go/descriptor"|'
