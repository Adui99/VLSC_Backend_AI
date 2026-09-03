-- ============================================================
-- BÁO CÁO TUẦN 4: HỆ THỐNG QUẢN LÝ SINH VIÊN (STUDENT MANAGEMENT SYSTEM)
-- File: student_management.sql
-- RDBMS: MySQL 8.0+ (Chuẩn 3NF & Tối ưu Indexing)
-- ============================================================

CREATE DATABASE IF NOT EXISTS StudentManagementDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE StudentManagementDB;

-- ============================================================
-- BÀI TẬP 1: THIẾT KẾ CSDL CHUẨN 3NF
-- ============================================================

-- 1. Bảng Classes (Quản lý Lớp hành chính)
CREATE TABLE IF NOT EXISTS Classes (
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    class_code VARCHAR(20) NOT NULL UNIQUE,
    class_name VARCHAR(100) NOT NULL,
    academic_year VARCHAR(20) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. Bảng Lecturers (Quản lý Giảng viên)
CREATE TABLE IF NOT EXISTS Lecturers (
    lecturer_id INT AUTO_INCREMENT PRIMARY KEY,
    lecturer_code VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    department VARCHAR(100) DEFAULT 'Công nghệ thông tin',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 3. Bảng Students (Quản lý Sinh viên)
CREATE TABLE IF NOT EXISTS Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    student_code VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    date_of_birth DATE,
    address VARCHAR(255),
    class_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_students_class FOREIGN KEY (class_id) REFERENCES Classes(class_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 4. Bảng Courses (Quản lý Môn học)
CREATE TABLE IF NOT EXISTS Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    course_name VARCHAR(150) NOT NULL,
    credits INT NOT NULL CHECK (credits > 0),
    description TEXT
) ENGINE=InnoDB;

-- 5. Bảng CourseSections (Lớp học phần)
CREATE TABLE IF NOT EXISTS CourseSections (
    section_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    lecturer_id INT NOT NULL,
    section_code VARCHAR(30) NOT NULL UNIQUE,
    semester VARCHAR(20) NOT NULL,
    room VARCHAR(50),
    max_capacity INT DEFAULT 40,
    CONSTRAINT fk_sections_course FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE,
    CONSTRAINT fk_sections_lecturer FOREIGN KEY (lecturer_id) REFERENCES Lecturers(lecturer_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 6. Bảng Enrollments (Quản lý Đăng ký học & Bảng điểm)
CREATE TABLE IF NOT EXISTS Enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    section_id INT NOT NULL,
    enroll_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    score_midterm DECIMAL(4,2) CHECK (score_midterm >= 0 AND score_midterm <= 10),
    score_final DECIMAL(4,2) CHECK (score_final >= 0 AND score_final <= 10),
    score_total DECIMAL(4,2) GENERATED ALWAYS AS (score_midterm * 0.4 + score_final * 0.6) STORED,
    status ENUM('REGISTERED', 'STUDYING', 'COMPLETED', 'FAILED') DEFAULT 'REGISTERED',
    CONSTRAINT fk_enrollments_student FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_enrollments_section FOREIGN KEY (section_id) REFERENCES CourseSections(section_id) ON DELETE CASCADE,
    CONSTRAINT uq_student_section UNIQUE (student_id, section_id)
) ENGINE=InnoDB;

-- BẢNG CẢI TIẾN ĐỀ XUẤT 1: AuditLogs (Nhật ký biến động dữ liệu & trạng thái học tập)
CREATE TABLE IF NOT EXISTS AuditLogs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    entity_name VARCHAR(50) NOT NULL,
    entity_id INT NOT NULL,
    action_type ENUM('INSERT', 'UPDATE', 'DELETE', 'STATUS_CHANGE') NOT NULL,
    old_value JSON,
    new_value JSON,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;


-- ============================================================
-- DỮ LIỆU MẪU (DATA SAMPLE)
-- ============================================================

INSERT INTO Classes (class_code, class_name, academic_year) VALUES
('D21CNTT01', 'Lớp Công nghệ thông tin 1 khóa 2021', '2021-2025'),
('D21CNTT02', 'Lớp Công nghệ thông tin 2 khóa 2021', '2021-2025');

INSERT INTO Lecturers (lecturer_code, full_name, email, phone, department) VALUES
('GV001', 'TS. Nguyễn Văn Hùng', 'hung.nguyen@university.edu.vn', '0901112233', 'Khoa học máy tính'),
('GV002', 'ThS. Trần Thị Hoa', 'hoa.tran@university.edu.vn', '0902223344', 'Kỹ thuật phần mềm');

INSERT INTO Students (student_code, full_name, email, phone, date_of_birth, address, class_id) VALUES
('SV001', 'Nguyễn Văn An', 'student@example.com', '0912345678', '2003-05-15', '123 Nguyễn Trãi, Hà Nội', 1),
('SV002', 'Lê Thị Bình', 'binh.le@student.edu.vn', '0923456789', '2003-08-20', '456 Lê Lợi, Đà Nẵng', 1),
('SV003', 'Phạm Minh Cường', 'cuong.pham@student.edu.vn', '0934567890', '2003-11-10', '789 Trần Hưng Đạo, TP.HCM', 2);

INSERT INTO Courses (course_code, course_name, credits, description) VALUES
('CS101', 'Cơ sở dữ liệu', 3, 'Thiết kế và quản trị CSDL quan hệ'),
('CS202', 'Lập trình Web MERN', 4, 'Xây dựng Web Fullstack với MongoDB, Express, React, Node');

INSERT INTO CourseSections (course_id, lecturer_id, section_code, semester, room) VALUES
(1, 1, 'CS101_HK1_2025', 'HK1-2025', 'Lab 301'),
(2, 2, 'CS202_HK1_2025', 'HK1-2025', 'Lab 402');

INSERT INTO Enrollments (student_id, section_id, score_midterm, score_final, status) VALUES
(1, 1, 8.5, 9.0, 'COMPLETED'),
(2, 1, 7.0, 8.0, 'COMPLETED'),
(3, 2, 9.0, 9.5, 'COMPLETED');


-- ============================================================
-- BÀI TẬP 3: AI HỖ TRỢ TỐI ƯU TRUY VẤN VÀ INDEXING
-- ============================================================

-- Query 1: Tìm kiếm theo Email
-- SELECT * FROM Students WHERE email='student@example.com';
CREATE UNIQUE INDEX idx_students_email ON Students(email);

-- Query 2: Tìm kiếm theo Lớp và Sắp xếp theo Họ tên
-- SELECT * FROM Students WHERE class_id=1 ORDER BY full_name;
CREATE INDEX idx_students_class_fullname ON Students(class_id, full_name);

-- Query 3: Thống kê số lượng sinh viên theo Môn học/Lớp HP
-- SELECT section_id, COUNT(*) FROM Enrollments GROUP BY section_id;
CREATE INDEX idx_enrollments_sectionid ON Enrollments(section_id);
