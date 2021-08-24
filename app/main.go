package main

import (
	"context"
	"fmt"
	"log"
	"net/http"

	"github.com/jackc/pgx/v4"
)

func main() {

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		// urlExample := "postgres://username:password@localhost:5432/database_name"
		//conn, err := pgx.Connect(context.Background(), os.Getenv("DATABASE_URL"))
		conn, err := pgx.Connect(context.Background(), "postgres://dbuser:changeme@127.0.0.1:5432/my-database")
		if err == nil {
			fmt.Fprintf(w, "Connected to database \n")
		} else {
			fmt.Fprintf(w, "Unable to connect to database: %v\n", err)
		}
		defer conn.Close(context.Background())

		// var name string
		// var weight int64
		// err = conn.QueryRow(context.Background(), "select name, weight from widgets where id=$1", 42).Scan(&name, &weight)
		// if err != nil {
		// 	fmt.Fprintf(os.Stderr, "QueryRow failed: %v\n", err)
		// }

		// fmt.Println(name, weight)

	})

	log.Println("Listening on localhost:8080")
	log.Fatal(http.ListenAndServe(":8080", nil))

}
