#!/bin/sh

# descriptor path: $(dirname "$(which protoc)")/../include/google/protobuf/descriptor.proto

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

INCLUDE=$(dirname "$(which protoc)")/../include
INCLUDE=$INCLUDE:$DIR/thrift

protoc --proto_path=./ --proto_path=$INCLUDE --go_out=. thrift/*.proto
sed -i "thrift/thrift.pb.go" -e 's|"google/protobuf"|"github.com/golang/protobuf/protoc-gen-go/descriptor"|'
go build -o gen-go ./protoc-gen-go
protoc --proto_path=./ --proto_path=$INCLUDE --plugin=protoc-gen-custom=gen-go --custom_out=./build hello.proto

# build/hello.thrift
