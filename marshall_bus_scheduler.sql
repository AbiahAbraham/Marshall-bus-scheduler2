-- Creating the 'users' table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password_hash VARCHAR(255),
    phone_number VARCHAR(15),
    role ENUM('admin', 'user') DEFAULT 'user'
);

-- Creating the 'routes' table
CREATE TABLE routes (
    route_id INT PRIMARY KEY AUTO_INCREMENT,
    start VARCHAR(100),
    end VARCHAR(100),
    stops VARCHAR(255),
    distance INT,            -- In kilometers
    duration TIME,           -- Estimated travel time
    bus_type VARCHAR(50)     -- E.g., 'Luxury', 'Standard'
);

-- Creating the 'buses' table
CREATE TABLE buses (
    bus_id INT PRIMARY KEY AUTO_INCREMENT,
    route_id INT,
    bus_number VARCHAR(20),  -- Unique bus identifier
    capacity INT,
    FOREIGN KEY (route_id) REFERENCES routes(route_id)
);

-- Creating the 'schedules' table
CREATE TABLE schedules (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    bus_id INT,
    route_id INT,
    departure_time TIME,
    arrival_time TIME,
    departure_date DATE,        -- Date for the specific schedule
    arrival_date DATE,          -- Arrival date for the schedule
    status ENUM('active', 'cancelled') DEFAULT 'active',  -- Schedule status
    FOREIGN KEY (bus_id) REFERENCES buses(bus_id),
    FOREIGN KEY (route_id) REFERENCES routes(route_id)
);

-- Creating the 'reservations' table
CREATE TABLE reservations (
    reservation_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    schedule_id INT,
    pickup VARCHAR(100),
    dropoff VARCHAR(100),
    adults INT,
    children INT,
    total_price DECIMAL(10, 2),   -- Store the calculated total price
    status ENUM('confirmed', 'pending', 'cancelled') DEFAULT 'pending',  -- Reservation status
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (schedule_id) REFERENCES schedules(schedule_id)
);

-- Creating the 'pricing' table
CREATE TABLE pricing (
    pricing_id INT PRIMARY KEY AUTO_INCREMENT,
    route_id INT,
    price_per_adult DECIMAL(10, 2),
    price_per_child DECIMAL(10, 2),
    start_date DATE,             -- Start date for the pricing to be valid
    end_date DATE,               -- End date for the pricing to be valid
    FOREIGN KEY (route_id) REFERENCES routes(route_id)
);

-- Creating the 'payments' table
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    reservation_id INT,
    amount_paid DECIMAL(10, 2),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('successful', 'failed', 'pending', 'refunded') DEFAULT 'pending',  -- Payment status
    transaction_id VARCHAR(100),   -- Transaction ID from payment gateway
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id)
);

-- Creating the 'reviews' table (optional: to allow user reviews for routes)
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    route_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (route_id) REFERENCES routes(route_id)
);

-- Creating an index on the 'email' field for the 'users' table
CREATE INDEX idx_email ON users(email);

-- Creating an index on the 'route_id' field for the 'buses' and 'pricing' tables
CREATE INDEX idx_route_id_buses ON buses(route_id);
CREATE INDEX idx_route_id_pricing ON pricing(route_id);

-- Creating an index on the 'reservation_id' field for the 'payments' table
CREATE INDEX idx_reservation_id_payments ON payments(reservation_id);
