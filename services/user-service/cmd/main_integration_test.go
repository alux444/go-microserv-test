package main

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"os"
	"testing"

	"github.com/alux444/go-microserv-test/services/user-service/internal/database"
)

func TestUsersEndpointIntegration(t *testing.T) {
	os.Setenv("POSTGRES_HOST", "localhost")
	os.Setenv("POSTGRES_PORT", "5432")
	os.Setenv("POSTGRES_USER", "postgres")
	os.Setenv("POSTGRES_PASSWORD", "postgres")
	os.Setenv("POSTGRES_DB", "microservice_db")

	db, err := database.Connect()
	if err != nil {
		t.Errorf("Error in integration test - database not available: %v", err)
		return
	}
	defer db.Close()

	router := setupRouter(db)

	req, _ := http.NewRequest("GET", "/users", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	if w.Code != http.StatusOK {
		t.Errorf("Expected status 200, got: %d", w.Code)
	}

	var response map[string][]map[string]any
	if err := json.Unmarshal(w.Body.Bytes(), &response); err != nil {
		t.Errorf("Failed to parse response: %v", err)
	}

	users := response["users"]
	if len(users) == 0 {
		t.Error("Expected at least one user in the database")
	}

	if users[0]["id"] == nil || users[0]["email"] == nil || users[0]["username"] == nil {
		t.Error("User object missing required fields")
	}
}
