-- Default admin (password: Admin@1234)
INSERT INTO users (full_name, email, password, role) VALUES
  ('System Admin', 'admin@bsu.ac.ug', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin');

-- Sample vendor user (password: Admin@1234)
INSERT INTO users (full_name, email, password, role, phone) VALUES
  ('Mary Nalwanga', 'mary@bsu.ug', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'vendor', '0772123456');

-- Vendor profile
INSERT INTO vendors (user_id, business_name, slug, description, location, phone, opening_time, closing_time, status) VALUES
  (2, "Mary's Kitchen", 'marys-kitchen', 'Home-cooked local meals at student-friendly prices', 'Near Main Gate, Left Side', '0772123456', '07:00', '20:00', 'approved');

-- Sample student (password: Admin@1234)
INSERT INTO users (full_name, email, password, role) VALUES
  ('John Student', 'student@bsu.ac.ug', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student');

-- Sample food items (vendor_id=1 refers to Mary's Kitchen)
INSERT INTO food_items (vendor_id, category_id, name, description, price, is_available, is_featured, serving_size, tags) VALUES
  (1, 1, 'Matooke & Groundnut Sauce', 'Steamed green bananas with rich groundnut sauce', 3500, 1, 1, '1 plate', 'popular,local'),
  (1, 1, 'Rice & Beans',              'White rice with well-seasoned mixed beans',       3000, 1, 0, '1 plate', 'popular'),
  (1, 2, 'Chapati & Tea',             'Freshly fried chapati with hot milk tea',         2500, 1, 1, '2 chapatis + tea', 'breakfast'),
  (1, 3, 'Fresh Passion Juice',       'Freshly squeezed passion fruit juice',            2000, 1, 0, 'per glass', 'healthy,fresh'),
  (1, 4, 'Rolex',                     'Ugandan egg chapati roll with vegetables',        1500, 1, 1, '1 roll', 'popular,street food');