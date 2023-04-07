package camera

import (
	"context"
)

type Repository interface {
	Create(ctx context.Context, camera *Camera) error
	Update(ctx context.Context, camera *Camera) error
	DeleteByID(ctx context.Context, id int) error
	GetById(ctx context.Context, id int) (Camera, error)
	GetAll(ctx context.Context) ([]Camera, error)
}
