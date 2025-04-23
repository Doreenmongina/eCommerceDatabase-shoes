 USE eCOMMERCE;

-- Table: brand
CREATE TABLE brand (
    brand_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL
);

-- Table: product_category
CREATE TABLE product_category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE
);

-- Table: color
CREATE TABLE color (
    color_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    hex_code VARCHAR(10) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- Table: size_category
CREATE TABLE size_category (
    size_category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    unit VARCHAR(50),
    is_unisex BOOLEAN DEFAULT FALSE
);

-- Table: size_option
CREATE TABLE size_option (
    option_id INT PRIMARY KEY AUTO_INCREMENT,
    size_category_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    abbreviation VARCHAR(50),
    sort_order INT,
    FOREIGN KEY (size_category_id) REFERENCES size_category(size_category_id)
);

-- Table: product
CREATE TABLE product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    brand_id INT,
    base_price DECIMAL(10, 2),
    category_id INT,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (brand_id) REFERENCES brand(brand_id),
    FOREIGN KEY (category_id) REFERENCES product_category(category_id)
);

-- Table: product_variation
CREATE TABLE product_variation (
    variation_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    name VARCHAR(100) NOT NULL, -- e.g., "Color", "Size"
    variation_type VARCHAR(50), -- Optional enum-like value (text/size)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- Table: product_item
CREATE TABLE product_item (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    color_id INT,
    size_option_id INT,
    price DECIMAL(10, 2),
    sku VARCHAR(255) UNIQUE NOT NULL,
    stock_quantity INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (color_id) REFERENCES color(color_id),
    FOREIGN KEY (size_option_id) REFERENCES size_option(option_id)
);

-- Table: product_image
CREATE TABLE product_image (
    image_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    item_id INT,
    color_id INT,
    image_url TEXT NOT NULL,
    alt_text VARCHAR(255),
    is_primary BOOLEAN DEFAULT FALSE,
    display_order INT,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (item_id) REFERENCES product_item(item_id),
    FOREIGN KEY (color_id) REFERENCES color(color_id)
);

-- Table: attribute_category
CREATE TABLE attribute_category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    display_order INT,
    is_default BOOLEAN DEFAULT FALSE
);

-- Table: attribute_type
CREATE TABLE attribute_type (
    type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(100) NOT NULL UNIQUE
);

-- Table: attribute_option
CREATE TABLE attribute_option (
    option_id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    display_order INT,
    is_default BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (category_id) REFERENCES attribute_category(category_id)
);

-- Table: product_attribute
CREATE TABLE product_attribute (
    attribute_id INT PRIMARY KEY AUTO_INCREMENT,
    product_item_id INT NOT NULL,
    attribute_category_id INT NOT NULL,
    attribute_type_id INT NOT NULL,
    attribute_value TEXT, -- Consider more specific types based on attribute_type
    FOREIGN KEY (product_item_id) REFERENCES product_item(item_id),
    FOREIGN KEY (attribute_category_id) REFERENCES attribute_category(category_id),
    FOREIGN KEY (attribute_type_id) REFERENCES attribute_type(type_id)
);
-- Inserting into brand
INSERT INTO brand (name) VALUES
('Nike'),
('Adidas'),
('Puma'),
('Dr. Martens'),
('Converse');

-- Inserting into product_category
INSERT INTO product_category (name, description, is_active) VALUES
('Sneakers', 'Athletic and casual sneakers', TRUE),
('Boots', 'Various styles of boots for different occasions', TRUE),
('Sandals', 'Open footwear for warm weather', TRUE),
('Formal Shoes', 'Dress shoes for formal events', TRUE);

-- Inserting into color
INSERT INTO color (name, hex_code, is_active) VALUES
('Red', '#FF0000', TRUE),
('Blue', '#0000FF', TRUE),
('Black', '#000000', TRUE),
('White', '#FFFFFF', TRUE),
('Brown', '#A52A2A', TRUE);

