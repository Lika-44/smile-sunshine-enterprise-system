-- Optional fictional demonstration data.
-- These records do not come from the original database.
-- The prototype currently stores application passwords directly. Replace the
-- demonstration password and adopt password hashing before any real deployment.

USE smile_sunshine;

INSERT INTO department (name, description) VALUES
    ('Demo Administration', 'Fictional department for local demonstration'),
    ('Demo Sales', 'Fictional department for local demonstration');

INSERT INTO role (role_name, department_id, description) VALUES
    ('Demo Administrator', 1, 'Fictional role for exercising the prototype'),
    ('Demo Sales User', 2, 'Fictional limited role for menu testing');

INSERT INTO permission (permission_name, api_path, description) VALUES
    ('Dashboard', '/dashboard', 'View the dashboard'),
    ('Product Catalogue', '/product', 'Browse products and create sales orders'),
    ('Customer Management', '/customer/manage', 'Manage customers'),
    ('Product Management', '/product/manage', 'Manage products'),
    ('Order Management', '/order', 'Manage sales orders'),
    ('Department Management', '/system/department/manage', 'Manage departments'),
    ('Role Management', '/system/role/manage', 'Manage roles'),
    ('User Management', '/system/user/manage', 'Manage users'),
    ('Permission Management', '/system/permission/manage', 'Manage permissions');

INSERT INTO user (username, password, email, phone, real_name, gender) VALUES
    ('demo_admin', 'replace-before-use', 'demo.admin@example.invalid', '000-000-0000', 'Demo Administrator', 'male'),
    ('demo_sales', 'replace-before-use', 'demo.sales@example.invalid', '000-000-0001', 'Demo Sales User', 'female');

INSERT INTO user_role (user_id, role_id) VALUES
    (1, 1),
    (2, 2);

INSERT INTO role_permission (role_id, permission_id)
SELECT 1, id FROM permission;

INSERT INTO role_permission (role_id, permission_id) VALUES
    (2, 1),
    (2, 2),
    (2, 3),
    (2, 5);

INSERT INTO customer (name, address, phone) VALUES
    ('Example Customer', '100 Example Street, Sample City', '000-100-2000');

INSERT INTO product (
    name,
    description,
    price_cents,
    image_url,
    safety_certification,
    create_date,
    is_public,
    quantity_in_stock
) VALUES (
    'Sample Product',
    'Fictional product for local demonstration',
    1999,
    NULL,
    TRUE,
    CURRENT_DATE,
    TRUE,
    25
);
