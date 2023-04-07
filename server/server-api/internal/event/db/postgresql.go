package event

import (
	"context"
	"errors"
	"fmt"
	"github.com/jackc/pgconn"
	"main/internal/event"
	"main/pkg/client/postgresql"
	"main/pkg/logging"
	"strings"
)

type repository struct {
	client postgresql.Client
	logger *logging.Logger
}

func NewRepository(client postgresql.Client, logger *logging.Logger) event.Repository {
	return &repository{
		client: client,
		logger: logger,
	}
}

func formatQuery(q string) string {
	return strings.ReplaceAll(strings.ReplaceAll(q, "\t", ""), "\n", " ")
}

func throwErr(r *repository, err error) error {
	var pgErr *pgconn.PgError
	if errors.As(err, &pgErr) {
		pgErr = err.(*pgconn.PgError)
		newErr := fmt.Errorf(fmt.Sprintf("SQL Error: %s, Detail: %s, Where: %s, Code: %s, SQLState: %s", pgErr.Message, pgErr.Detail, pgErr.Where, pgErr.Code, pgErr.SQLState()))
		r.logger.Error(newErr)
		return newErr
	}
	return err
}

func (r *repository) Create(ctx context.Context, event *event.Event) error {
	q := `
		INSERT INTO event 
		    (camera_id, description, time_stamp, photo) 
		VALUES 
		       ($1, $2, $3, $4) 
		RETURNING id
	`
	r.logger.Trace(fmt.Sprintf("SQL Query: %s", formatQuery(q)))
	_, err := r.client.Exec(ctx, q, event.Camera_id,
		event.Description, event.Time_stamp, event.Photo)
	if err != nil {
		throwErr(r, err)
	}
	return nil
}

func (r *repository) GetAll(ctx context.Context) ([]event.Event, error) {
	q := `
		SELECT id, camera_id, description, time_stamp, photo
		FROM event
	`
	r.logger.Trace(fmt.Sprintf("SQL Query: %s", formatQuery(q)))

	rows, err := r.client.Query(ctx, q)
	if err != nil {
		return nil, err
	}
	cameras := make([]event.Event, 0)
	for rows.Next() {
		var ev event.Event
		err = rows.Scan(&ev.Id)
		if err != nil {
			return nil, err
		}
		cameras = append(cameras, ev)
	}
	if err = rows.Err(); err != nil {
		return nil, err
	}
	return cameras, nil
}
