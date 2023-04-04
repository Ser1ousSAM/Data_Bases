package data_Base

import (
	"context"

	"github.com/jackc/pgx/v5"
)

type DB_Sender interface {
	Insert()
}

type Camera struct {
	id                int
	name              string
	processing_period int
	stream            string
	areas             string
}

type Event struct {
	id          int
	camera_id   int
	description string
	time_stamp  string
	photo       []byte
}

func (Event) Insert(DBconn *pgx.Conn, e Event) error {
	query_sql := `INSERT INTO event 
	(id, camera_id, description, time_stamp, photo) 
	VALUES ($1, $2, $3, $4, $5)`

	_, err := DBconn.Exec(context.Background(), query_sql,
		e.id, e.camera_id, e.description, e.time_stamp, e.photo)
	if err != nil {
		return err
	}

	return nil
}
