CREATE TABLE users (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  full_name   VARCHAR(150) NOT NULL,
  email       VARCHAR(150) NOT NULL UNIQUE,
  password    VARCHAR(255) NOT NULL,
  role        ENUM('admin','vendor','student') NOT NULL DEFAULT 'student',
  phone       VARCHAR(20),
  avatar_url  VARCHAR(255),
  is_active   TINYINT(1) DEFAULT 1,
  last_login  DATETIME,
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE vendors (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  user_id         INT NOT NULL UNIQUE,
  business_name   VARCHAR(200) NOT NULL,
  slug            VARCHAR(200) NOT NULL UNIQUE,
  description     TEXT,
  location        VARCHAR(255) NOT NULL,
  phone           VARCHAR(20),
  whatsapp        VARCHAR(20),
  opening_time    TIME,
  closing_time    TIME,
  profile_image   VARCHAR(255),
  banner_image    VARCHAR(255),
  status          ENUM('pending','approved','rejected','blocked') DEFAULT 'pending',
  avg_rating      DECIMAL(3,2) DEFAULT 0.00,
  total_ratings   INT DEFAULT 0,
  created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE categories (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(100) NOT NULL UNIQUE,
  icon        VARCHAR(10),
  sort_order  INT DEFAULT 0,
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO categories (name, icon, sort_order) VALUES
  ('Local Dishes','🍚',1), ('Breakfast','🍳',2), ('Beverages','☕',3),
  ('Snacks','🥪',4), ('Fast Food','🍟',5), ('Fruits','🍎',6),
  ('Vegetarian','🥗',7), ('Specials','⭐',8);

CREATE TABLE food_items (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  vendor_id     INT NOT NULL,
  category_id   INT NOT NULL,
  name          VARCHAR(200) NOT NULL,
  description   TEXT,
  price         DECIMAL(10,2) NOT NULL,
  image_url     VARCHAR(255),
  is_available  TINYINT(1) DEFAULT 1,
  is_featured   TINYINT(1) DEFAULT 0,
  serving_size  VARCHAR(100),
  calories      INT,
  tags          VARCHAR(255),
  avg_rating    DECIMAL(3,2) DEFAULT 0.00,
  total_ratings INT DEFAULT 0,
  views         INT DEFAULT 0,
  created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (vendor_id) REFERENCES vendors(id) ON DELETE CASCADE,
  FOREIGN KEY (category_id) REFERENCES categories(id),
  INDEX idx_vendor_available (vendor_id, is_available),
  INDEX idx_price (price),
  FULLTEXT idx_search (name, description, tags)
);

CREATE TABLE ratings (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  food_id     INT NOT NULL,
  vendor_id   INT NOT NULL,
  user_id     INT,
  ip_address  VARCHAR(45),
  stars       TINYINT NOT NULL CHECK (stars BETWEEN 1 AND 5),
  comment     TEXT,
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_user_food (user_id, food_id),
  FOREIGN KEY (food_id) REFERENCES food_items(id) ON DELETE CASCADE,
  FOREIGN KEY (vendor_id) REFERENCES vendors(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE favorites (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  user_id     INT NOT NULL,
  food_id     INT NOT NULL,
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_fav (user_id, food_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (food_id) REFERENCES food_items(id) ON DELETE CASCADE
);

CREATE TABLE notifications (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  user_id     INT NOT NULL,
  title       VARCHAR(200) NOT NULL,
  message     TEXT NOT NULL,
  type        ENUM('approval','rejection','warning','info') DEFAULT 'info',
  is_read     TINYINT(1) DEFAULT 0,
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE refresh_tokens (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  user_id     INT NOT NULL,
  token       VARCHAR(512) NOT NULL UNIQUE,
  expires_at  DATETIME NOT NULL,
  revoked     TINYINT(1) DEFAULT 0,
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);