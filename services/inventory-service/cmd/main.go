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
			"service": "inventory-service",
		})
	})

	log.Println("Inventory service starting on :50051")
	router.Run(":50051")
}
