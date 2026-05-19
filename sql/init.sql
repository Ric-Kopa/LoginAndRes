-- 创建数据库
CREATE DATABASE IF NOT EXISTS loginregister DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE loginregister;

-- 创建用户表
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS users;
CREATE TABLE users (
                       id INT AUTO_INCREMENT PRIMARY KEY,
                       username VARCHAR(50) NOT NULL UNIQUE,
                       password VARCHAR(32) NOT NULL,
                       nickname VARCHAR(50) NOT NULL,
                       phone VARCHAR(11) NOT NULL,
                       email VARCHAR(100) NOT NULL,
                       avatar VARCHAR(255),
                       create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                       INDEX idx_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建留言表
CREATE TABLE messages (
                          id INT AUTO_INCREMENT PRIMARY KEY,
                          user_id INT NOT NULL,
                          content TEXT NOT NULL,
                          create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                          FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                          INDEX idx_user_id (user_id),
                          INDEX idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建管理员表
DROP TABLE IF EXISTS admins;
CREATE TABLE admins (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        username VARCHAR(50) NOT NULL UNIQUE,
                        password VARCHAR(32) NOT NULL,
                        nickname VARCHAR(50) NOT NULL,
                        create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                        INDEX idx_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 插入默认管理员账号 (admin / admin123)
INSERT INTO admins (username, password, nickname) VALUES
    ('admin', 'e10adc3949ba59abbe56e057f20f883e', '系统管理员');
