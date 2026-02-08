package main

import (
	"log"
	"net/http"

	"github.com/alux444/go-microserv-test/api-gateway/internal/database"
	"github.com/gin-gonic/gin"
)

func main() {
	db, err := database.Connect()
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}
	defer db.Close()
	log.Println("Connected to db successfully")

	router := gin.Default()

	router.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status":  "healthy",
			"service": "user-service",
		})
	})

	router.GET("/users", func(c *gin.Context) {
		const query string = "SELECT id, email, username FROM user_service.users LIMIT 10"
		rows, err := db.Query(query)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{
				"error": err.Error(),
			})
		}
		defer rows.Close()

		type User struct {
			ID       int    `json:"id"`
			Email    string `json:"email"`
			Username string `json:"username"`
		}

		users := []User{}
		for rows.Next() {
			var u User
			if err := rows.Scan(&u.ID, &u.Email, &u.Username); err != nil {
				continue
			}
			users = append(users, u)
		}

		c.JSON(http.StatusOK, gin.H{"users": users})
	})

	log.Println("User service starting on :50054")
	router.Run(":50054")
}
