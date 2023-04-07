package camera

type Camera struct {
	Id                int    `json:"id"`
	Name              string `json:"name"`
	Processing_period int    `json:"processing_period"`
	Stream            string `json:"stream"`
	Areas             string `json:"areas"`
}
