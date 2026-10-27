-- ============================================================
-- E-Waste Management Application — Database Schema
-- ============================================================

CREATE DATABASE IF NOT EXISTS ewaste_db;
USE ewaste_db;

-- ------------------------------------------------------------
-- Master: Categories
-- ------------------------------------------------------------
CREATE TABLE tbl_master_categories (
    category_id     INT AUTO_INCREMENT PRIMARY KEY,
    category_name   VARCHAR(100) NOT NULL,
    category_photo  VARCHAR(255),
    category_status TINYINT(1) NOT NULL DEFAULT 1  -- 1 = Active, 0 = Inactive
);

-- ------------------------------------------------------------
-- Master: Brands
-- ------------------------------------------------------------
CREATE TABLE tbl_master_brands (
    brand_id          INT AUTO_INCREMENT PRIMARY KEY,
    category_id       INT NOT NULL,
    brand_name        VARCHAR(100) NOT NULL,
    brand_description VARCHAR(255),
    brand_photo       VARCHAR(255),
    brand_status      TINYINT(1) NOT NULL DEFAULT 1,
    CONSTRAINT fk_brand_category FOREIGN KEY (category_id)
        REFERENCES tbl_master_categories (category_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- Master: Models
-- ------------------------------------------------------------
CREATE TABLE tbl_master_models (
    model_id               INT AUTO_INCREMENT PRIMARY KEY,
    brand_id               INT NOT NULL,
    category_id            INT NOT NULL,
    model_name             VARCHAR(100) NOT NULL,
    model_description      VARCHAR(255),
    model_photo            VARCHAR(255),
    credit_points_plus_10  DECIMAL(10, 2) DEFAULT 0.00,
    credit_points_plus_20  DECIMAL(10, 2) DEFAULT 0.00,
    credit_points_plus_50  DECIMAL(10, 2) DEFAULT 0.00,
    credit_points_plus_80  DECIMAL(10, 2) DEFAULT 0.00,
    credit_points_less_50  DECIMAL(10, 2) DEFAULT 0.00,
    model_status           TINYINT(1) NOT NULL DEFAULT 1,
    CONSTRAINT fk_model_brand    FOREIGN KEY (brand_id)
        REFERENCES tbl_master_brands (brand_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_model_category FOREIGN KEY (category_id)
        REFERENCES tbl_master_categories (category_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- Master: Conditions
-- ------------------------------------------------------------
CREATE TABLE tbl_master_conditions (
    condition_id     INT AUTO_INCREMENT PRIMARY KEY,
    condition_name   VARCHAR(100) NOT NULL,
    anticipated_score DECIMAL(5, 2) DEFAULT 0.00,
    condition_status TINYINT(1) NOT NULL DEFAULT 1
);

-- ------------------------------------------------------------
-- Operations: Users
-- ------------------------------------------------------------
CREATE TABLE tbl_operations_user (
    user_id            INT AUTO_INCREMENT PRIMARY KEY,
    user_name          VARCHAR(100) NOT NULL,
    user_email         VARCHAR(150) NOT NULL UNIQUE,
    user_mobile        VARCHAR(15) NOT NULL UNIQUE,
    user_registered_on DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    user_profile_photo VARCHAR(255),
    user_status        TINYINT(1) NOT NULL DEFAULT 1
);

-- ------------------------------------------------------------
-- Operations: Orders
-- ------------------------------------------------------------
CREATE TABLE tbl_operations_order (
    order_id           INT AUTO_INCREMENT PRIMARY KEY,
    order_user         INT NOT NULL,
    order_date         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    order_category     INT NOT NULL,
    order_brand        INT NOT NULL,
    order_model        INT NOT NULL,
    order_condition    INT NOT NULL,
    ai_anticipation    DECIMAL(5, 2) DEFAULT 0.00,
    ai_suggestion      TEXT,
    order_qty          INT NOT NULL DEFAULT 1,
    evacuated_condition INT,
    credit_points      DECIMAL(10, 2) DEFAULT 0.00,
    order_status       TINYINT(1) NOT NULL DEFAULT 1,
    CONSTRAINT fk_order_user      FOREIGN KEY (order_user)
        REFERENCES tbl_operations_user (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_order_category  FOREIGN KEY (order_category)
        REFERENCES tbl_master_categories (category_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_order_brand     FOREIGN KEY (order_brand)
        REFERENCES tbl_master_brands (brand_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_order_model     FOREIGN KEY (order_model)
        REFERENCES tbl_master_models (model_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_order_condition FOREIGN KEY (order_condition)
        REFERENCES tbl_master_conditions (condition_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- Operations: Order Images
-- ------------------------------------------------------------
CREATE TABLE tbl_operations_order_images (
    image_id   INT AUTO_INCREMENT PRIMARY KEY,
    order_id   INT NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    CONSTRAINT fk_image_order FOREIGN KEY (order_id)
        REFERENCES tbl_operations_order (order_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
