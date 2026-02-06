package main

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()

	router.get("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status":  "healthy",
			"service": "notification-service",
		})
	})

	log.Println("Notification service starting on :50052")
	router.Run(":50052")
}
