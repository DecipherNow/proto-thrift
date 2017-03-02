package main

import (
	"fmt"
	"log"
	"net"
	"net/rpc"

	"google.golang.org/grpc"

	"github.com/samuel/go-thrift/thrift"

	pb "github.com/golang/protobuf/examples"

	hello_thrift "github.com/golang/protobuf/examples/thrift"
)

const address = "localhost:50051"

func main() {
	// Set up a connection to the gRPC server.
	conn, err := grpc.Dial(address, grpc.WithInsecure())
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()
	c := pb.NewGreeterClient(conn)

	// Set up proxy Thrift server.
	rpc.RegisterName("Thrift", &hello_thrift.GreeterServer{Implementation: &pb.GreeterImpl{Client: c}})

	ln, err := net.Listen("tcp", ":1463")
	if err != nil {
		panic(err)
	}
	for {
		conn, err := ln.Accept()
		if err != nil {
			fmt.Printf("ERROR: %+v\n", err)
			continue
		}
		fmt.Printf("New connection %+v\n", conn)
		t := thrift.NewTransport(thrift.NewFramedReadWriteCloser(conn, 0), thrift.BinaryProtocol)
		go rpc.ServeCodec(thrift.NewServerCodec(t))
	}
}
