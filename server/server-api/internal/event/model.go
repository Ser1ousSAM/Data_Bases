package event

type Event struct {
	Id          int    `json:"id"`
	Camera_id   int    `json:"camera_id"`
	Description string `json:"description"`
	Time_stamp  string `json:"time_stamp"`
	Photo       []byte `json:"photo"`
}
