CREATE DATABASE IF NOT EXISTS laundry CHARACTER SET utf8 COLLATE utf8_general_ci;
USE laundry;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_card_number VARCHAR(50) NOT NULL UNIQUE,
    room_number VARCHAR(20) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100),
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rating INT DEFAULT 100,
    is_admin BOOLEAN NOT NULL DEFAULT 0
);

CREATE TABLE machines (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    type ENUM('стиральная', 'сушильная') NOT NULL,
    status ENUM('свободно', 'занято', 'на ремонте') DEFAULT 'свободно',
    payment_method ENUM('QR/наличные', 'только наличные') NOT NULL,
    position_x ENUM('1', '2', '3', '4', '5') NOT NULL,
    position_y ENUM('1', '2') NOT NULL,
    UNIQUE KEY unique_position (position_x, position_y)
);

CREATE TABLE bookings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_user INT NOT NULL,
    id_machine INT NOT NULL,
    date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status ENUM('забронировано', 'в процессе', 'завершено', 'отменено')
        DEFAULT 'забронировано',
    id_next_user INT,
    was_on_time BOOLEAN,
    UNIQUE KEY unique_machine_start (id_machine, date, start_time),
    UNIQUE KEY unique_machine_end (id_machine, date, end_time),

    FOREIGN KEY (id_user) REFERENCES users(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_machine) REFERENCES machines(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_next_user) REFERENCES users(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE machine_issues (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_machine INT NOT NULL,
    reported_by INT,
    description TEXT NOT NULL,
    status ENUM('новое', 'решается', 'решено') DEFAULT 'новое',
    reported_date DATE NOT NULL,
    reported_time TIME NOT NULL,
    resolved_date DATE,
    resolved_time TIME,
    admin_notes TEXT,
    UNIQUE KEY unique_machine_report_time (id_machine, reported_date,
    reported_time),

    FOREIGN KEY (id_machine) REFERENCES machines(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (reported_by) REFERENCES users(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Пример данных: 5 стиральных и 3 сушильные машины
INSERT INTO machines (name, type, payment_method, position_x, position_y) VALUES
    ('Стиралка 1', 'стиральная', 'QR/наличные', '1', '2'),
    ('Стиралка 2', 'стиральная', 'QR/наличные', '2', '2'),
    ('Стиралка 3', 'стиральная', 'QR/наличные', '3', '2'),
    ('Стиралка 4', 'стиральная', 'QR/наличные', '4', '2'),
    ('Стиралка 5', 'стиральная', 'QR/наличные', '5', '2'),
    ('Сушилка 1', 'сушильная', 'QR/наличные', '3', '1'),
    ('Сушилка 2', 'сушильная', 'QR/наличные', '4', '1'),
    ('Сушилка 3', 'сушильная', 'QR/наличные', '5', '1');
