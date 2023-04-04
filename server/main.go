package main

import (
	"context"
	"log"
	"net/http"

	"github.com/jackc/pgx/v5"
)

func main() {
	//Connecting to DB
	connString := "postgres://user:password@host:port/database"
	config, err := pgx.ParseConfig(connString)
	if err != nil {
		log.Fatalf("Unable to parse config: %v\n", err)
	}
	config.Host = "localhost"
	config.User = "postgres"
	config.Database = "hackaton"
	config.Password = "password"
	config.Port = 5432

	DBconn, err := pgx.ConnectConfig(context.Background(), config)
	if err != nil {
		log.Fatalf("Unable to connect to database: %v\n", err)
	}
	defer DBconn.Close(context.Background())

	hub := newHub()
	//как связать hub и data

	// go hub.run()

	http.HandleFunc("/ws", hub.serve)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
