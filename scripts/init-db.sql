-- User Service
CREATE SCHEMA IF NOT EXISTS user_service;

-- Users Service - Users Table
CREATE TABLE IF NOT EXISTS user_service.users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    first_name VARCHAR(255),
    last_name VARCHAR(255)
);

-- Random data
INSERT INTO user_service.users (email, username, password_hash, first_name, last_name) VALUES
('john.doe@example.com', 'johndoe', 'hashed_password_1', 'John', 'Doe'),
('jane.doe@example.com', 'janedoe', 'hashed_password_2', 'Jane', 'Doe')
ON CONFLICT (email) DO NOTHING;