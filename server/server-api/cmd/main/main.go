package main

import (
	"context"
	"fmt"
	"github.com/julienschmidt/httprouter"
	camera2 "main/internal/camera"
	camera "main/internal/camera/db"
	"main/internal/config"
	"main/pkg/client/postgresql"
	"main/pkg/logging"
	"net"
	"net/http"
	"time"
)

func main() {
	logger := logging.GetLogger()
	logger.Info("create router")
	router := httprouter.New()

	cfg := config.GetConfig()

	postgreSQLClient, err := postgresql.NewClient(context.TODO(), 3, cfg.Storage)
	if err != nil {
		logger.Fatalf("%v", err)
	}

	repository := camera.NewRepository(postgreSQLClient, logger)
	c := camera2.Camera{
		Name: "first",
	}

	err = repository.Create(context.TODO(), &c)
	if err != nil {
		logger.Fatal(err)
	}

	logger.Info("register camera handler")
	cameraHandler := camera2.NewHandler(repository, logger)
	cameraHandler.Register(router)

	start(router, cfg)
}

func start(router *httprouter.Router, cfg *config.Config) {
	logger := logging.GetLogger()
	logger.Info("start application")

	var listener net.Listener
	var listenErr error

	logger.Info("listen tcp")
	listener, listenErr = net.Listen("tcp", fmt.Sprintf("%s:%s", cfg.Listen.BindIP, cfg.Listen.Port))
	logger.Infof("server is listening port %s:%s", cfg.Listen.BindIP, cfg.Listen.Port)

	if listenErr != nil {
		logger.Fatal(listenErr)
	}

	server := &http.Server{
		Handler:      router,
		WriteTimeout: 15 * time.Second,
		ReadTimeout:  15 * time.Second,
	}

	logger.Fatal(server.Serve(listener))
}
