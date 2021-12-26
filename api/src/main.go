package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/gorilla/mux"
	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
)

func setupPostgres() (*sql.DB, error) {
	errorCheck(godotenv.Load(".env"))
	port := os.Getenv("PORT")
	user := os.Getenv("DB_USER")
	password := os.Getenv("DB_PASSWORD")
	database := os.Getenv("DB_NAME")

	dbInfo := fmt.Sprintf("port=%s user=%s password=%s dbname=%s sslmode=disable", port, user, password, database)
	return sql.Open("postgres", dbInfo)
}

// Message holds the structure of the you confluence
type Message struct {
	Id          string    `json:"id"`
	Content     string    `json:"content"`
	PublishedAt time.Time `json:"date"`
}

func errorCheck(err error) {
	if err != nil {
		fmt.Println(err)
		panic(err)
	}
}

func getAllMessages() []Message {
	db, err := setupPostgres()
	errorCheck(err)
	defer db.Close()

	rows, err := db.Query("SELECT * FROM messages")
	errorCheck(err)

	messages := []Message{}

	for rows.Next() {
		message := Message{}
		errorCheck(rows.Scan(&message.Id, &message.Content, &message.PublishedAt))
		messages = append(messages, message)
	}

	return messages
}

func homeHandler(w http.ResponseWriter, request *http.Request) {
	fmt.Println("Home Handler")
	messages := getAllMessages()
	w.Header().Set("content-type", "application/json")
	json.NewEncoder(w).Encode(messages)
}

func main() {
	router := mux.NewRouter().StrictSlash(true)
	router.HandleFunc("/api/home", homeHandler).Methods("GET")
	fmt.Println("Listening on localhost:8081")
	log.Fatal(http.ListenAndServe(":8081", router))
}
