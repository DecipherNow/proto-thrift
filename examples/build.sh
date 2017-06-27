#!/bin/sh

: ${GOPATH:=$HOME/go}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

# Include paths for requisite *.proto files.
GENHOME=$GOPATH/src/github.com/golang/protobuf
INCLUDE="$(dirname "$(which protoc)")/../include"
INCLUDE="$INCLUDE:$GENHOME/thrift"

echo "Generating gRPC code . . ."
protoc \
  --proto_path=./ \
  --proto_path=$INCLUDE \
  hello.proto \
  --go_out=plugins=grpc:.

THRIFT_PATH=github.com/golang/protobuf/examples/thrift

echo "Generating Thrift IDL & proxy . . ."
protoc \
  --proto_path=./ \
  --proto_path=$INCLUDE \
  --plugin=protoc-gen-custom=$GENHOME/gen-thrift \
  --custom_out=thrift_path=$THRIFT_PATH:. \
  hello.proto

echo "Generating Go code from Thrift IDL . . ."
generator hello.thrift $PWD/thrift-build
mv $PWD/thrift-build/*/* thrift
rm -r $PWD/thrift-build

mkdir -p build

echo "Building example proxy . . ."
go build -o build/proxy ./proxy

echo "Building example client . . ."
go build -o build/client ./client

echo "Building example server . . ."
go build -o build/server ./server
