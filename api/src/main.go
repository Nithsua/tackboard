package main

import (
	"fmt"
	"log"
	"net/http"
)

func homeHandler(w http.ResponseWriter , request *http.Request) {
	fmt.Fprintln(w, "Hallo from Tackboard")
}

func main() {
	http.HandleFunc("/", homeHandler)
	fmt.Println("Listening on localhost:8000")
	log.Fatal(http.ListenAndServe(":8000", nil))
}