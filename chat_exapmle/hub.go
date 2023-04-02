package main

/*
Hub maintains the set of active clients and broadcasts messages to the
clients.
*/
type Hub struct {
	// Registered clients.
	clients map[*Client]bool
	// Inbound messages from the clients.
	broadcast chan []byte

	// Register requests from the clients.
	register chan *Client

	// Unregister requests from clients.
	unregister chan *Client
}

func newHub() *Hub {
	return &Hub{
		broadcast:  make(chan []byte),
		register:   make(chan *Client),
		unregister: make(chan *Client),
		clients:    make(map[*Client]bool),
	}
}

func (h *Hub) run() {
	for {
		select {
		case client := <-h.register:
			h.clients[client] = true

		/*
			Зарегистрированные и незарегистрированные в данном
			контексте это значит подключен кто-то к сессии на странице
			или не подключён?
		*/
		case client := <-h.unregister:
			if _, ok := h.clients[client]; ok {
				//Тех, кто подключился, удаляем вместе с посланной им инфой?
				delete(h.clients, client)
				close(client.send)
			}
		/*Обрабатываем полученные сообщения от каждого клиента
		и рассылаем всем, кто подключен*/
		case message := <-h.broadcast:
			for client := range h.clients {
				select {
				case client.send <- message:
				default:
					/*
						А зачем здесь закрывать соединение и удалять клиента из хаба?
						Мы ведь в прошлом обработчике канала смотрим на подключения
						и если кто-то отключился, то делаем то же самое.
					*/
					close(client.send)
					delete(h.clients, client)
				}
			}
		}
	}
}
