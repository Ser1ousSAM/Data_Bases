package event

import "context"

type Repository interface {
	Create(ctx context.Context, event *Event) error
	GetAll(ctx context.Context) ([]Event, error)
}