-- Inserting into size_category (US Men's, US Women's, EU)
INSERT INTO size_category (name, unit, is_unisex) VALUES
('US Men\'s', 'US', FALSE),
('US Women\'s', 'US', FALSE),
('EU', NULL, TRUE);

-- Inserting into size_option (US Men's sizes)
INSERT INTO size_option (size_category_id, name, abbreviation, sort_order) VALUES
((SELECT size_category_id FROM size_category WHERE name = 'US Men\'s'), '7', 'US 7', 7),
((SELECT size_category_id FROM size_category WHERE name = 'US Men\'s'), '8', 'US 8', 8),
((SELECT size_category_id FROM size_category WHERE name = 'US Men\'s'), '9', 'US 9', 9),
((SELECT size_category_id FROM size_category WHERE name = 'US Men\'s'), '10', 'US 10', 10);

-- Inserting into size_option (US Women's sizes)
INSERT INTO size_option (size_category_id, name, abbreviation, sort_order) VALUES
((SELECT size_category_id FROM size_category WHERE name = 'US Women\'s'), '6', 'US 6', 6),
((SELECT size_category_id FROM size_category WHERE name = 'US Women\'s'), '7', 'US 7', 7),
((SELECT size_category_id FROM size_category WHERE name = 'US Women\'s'), '8', 'US 8', 8);

-- Inserting into size_option (EU sizes)
INSERT INTO size_option (size_category_id, name, abbreviation, sort_order) VALUES
((SELECT size_category_id FROM size_category WHERE name = 'EU'), '39', 'EU 39', 39),
((SELECT size_category_id FROM size_category WHERE name = 'EU'), '40', 'EU 40', 40),
((SELECT size_category_id FROM size_category WHERE name = 'EU'), '41', 'EU 41', 41),
((SELECT size_category_id FROM size_category WHERE name = 'EU'), '42', 'EU 42', 42);

-- Inserting into product
INSERT INTO product (product_name, brand_id, base_price, category_id, description, is_active) VALUES
('Air Max 90', (SELECT brand_id FROM brand WHERE name = 'Nike'), 120.00, (SELECT category_id FROM product_category WHERE name = 'Sneakers'), 'Classic Air Max silhouette', TRUE),
('Superstar', (SELECT brand_id FROM brand WHERE name = 'Adidas'), 100.00, (SELECT category_id FROM product_category WHERE name = 'Sneakers'), 'Iconic Adidas Originals', TRUE),
('Classic Boot', (SELECT brand_id FROM brand WHERE name = 'Dr. Martens'), 160.00, (SELECT category_id FROM product_category WHERE name = 'Boots'), 'Durable leather boot', TRUE);

-- Inserting into product_variation (for Air Max 90)
INSERT INTO product_variation (product_id, name, variation_type) VALUES
((SELECT product_id FROM product WHERE product_name = 'Air Max 90'), 'Color', 'text'),
((SELECT product_id FROM product WHERE product_name = 'Air Max 90'), 'Size', 'size');

-- Inserting into product_variation (for Superstar)
INSERT INTO product_variation (product_id, name, variation_type) VALUES
((SELECT product_id FROM product WHERE product_name = 'Superstar'), 'Color', 'text'),
((SELECT product_id FROM product WHERE product_name = 'Superstar'), 'Size', 'size');

-- Inserting into product_item (Air Max 90 - Red - Size 9 US Men's)
INSERT INTO product_item (product_id, color_id, size_option_id, price, sku, stock_quantity) VALUES
((SELECT product_id FROM product WHERE product_name = 'Air Max 90'), (SELECT color_id FROM color WHERE name = 'Red'), (SELECT option_id FROM size_option WHERE name = '9' AND size_category_id = (SELECT size_category_id FROM size_category WHERE name = 'US Men\'s')), 125.00, 'AM90-RED-M9', 50);

-- Inserting into product_item (Air Max 90 - Blue - Size 10 US Men's)
INSERT INTO product_item (product_id, color_id, size_option_id, price, sku, stock_quantity) VALUES
((SELECT product_id FROM product WHERE product_name = 'Air Max 90'), (SELECT color_id FROM color WHERE name = 'Blue'), (SELECT option_id FROM size_option WHERE name = '10' AND size_category_id = (SELECT size_category_id FROM size_category WHERE name = 'US Men\'s')), 125.00, 'AM90-BLU-M10', 30);

-- Inserting into product_item (Superstar - Black - Size 42 EU)
INSERT INTO product_item (product_id, color_id, size_option_id, price, sku, stock_quantity) VALUES
((SELECT product_id FROM product WHERE product_name = 'Superstar'), (SELECT color_id FROM color WHERE name = 'Black'), (SELECT option_id FROM size_option WHERE name = '42' AND size_category_id = (SELECT size_category_id FROM size_category WHERE name = 'EU')), 105.00, 'SS-BLK-EU42', 40);

-- Inserting into product_image (for Air Max 90 - Red)
INSERT INTO product_image (product_id, item_id, color_id, image_url, alt_text, is_primary, display_order) VALUES
((SELECT product_id FROM product WHERE product_name = 'Air Max 90'), (SELECT item_id FROM product_item WHERE sku = 'AM90-RED-M9'), (SELECT color_id FROM color WHERE name = 'Red'), '/images/airmax90_red_1.jpg', 'Nike Air Max 90 Red Side', TRUE, 1),
((SELECT product_id FROM product WHERE product_name = 'Air Max 90'), (SELECT item_id FROM product_item WHERE sku = 'AM90-RED-M9'), (SELECT color_id FROM color WHERE name = 'Red'), '/images/airmax90_red_2.jpg', 'Nike Air Max 90 Red Top', FALSE, 2);

-- Inserting into attribute_category
INSERT INTO attribute_category (name) VALUES
('Material'),
('Features');

-- Inserting into attribute_type
INSERT INTO attribute_type (type_name) VALUES
('TEXT'),
('BOOLEAN');

-- Inserting into attribute_option (for Material)
INSERT INTO attribute_option (category_id, name) VALUES
((SELECT category_id FROM attribute_category WHERE name = 'Material'), 'Leather'),
((SELECT category_id FROM attribute_category WHERE name = 'Material'), 'Canvas');

-- Inserting into attribute_option (for Features)
INSERT INTO attribute_option (category_id, name) VALUES
((SELECT category_id FROM attribute_category WHERE name = 'Features'), 'Waterproof'),
((SELECT category_id FROM attribute_category WHERE name = 'Features'), 'Breathable');

-- Inserting into product_attribute (Air Max 90 - Red - Material)
INSERT INTO product_attribute (product_item_id, attribute_category_id, attribute_type_id, attribute_value) VALUES
((SELECT item_id FROM product_item WHERE sku = 'AM90-RED-M9'), (SELECT category_id FROM attribute_category WHERE name = 'Material'), (SELECT type_id FROM attribute_type WHERE type_name = 'TEXT'), 'Canvas');

-- Inserting into product_attribute (Air Max 90 - Red - Breathable)
INSERT INTO product_attribute (product_item_id, attribute_category_id, attribute_type_id, attribute_value) VALUES
((SELECT item_id FROM product_item WHERE sku = 'AM90-RED-M9'), (SELECT category_id FROM attribute_category WHERE name = 'Features'), (SELECT type_id FROM attribute_type WHERE type_name = 'BOOLEAN'), 'TRUE');

-- Inserting into product_attribute (Superstar - Black - Material)
INSERT INTO product_attribute (product_item_id, attribute_category_id, attribute_type_id, attribute_value) VALUES
((SELECT item_id FROM product_item WHERE sku = 'SS-BLK-EU42'), (SELECT category_id FROM attribute_category WHERE name = 'Material'), (SELECT type_id FROM attribute_type WHERE type_name = 'TEXT'), 'Leather');-- 