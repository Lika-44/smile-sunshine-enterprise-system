-- Schema-only export for the public academic prototype.
-- No records from the original database are included.

CREATE DATABASE IF NOT EXISTS smile_sunshine
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE smile_sunshine;

CREATE TABLE department (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE user (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    real_name VARCHAR(50) NOT NULL,
    gender ENUM ('male', 'female') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_user_username (username)
);

CREATE TABLE role (
    id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) NOT NULL,
    department_id INT,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES department (id)
);

CREATE TABLE permission (
    id INT PRIMARY KEY AUTO_INCREMENT,
    permission_name VARCHAR(100) NOT NULL,
    api_path VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_permission_api_path (api_path)
);

CREATE TABLE user_role (
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES user (id),
    FOREIGN KEY (role_id) REFERENCES role (id)
);

CREATE TABLE role_permission (
    role_id INT NOT NULL,
    permission_id INT NOT NULL,
    PRIMARY KEY (role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES role (id),
    FOREIGN KEY (permission_id) REFERENCES permission (id)
);

CREATE TABLE supplier (
    id INT PRIMARY KEY AUTO_INCREMENT,
    reliability_rating INT,
    name VARCHAR(100),
    contact_name VARCHAR(100),
    phone VARCHAR(100),
    address VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE material (
    id INT PRIMARY KEY AUTO_INCREMENT,
    material_number VARCHAR(100),
    description VARCHAR(100),
    unit_of_measure VARCHAR(100),
    quantity_in_stock INT,
    reorder_level INT,
    reorder_quantity INT,
    last_received_date DATE
);

CREATE TABLE procurement_order (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_number VARCHAR(100),
    unit_price_cents INT,
    number_of_units INT,
    total_amount_cents INT,
    supplier_id INT,
    material_id INT,
    order_date DATE,
    delivery_date DATE,
    payment_terms VARCHAR(100),
    status ENUM ('pending', 'completed', 'cancelled'),
    FOREIGN KEY (supplier_id) REFERENCES supplier (id),
    FOREIGN KEY (material_id) REFERENCES material (id)
);

CREATE TABLE inventory_record (
    id INT PRIMARY KEY AUTO_INCREMENT,
    material_id INT,
    type ENUM ('purchase', 'used'),
    record_number VARCHAR(100),
    quantity INT,
    date DATE,
    description VARCHAR(100),
    FOREIGN KEY (material_id) REFERENCES material (id)
);

CREATE TABLE design_concept (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    description VARCHAR(100),
    image_url VARCHAR(100),
    create_date DATE,
    feasibility INT,
    status ENUM ('pending', 'approved', 'rejected')
);

CREATE TABLE prototype (
    id INT PRIMARY KEY AUTO_INCREMENT,
    concept_id INT,
    description VARCHAR(100),
    prototype_url VARCHAR(100),
    create_date DATE,
    feasibility INT,
    status ENUM ('pending', 'approved', 'rejected'),
    test_result ENUM ('pending', 'pass', 'fail'),
    safety_result ENUM ('pending', 'pass', 'fail'),
    FOREIGN KEY (concept_id) REFERENCES design_concept (id)
);

CREATE TABLE prototype_comment (
    id INT PRIMARY KEY AUTO_INCREMENT,
    prototype_id INT,
    comment VARCHAR(100),
    create_date DATE,
    FOREIGN KEY (prototype_id) REFERENCES prototype (id)
);

CREATE TABLE product (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    description VARCHAR(100),
    price_cents INT,
    image_url VARCHAR(100),
    safety_certification BOOLEAN,
    create_date DATE,
    is_public BOOLEAN DEFAULT TRUE,
    design_id INT,
    quantity_in_stock INT DEFAULT 0
);

CREATE TABLE material_of_product (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    material_id INT,
    quantity INT,
    FOREIGN KEY (product_id) REFERENCES product (id),
    FOREIGN KEY (material_id) REFERENCES material (id),
    UNIQUE KEY uq_material_of_product (product_id, material_id)
);

CREATE TABLE production_plan (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    plan_date DATE,
    start_date DATE,
    end_date DATE,
    number_of_products INT,
    status ENUM ('pending', 'in_progress', 'completed', 'cancelled'),
    FOREIGN KEY (product_id) REFERENCES product (id)
);

CREATE TABLE production_process (
    id INT PRIMARY KEY AUTO_INCREMENT,
    production_plan_id INT,
    name VARCHAR(100),
    process_description VARCHAR(100),
    start_date DATE,
    end_date DATE,
    status ENUM ('pending', 'in_progress', 'completed', 'cancelled'),
    FOREIGN KEY (production_plan_id) REFERENCES production_plan (id)
);

CREATE TABLE prerequisite_of_process (
    id INT PRIMARY KEY AUTO_INCREMENT,
    process_id INT,
    prerequisite_process INT,
    FOREIGN KEY (process_id) REFERENCES production_process (id),
    FOREIGN KEY (prerequisite_process) REFERENCES production_process (id),
    UNIQUE KEY uq_prerequisite_process (process_id, prerequisite_process)
);

CREATE TABLE customer (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    address VARCHAR(100),
    phone VARCHAR(100)
);

CREATE TABLE sales_order (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_number VARCHAR(100),
    payment_method ENUM ('cash', 'credit card', 'bank transfer'),
    order_date DATE,
    delivery_date DATE,
    payment_terms VARCHAR(100),
    shipping_address VARCHAR(100),
    status ENUM ('pending', 'completed', 'cancelled'),
    product_amount_cents INT,
    shipping_cost_cents INT,
    tax_amount_cents INT,
    total_amount_cents INT,
    down_payment_percent INT,
    down_payment_date DATE,
    is_down_payment_paid BOOLEAN,
    is_customized BOOLEAN DEFAULT FALSE,
    special_requirements VARCHAR(1024),
    FOREIGN KEY (customer_id) REFERENCES customer (id)
);

CREATE TABLE order_item (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price_cents INT,
    total_price_cents INT,
    FOREIGN KEY (order_id) REFERENCES sales_order (id),
    FOREIGN KEY (product_id) REFERENCES product (id)
);

CREATE TABLE payment (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_method ENUM ('cash', 'credit card', 'bank transfer'),
    payment_date DATE,
    amount_paid_cents INT,
    balance_due_cents INT,
    FOREIGN KEY (order_id) REFERENCES sales_order (id)
);

CREATE TABLE shipping_method (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    description VARCHAR(100)
);

CREATE TABLE shipping_record (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    shipping_date DATE,
    shipping_method INT,
    tracking_number VARCHAR(100),
    carrier VARCHAR(100),
    shipping_address VARCHAR(100),
    status ENUM ('pending', 'in_transit', 'delivered'),
    FOREIGN KEY (order_id) REFERENCES sales_order (id),
    FOREIGN KEY (shipping_method) REFERENCES shipping_method (id)
);

CREATE TABLE customer_service_request (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    customer_id INT,
    request_date DATE,
    request_description VARCHAR(100),
    status ENUM ('pending', 'in_progress', 'resolved', 'closed'),
    resolution VARCHAR(100),
    FOREIGN KEY (order_id) REFERENCES sales_order (id),
    FOREIGN KEY (customer_id) REFERENCES customer (id)
);

CREATE TABLE technical_support (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_service_id INT,
    employee_id INT,
    support_date DATE,
    support_description VARCHAR(100),
    FOREIGN KEY (customer_service_id) REFERENCES customer_service_request (id),
    FOREIGN KEY (employee_id) REFERENCES user (id)
);

CREATE TABLE warranty_claim (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_service_id INT,
    warranty_period INT,
    claim_date DATE,
    claim_description VARCHAR(100),
    status ENUM ('pending', 'in_progress', 'resolved', 'closed'),
    resolution VARCHAR(100),
    FOREIGN KEY (customer_service_id) REFERENCES customer_service_request (id)
);

CREATE TABLE refund_return_request (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_service_id INT,
    refund_date DATE,
    return_date DATE,
    reason VARCHAR(100),
    status ENUM ('pending', 'in_progress', 'resolved', 'closed'),
    resolution VARCHAR(100),
    amount_refunded_cents INT,
    FOREIGN KEY (customer_service_id) REFERENCES customer_service_request (id)
);
