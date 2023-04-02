package main

import (
	"context"
	"log"
	"net/http"

	"github.com/jackc/pgx/v5"
)

const (
	host       = "localhost"
	port       = 5432
	dbuser     = "postgres"
	dbpassword = "123123"
	dbname     = "hackaton_2023"
)

type DB_Sender interface {
	INSERT()
}

// type dbEntity struct {
// 	data interface{}
// }

// type Camera struct {
// 	id                int
// 	name              string
// 	processing_period string
// 	stream            string
// 	areas             string
// }

type Event struct {
	id          int
	camera_id   int
	description string
	time_stamp  string
	photo       string
}

// А зачем мне интерфейс, если я буду только ивентами оперировать и только их передавать?
func (Event) INSERT(conn *pgx.Conn, e Event) error {
	query_sql := `INSERT INTO event 
	(id, camera_id, description, time_stamp, photo) 
	VALUES ($1, $2, $3, $4, $5)`

	_, err := conn.Exec(context.Background(), query_sql,
		e.id, e.camera_id, e.description, e.time_stamp, e.photo)
	if err != nil {
		return err
	}

	return nil
}

func handleRequest(w http.ResponseWriter, r *http.Request) {
	WebSocketconn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println(err)
		return
	}
	defer WebSocketconn.Close()

	if err != nil {
		panic(err)
	}

	config, _ := pgx.ParseConfig("")
	config.Host = host
	config.Port = port
	config.User = dbuser
	config.Password = dbpassword
	config.Database = dbname

	dbconn, err := pgx.ConnectConfig(context.Background(), config)
	if err != nil {
		panic(err)
	}
	defer dbconn.Close(context.Background())

	msgChan := make(chan Event)

	// Send messages to the client as they come in
	for {
		msg := <-msgChan
		err := WebSocketconn.WriteJSON(msg)
		if err != nil {
			log.Println(err)
			return
		}
	}
}
