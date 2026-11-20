-- The MySQL container entrypoint runs this file inside MYSQL_DATABASE.

-- ================= categories =================
CREATE TABLE categories (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) NOT NULL,
  `description` text,
  `image_url` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ================= users =================
CREATE TABLE users  (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ================= products =================
CREATE TABLE products (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `category_id` int NOT NULL,
  `product_name` varchar(100) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `stock_quantity` int NOT NULL DEFAULT '0',
  `image_url` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`product_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`),
  CONSTRAINT `products_chk_1` CHECK ((`price` >= 0)),
  CONSTRAINT `products_chk_2` CHECK ((`stock_quantity` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ================= carts =================
CREATE TABLE carts (
  `cart_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`cart_id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `carts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ================= cartitems =================
CREATE TABLE cartitems (
  `cart_item_id` int NOT NULL AUTO_INCREMENT,
  `cart_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`cart_item_id`),
  UNIQUE KEY `cart_product` (`cart_id`,`product_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `cartitems_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  CONSTRAINT `cartitems_ibfk_2` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`cart_id`),
  CONSTRAINT `cartitems_chk_1` CHECK ((`quantity` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ================= orders =================
CREATE TABLE orders (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `shipping_address` varchar(255) DEFAULT NULL,
  `status` varchar(100) NOT NULL DEFAULT 'processing',
  `total` decimal(10,2) NOT NULL,
  `order_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `chk_order_status` CHECK ((`status` in ('pending','processing','shipped','delivered','cancelled')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ================= orderitems =================
CREATE TABLE orderitems (
  `order_item_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `product_name` varchar(255) NOT NULL DEFAULT '',
  `unit_price` decimal(10,2) NOT NULL,
  `quantity` int NOT NULL,
  PRIMARY KEY (`order_item_id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `orderitems_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `orderitems_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  CONSTRAINT `chk_quantity` CHECK ((`quantity` > 0)),
  CONSTRAINT `chk_unit_price` CHECK ((`unit_price` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ================= DATA: categories =================
INSERT INTO categories VALUES
(1,'Rings','Rings Collection','images/rings.jpeg'),
(2,'Bracelets','Bracelets Collection','images/bracelet.jpeg'),
(3,'Earrings','Earings Collection','images/earings.jpeg'),
(4,'Necklaces','Necklaces Collection','images/nacklace.jpeg'),
(5,'Watches','Watches Collection','images/watch.jpeg');

-- ================= DATA: products =================
INSERT INTO products VALUES
(1,1,'Eclat Solitaire','18K yellow gold ring with a 1.5 ct round-cut centre',43800.00,20,'images/ring(1).jpeg',1),
(2,1,'Aurelia Eternity','Pavé-set diamonds around a slim 18k',32000.00,15,'images/ring(2).jpeg',1),
(3,1,'Lumiere Halo','Round centre stone surrounded by a halo',45700.00,22,'images/ring(3).jpeg',1),
(4,1,'Orsay Signet','Hand-polished 18k gold signet ring',23900.00,25,'images/ring(4).jpeg',1),
(5,1,'Verde Emerald','Emerald-cut emerald in 18k gold',45000.00,14,'images/ring(5).jpeg',1),
(6,1,'Celeste Pear','Pear-cut stone on a delicate twisted gold',45900.00,9,'images/ring(6).jpeg',1),
(7,2,'Aurelia Link','18K yellow gold chain bracelet with polished oval',78000.00,23,'images/bracelet(1).jpeg',1),
(8,2,'Lumière Tennis','Classic tennis bracelet set with a continuous line',67900.00,10,'images/bracelet(2).jpeg',1),
(9,2,'Eden Bangle','Slim 18K rose gold bangle with a hand-engraved',54900.00,14,'images/bracelet(3).jpeg',1),
(10,2,'Celeste Charm','Delicate gold bracelet with an adjustable chain',60000.00,7,'images/bracelet(4).jpeg',1),
(11,2,'Soleil Cuff','Bold open cuff in 18K yellow gold',45900.00,5,'images/bracelet(5).jpeg',1),
(12,4,'Eclat Pendant','18K yellow gold necklace with a single round-cut',80000.00,13,'images/necklace(1).jpeg',1),
(13,4,'Perle Royale','Strand of hand-selected freshwater pearls',74700.00,9,'images/necklace(2).jpeg',1),
(14,4,'Aurora Choker','Short polished gold choker with a smooth',70000.00,11,'images/necklace(3).jpeg',1),
(15,4,'Luna Crescent','Fine gold chain with a crescent moon pendant',65900.00,23,'images/necklace(4).jpeg',1),
(16,3,'Étoile Studs','Classic round-cut diamond studs in 18K',259000.00,45,'images/earings(1).jpeg',1),
(17,3,'Aurelia Hoops','Polished 18K yellow gold hoops with a lightweight',348000.00,22,'images/earings(2).jpeg',1),
(18,3,'Rosée Drops','Elegant drop earrings in rose gold with a teardrop',30000.00,15,'images/earings(3).jpeg',1),
(19,3,'Perle Éternelle','Freshwater pearl earrings on fine gold posts',28500.00,19,'images/earings(4).jpeg',1),
(20,5,'Aurelia Classic','18K gold-plated watch with a white mothe',47400.00,23,'images/watch(1).jpeg',1),
(21,5,'Noir Élégance','watch with gold indices and a stainless steel mesh',50000.00,18,'images/watch(2).jpeg',1),
(22,5,'Soleil Chrono','Chronograph watch in rose gold',45700.00,15,'images/watch(3).jpeg',1),
(23,5,'Lumière Petite','watch with a diamond-set bezel',44600.00,20,'images/watch(4).jpeg',1);