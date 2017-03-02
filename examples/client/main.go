package main

import (
	"fmt"
	"net"

	"github.com/samuel/go-thrift/thrift"

	hello_thrift "thrift-playground/thrift"
)

func strPtr(str string) *string {
	return &str
}

func main() {
	conn, err := net.Dial("tcp", "127.0.0.1:1463")
	if err != nil {
		panic(err)
	}

	t := thrift.NewTransport(thrift.NewFramedReadWriteCloser(conn, 0), thrift.BinaryProtocol)
	client := thrift.NewClient(t, false)
	greeterClient := hello_thrift.GreeterClient{Client: client}
	res, err := greeterClient.SayHello(&hello_thrift.HelloRequest{Arg: &hello_thrift.HelloRequestArg{Name: strPtr("Bob")}})
	if err != nil {
		panic(err)
	}

	fmt.Printf("Response: %+v\n", *res.Message)
}
