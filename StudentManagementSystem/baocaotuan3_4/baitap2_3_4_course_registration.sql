-- ============================================================
-- BÀI TẬP 2, 3, 4: HỆ THỐNG ĐĂNG KÝ HỌC PHẦN (COURSE REGISTRATION SYSTEM)
-- File: baitap2_3_4_course_registration.sql
-- RDBMS: MySQL 8.0+
-- Chuẩn hóa 3NF - Đầy đủ PK, FK, Data Sample, DDL, DML, JOIN
-- ============================================================

CREATE DATABASE IF NOT EXISTS CourseRegistrationDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE CourseRegistrationDB;

-- ============================================================
-- BÀI TẬP 2 & 3: CREATE TABLE (DDL - Chuẩn 3NF với PK, FK)
-- ============================================================

-- 1. Bảng Semesters (Học kỳ)
CREATE TABLE IF NOT EXISTS Semesters (
    semester_id INT AUTO_INCREMENT PRIMARY KEY,
    semester_name VARCHAR(50) NOT NULL, -- Ví dụ: Học kỳ 1, Học kỳ 2
    academic_year VARCHAR(20) NOT NULL, -- Ví dụ: 2025-2026
    start_date DATE,
    end_date DATE
) ENGINE=InnoDB;

-- 2. Bảng Students (Sinh viên)
CREATE TABLE IF NOT EXISTS Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    student_code VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    major VARCHAR(100) DEFAULT 'Công nghệ thông tin',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 3. Bảng Courses (Môn học)
CREATE TABLE IF NOT EXISTS Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    course_name VARCHAR(150) NOT NULL,
    credits INT NOT NULL CHECK (credits > 0),
    description TEXT
) ENGINE=InnoDB;

