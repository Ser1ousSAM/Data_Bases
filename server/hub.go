package main

import (
	"bytes"
	"io/ioutil"
	"log"
	"net/http"
)

type Hub struct {
	clients    map[*Client]bool
	register   chan *Client
	unregister chan *Client
}

func newHub() *Hub {
	return &Hub{
		register:   make(chan *Client),
		unregister: make(chan *Client),
		clients:    make(map[*Client]bool),
	}
}

/*
здесь принимаю запрос с нейронки Post-методом и передаю его в
data_Base пакет в функцию Insert.
*/
func (h *Hub) serve(w http.ResponseWriter, r *http.Request) {
	url := "some url from neural"

	requestBody := []byte(`{}`)
	client := &http.Client{}

	request, err := http.NewRequest(http.MethodPost, url, bytes.NewBuffer(requestBody))
	if err != nil {
		log.Fatal("Error while creating query:", err)
		return
	}

	response, err := client.Do(request)
	if err != nil {
		log.Fatal("Error while sending query:", err)
		return
	}
	defer response.Body.Close()

	body, err := ioutil.ReadAll(response.Body)
	if err != nil {
		log.Fatal("Error while reading query:", err)
		return
	}
	//Здесь должна быть отправка и в бд и на все подключенные клиенты?
	return
}

// func (h *Hub) run() {
// 	for {
// 		select {
// 		case client := <-h.register:
// 			h.clients[client] = true
// 		case client := <-h.unregister:
// 			if _, ok := h.clients[client]; ok {
// 				delete(h.clients, client)
// 			}
// 		}
// 	}
// }
