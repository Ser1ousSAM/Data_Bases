package camera

import (
	"context"
	"errors"
	"fmt"
	"github.com/jackc/pgconn"
	"main/internal/camera"
	"main/pkg/client/postgresql"
	"main/pkg/logging"
	"strings"
)

type repository struct {
	client postgresql.Client
	logger *logging.Logger
}

func NewRepository(client postgresql.Client, logger *logging.Logger) camera.Repository {
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

func (r *repository) Create(ctx context.Context, camera *camera.Camera) error {
	q := `
		INSERT INTO camera 
		    (name, processing_period, stream, areas) 
		VALUES 
		       ($1, $2, $3, $4) 
		RETURNING id
	`
	r.logger.Trace(fmt.Sprintf("SQL Query: %s", formatQuery(q)))
	_, err := r.client.Exec(ctx, q, camera.Name,
		camera.Processing_period, camera.Stream, camera.Areas)
	if err != nil {
		throwErr(r, err)
	}
	return nil
}

func (r *repository) Update(ctx context.Context, camera *camera.Camera) error {
	q := `
		UPDATE camera 
		SET name = $1,
		   processing_period = $2,
		   stream = $3,
		   areas = $4
		RETURNING id
	`
	r.logger.Trace(fmt.Sprintf("SQL Query: %s", formatQuery(q)))
	_, err := r.client.Exec(ctx, q, camera.Name,
		camera.Processing_period, camera.Stream, camera.Areas)
	if err != nil {
		throwErr(r, err)
	}
	return nil
}

func (r *repository) DeleteByID(ctx context.Context, id int) error {
	q := `
		DELETE FROM camera 
		WHERE id = $1
		RETURNING id
	`
	r.logger.Trace(fmt.Sprintf("SQL Query: %s", formatQuery(q)))
	_, err := r.client.Exec(ctx, q, id)
	if err != nil {
		throwErr(r, err)
	}
	return nil
}

func (r *repository) GetById(ctx context.Context, id int) (camera.Camera, error) {
	q := `
		SELECT id, name, processing_period, stream, areas
		FROM camera
		WHERE id = &1
	`
	r.logger.Trace(fmt.Sprintf("SQL Query: %s", formatQuery(q)))
	var cam camera.Camera = camera.Camera{}
	rows, err := r.client.Query(ctx, q, id)
	if err != nil {
		return cam, err
	}
	err = rows.Scan(&cam.Id)
	if err = rows.Err(); err != nil {
		return cam, err
	}
	return cam, nil
}

func (r *repository) GetAll(ctx context.Context) ([]camera.Camera, error) {
	q := `
		SELECT id, name, processing_period, stream, areas
		FROM camera
	`
	r.logger.Trace(fmt.Sprintf("SQL Query: %s", formatQuery(q)))

	rows, err := r.client.Query(ctx, q)
	if err != nil {
		return nil, err
	}
	cameras := make([]camera.Camera, 0)
	for rows.Next() {
		var cam camera.Camera
		err = rows.Scan(&cam.Id)
		if err != nil {
			return nil, err
		}
		cameras = append(cameras, cam)
	}
	if err = rows.Err(); err != nil {
		return nil, err
	}
	return cameras, nil
}