-- 4. Bảng CourseSections (Lớp học phần)
CREATE TABLE IF NOT EXISTS CourseSections (
    section_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    semester_id INT NOT NULL,
    section_code VARCHAR(30) NOT NULL UNIQUE, -- Ví dụ: INT101_01
    lecturer_name VARCHAR(150) NOT NULL,
    room VARCHAR(50),
    max_capacity INT DEFAULT 40,
    CONSTRAINT fk_cs_course FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE,
    CONSTRAINT fk_cs_semester FOREIGN KEY (semester_id) REFERENCES Semesters(semester_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 5. Bảng Registrations (Đăng ký học phần)
CREATE TABLE IF NOT EXISTS Registrations (
    registration_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    section_id INT NOT NULL,
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('REGISTERED', 'CANCELLED', 'COMPLETED') DEFAULT 'REGISTERED',
    grade DECIMAL(4,2) CHECK (grade >= 0.0 AND grade <= 10.0),
    CONSTRAINT fk_reg_student FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_reg_section FOREIGN KEY (section_id) REFERENCES CourseSections(section_id) ON DELETE CASCADE,
    CONSTRAINT unique_student_section UNIQUE (student_id, section_id)
) ENGINE=InnoDB;


-- ============================================================
-- BÀI TẬP 3: THAO TÁC DỮ LIỆU DML (INSERT, SELECT, UPDATE, DELETE)
-- ============================================================

-- 1. INSERT: Thêm dữ liệu mẫu vào 5 bảng
INSERT INTO Semesters (semester_name, academic_year, start_date, end_date) VALUES
('Học kỳ 1', '2025-2026', '2025-09-01', '2026-01-15'),
('Học kỳ 2', '2025-2026', '2026-02-01', '2026-06-15');

INSERT INTO Students (student_code, full_name, email, phone, major) VALUES
('SV001', 'Nguyễn Văn An', 'an.nguyen@student.edu.vn', '0901234567', 'Khoa học máy tính'),
('SV002', 'Trần Thị Bích', 'bich.tran@student.edu.vn', '0912345678', 'Công nghệ thông tin'),
('SV003', 'Lê Hoàng Cường', 'cuong.le@student.edu.vn', '0923456789', 'Hệ thống thông tin'),
('SV004', 'Phạm Minh Dung', 'dung.pham@student.edu.vn', '0934567890', 'Kỹ thuật phần mềm'),
('SV005', 'Vũ Thị Trâm', 'tram.vu@student.edu.vn', '0945678901', 'Khoa học máy tính');

INSERT INTO Courses (course_code, course_name, credits, description) VALUES
('CS101', 'Lập trình C cơ bản', 3, 'Nhập môn lập trình cấu trúc C'),
('CS201', 'Cơ sở dữ liệu SQL', 4, 'Thiết kế và quản trị cơ sở dữ liệu quan hệ'),
('CS301', 'Phát triển Web MERN', 4, 'Xây dựng ứng dụng Web Fullstack với Node.js & React'),
('CS401', 'Trí tuệ nhân tạo', 3, 'Các giải thuật AI và Học máy cơ bản');

INSERT INTO CourseSections (course_id, semester_id, section_code, lecturer_name, room, max_capacity) VALUES
(1, 1, 'CS101_HK1_01', 'ThS. Nguyễn Văn Bình', 'A101', 40),
(2, 1, 'CS201_HK1_01', 'TS. Trần Đức Thắng', 'Lab 202', 35),
(3, 1, 'CS301_HK1_01', 'ThS. Lê Thị Mai', 'Lab 305', 30),
(4, 2, 'CS401_HK2_01', 'PGS. TS. Hoàng Anh', 'B204', 45);

INSERT INTO Registrations (student_id, section_id, registration_date, status, grade) VALUES
(1, 1, '2025-08-20 09:00:00', 'COMPLETED', 8.5),
(1, 2, '2025-08-20 09:15:00', 'COMPLETED', 9.0),
(2, 2, '2025-08-21 10:00:00', 'COMPLETED', 7.5),
(3, 3, '2025-08-22 14:30:00', 'REGISTERED', NULL),
(4, 1, '2025-08-23 11:20:00', 'CANCELLED', NULL),
(5, 3, '2025-08-24 16:00:00', 'REGISTERED', NULL);

-- 2. SELECT: Các câu lệnh truy vấn dữ liệu
-- Query 2.1: Lấy danh sách tất cả sinh viên
SELECT * FROM Students;

-- Query 2.2: Lọc các môn học có số tín chỉ >= 4
SELECT course_code, course_name, credits 
FROM Courses 
WHERE credits >= 4;

-- Query 2.3: Thống kê số lượng sinh viên đăng ký theo từng trạng thái
SELECT status, COUNT(*) AS total_students
FROM Registrations
GROUP BY status;

-- 3. UPDATE: Cập nhật dữ liệu
-- Update 3.1: Cập nhật điểm số cho sinh viên SV003 môn CS301
UPDATE Registrations 
SET grade = 8.8, status = 'COMPLETED' 
WHERE student_id = 3 AND section_id = 3;

-- Update 3.2: Cập nhật số điện thoại của sinh viên SV001
UPDATE Students 
SET phone = '0988888888' 
WHERE student_code = 'SV001';

-- 4. DELETE: Xóa dữ liệu
-- Delete 4.1: Xóa các lượt đăng ký học phần đã bị hủy (CANCELLED)
DELETE FROM Registrations 
WHERE status = 'CANCELLED';


-- ============================================================
-- BÀI TẬP 4: CÂU LỆNH JOIN (INNER, LEFT, RIGHT, MULTI-TABLE JOIN)
-- ============================================================

-- JOIN 1: INNER JOIN - Lấy danh sách sinh viên và lớp học phần đã hoàn thành đăng ký
SELECT 
    s.student_code,
    s.full_name AS student_name,
    c.course_name,
    cs.section_code,
    cs.lecturer_name,
    r.registration_date,
    r.status
FROM Registrations r
INNER JOIN Students s ON r.student_id = s.student_id
INNER JOIN CourseSections cs ON r.section_id = cs.section_id
INNER JOIN Courses c ON cs.course_id = c.course_id;

-- JOIN 2: LEFT JOIN - Danh sách TẤT CẢ sinh viên và thông tin đăng ký (nếu có)
SELECT 
    s.student_code,
    s.full_name,
    s.major,
    r.section_id,
    r.status
FROM Students s
LEFT JOIN Registrations r ON s.student_id = r.student_id;

-- JOIN 3: RIGHT JOIN - Danh sách tất cả các Lớp học phần và các sinh viên đăng ký tương ứng
SELECT 
    c.course_name,
    cs.section_code,
    cs.lecturer_name,
    s.full_name AS student_name,
    r.grade
FROM Registrations r
RIGHT JOIN CourseSections cs ON r.section_id = cs.section_id
INNER JOIN Courses c ON cs.course_id = c.course_id
LEFT JOIN Students s ON r.student_id = s.student_id;

-- JOIN 4: GROUP BY JOIN - Tính điểm trung bình và tổng số tín chỉ tích lũy của từng sinh viên
SELECT 
    s.student_code,
    s.full_name,
    COUNT(r.section_id) AS total_courses_passed,
    SUM(c.credits) AS total_credits,
    ROUND(AVG(r.grade), 2) AS average_grade
FROM Students s
INNER JOIN Registrations r ON s.student_id = r.student_id
INNER JOIN CourseSections cs ON r.section_id = cs.section_id
INNER JOIN Courses c ON cs.course_id = c.course_id
WHERE r.status = 'COMPLETED'
GROUP BY s.student_id, s.student_code, s.full_name;
