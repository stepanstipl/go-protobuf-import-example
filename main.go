package main

import (
	"context"
	"flag"
	"fmt"
	_ "github.com/gogo/protobuf/proto"
	"github.com/stepanstipl/go-protobuf-import-example/pb"
	"google.golang.org/grpc"
	"k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"log"
	"net"
)

var (
	port = flag.Int("port", 10001, "The server port")
	address = flag.String("address", "localhost", "The server address")
)

type demoServer struct {
}

func (s *demoServer) GetInfo(ctx context.Context, in *pb.Empty) (*pb.Info, error) {
	pod := &v1.Pod{
		TypeMeta: metav1.TypeMeta{
			Kind:       "Pod",
			APIVersion: "v1",
		},
		ObjectMeta: metav1.ObjectMeta{
			Name: "test-pod",
		},
		Spec: v1.PodSpec{
			Containers: []v1.Container{
				{
					Name:  "test",
					Image: "alpine",
				},
			},
		},
	}

	info := &pb.Info{
		Id:                   "test",
		Message:              "Hello world",
		Pod:                  pod,
	}

	return info, nil
}

func newDemoServer() *demoServer {
	return &demoServer{}
}

func main() {
	flag.Parse()

	// Create server
	lis, err := net.Listen("tcp", fmt.Sprintf("%s:%d", *address, *port))
	if err != nil {
		log.Fatalf("Failed to listen: %v", err)
	}

	var opts []grpc.ServerOption

	// Create gRPC server
	log.Printf("Starting GRPC server on port %d", *port)
	grpcServer := grpc.NewServer(opts...)

	//  Register our server
	myServer := newDemoServer()
	pb.RegisterDemoServer(grpcServer, myServer)

	// Run
	grpcServer.Serve(lis)
}
