# proto-thrift

proto-thrift is a plugin of [protoc](http://github.com/google/protobuf).
It reads [gRPC](https://grpc.io/) service definitions and generates a
reverse-proxy server which translates Thrift messages into gRPC.

## Installation ##

To use this software, you must:
- Install the standard C++ implementation of protocol buffers from
	https://developers.google.com/protocol-buffers/
- Of course, install the Go compiler and tools from
	https://golang.org/
  See
	https://golang.org/doc/install
  for details or, if you are using gccgo, follow the instructions at
	https://golang.org/doc/install/gccgo
- Grab the code from the repository and install the proto package.
  The simplest way is to run `go get -u github.com/google/protobuf/proto github.com/deciphernow/proto-thrift/protoc-gen-thrift`.
  The compiler plugin, protoc-gen-thrift, will be installed in $GOBIN,
  defaulting to $GOPATH/bin.  It must be in your $PATH for the protocol
  compiler, protoc, to find it.

## Usage

To generate Thrift IDL and gRPC service proxy:

    $ GENHOME=$GOPATH/src/github.com/deciphernow/proto-thrift
    $ THRIFT_PATH="<path where you want Thrift code to go>"
    $ INCLUDE="$(dirname "$(which protoc)")/../include"
    $ INCLUDE="$INCLUDE:$GENHOME/thrift"
    $ protoc --proto_path=./ --proto_path=$INCLUDE --plugin=protoc-gen-custom=protoc-gen-thrift --custom_out=thrift_path=$THRIFT_PATH:. hello.proto 

Then generate Go code from the Thrift IDL:

    $ generator hello.thrift $PWD/thrift-build
