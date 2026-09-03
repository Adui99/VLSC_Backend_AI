# BÁO CÁO BÀI TẬP THỰC HÀNH TUẦN 4
## Chủ đề: Thiết kế Cơ sở Dữ liệu Nâng cao & Tối ưu bằng AI

- **Thư mục bài làm**: `baocaotuan_4/`
- **Hệ quản trị CSDL áp dụng**: MySQL 8.0+ & MongoDB (Mongoose Schema)

---

## BÀI TẬP 1: Thiết kế Cơ sở Dữ liệu bằng AI (Student Management System)

### 1. Prompt sử dụng cho AI
```text
Bạn là Chuyên gia Thiết kế Cơ sở Dữ liệu RDBMS. 
Hãy thiết kế cơ sở dữ liệu quan hệ MySQL cho "Hệ thống Quản lý Sinh viên (Student Management System)".

Các chức năng chính cần quản lý:
1. Quản lý sinh viên
2. Quản lý lớp học hành chính
3. Quản lý môn học
4. Quản lý giảng viên
5. Quản lý đăng ký học / Lớp học phần / Bảng điểm

Yêu cầu đầu ra:
- Xác định đầy đủ các Thực thể (Entities), Thuộc tính (Attributes) và Mối quan hệ (Relationships).
- Đạt Chuẩn 3NF (Third Normal Form) với đầy đủ Khóa chính (PK) và Khóa ngoại (FK).
- Trình bày sơ đồ ERD dạng mã Mermaid và mã SQL CREATE TABLE chuẩn MySQL.
```

### 2. Kết quả AI thiết kế (Entities & Relationships)
- **Classes**: `class_id` (PK), `class_code`, `class_name`, `academic_year`
- **Lecturers**: `lecturer_id` (PK), `lecturer_code`, `full_name`, `email`, `phone`, `department`
- **Students**: `student_id` (PK), `student_code`, `full_name`, `email`, `phone`, `date_of_birth`, `address`, `class_id` (FK)
- **Courses**: `course_id` (PK), `course_code`, `course_name`, `credits`, `description`
- **CourseSections**: `section_id` (PK), `course_id` (FK), `lecturer_id` (FK), `section_code`, `semester`, `room`
- **Enrollments**: `enrollment_id` (PK), `student_id` (FK), `section_id` (FK), `enroll_date`, `score_midterm`, `score_final`, `score_total`, `status`

### 3. Sơ đồ ERD (Mermaid Code & Hình ảnh)
```mermaid
erDiagram
    Classes ||--o{ Students : "chứa"
    Students ||--o{ Enrollments : "đăng ký"
    CourseSections ||--o{ Enrollments : "gồm"
    Courses ||--o{ CourseSections : "mở lớp"
    Lecturers ||--o{ CourseSections : "phụ trách"

    Classes {
        int class_id PK
        string class_code UQ
        string class_name
    }
    Students {
        int student_id PK
        string student_code UQ
        string full_name
        string email UQ
        int class_id FK
    }
    Enrollments {
        int enrollment_id PK
        int student_id FK
        int section_id FK
        decimal score_total
        string status
    }
    CourseSections {
        int section_id PK
        int course_id FK
        int lecturer_id FK
        string semester
    }
    Courses {
        int course_id PK
        string course_code UQ
        string course_name
    }
    Lecturers {
        int lecturer_id PK
        string lecturer_code UQ
        string full_name
    }
```

*Sơ đồ ERD dạng hình ảnh đính kèm: `erd_student_management.png`.*

### 4. Đánh giá Chuẩn 3NF (Third Normal Form)
- **1NF**: Các cột chứa giá trị nguyên tố đơn lẻ. Không có danh sách đăng ký học hay mảng lặp trong một bản ghi.
- **2NF**: Đạt 1NF và loại bỏ phụ thuộc một phần. Các thông tin giảng viên (`lecturer_id`), môn học (`course_id`) được tách riêng khỏi bảng `Enrollments`.
- **3NF**: Đạt 2NF và không chứa phụ thuộc bắc cầu. Thông tin sinh viên phụ thuộc vào `student_id`, thông tin lớp học phụ thuộc vào `class_id`. Bảng `Enrollments` chỉ lưu các tham chiếu khóa ngoại và dữ liệu phát sinh (điểm số).

### 5. Đề xuất 02 cải tiến cho thiết kế của AI
1. **Cải tiến 1 - Thêm bảng `AuditLogs`**: Thêm bảng nhật ký theo dõi lịch sử biến động điểm số, thay đổi thông tin sinh viên và chuyển trạng thái học tập (bảo lưu, thôi học).
2. **Cải tiến 2 - Bổ sung Ràng buộc duy nhất & Indexing**:
   - Thêm ràng buộc `CONSTRAINT uq_student_section UNIQUE (student_id, section_id)` để ngăn chặn sinh viên đăng ký trùng 1 lớp học phần nhiều lần.
   - Thêm `CREATE INDEX idx_students_class_fullname ON Students(class_id, full_name)` để tối ưu hóa việc truy vấn sinh viên theo lớp.

---

## BÀI TẬP 2: Chuyển đổi SQL sang MongoDB bằng AI

### 1. Prompt sử dụng cho AI
```text
Tôi đã có CSDL quan hệ MySQL Quản lý Sinh viên (Classes, Lecturers, Students, Courses, CourseSections, Enrollments).
Hãy giúp tôi chuyển đổi thiết kế này sang MongoDB NoSQL Document Model.

Yêu cầu:
1. Xác định các Collections và viết Mongoose Schemas (Node.js/JavaScript).
2. Tạo các Document mẫu dạng JSON đại diện cho dữ liệu thực tế.
3. Phân tích chiến lược Embedding (Nhúng) vs Referencing (Tham chiếu): Collection nào nên nhúng, collection nào nên dùng ObjectId tham chiếu?
4. Lập bảng so sánh chi tiết giữa thiết kế MySQL và MongoDB.
```

### 2. Thiết kế Collections & Document Mẫu JSON
Mã Mongoose Schemas đầy đủ được lưu tại `mongoose_schemas.js` và JSON mẫu tại `sample_documents.json`.

Ví dụ Document mẫu của `Student` (Embedding địa chỉ, Referencing Lớp):
```json
{
  "_id": "66c3a1f1e4b0112345678904",
  "studentCode": "SV001",
  "fullName": "Nguyễn Văn An",
  "email": "student@example.com",
  "phone": "0912345678",
  "address": {
    "street": "123 Nguyễn Trãi",
    "district": "Thanh Xuân",
    "city": "Hà Nội"
  },
  "class": "66c3a1f1e4b0112345678901"
}
```

### 3. Phân tích Chiến lược Embedding vs Referencing
- **Nên dùng EMBEDDING (Nhúng)**:
  - **Địa chỉ sinh viên (`address`)**: Cấu trúc 1-1, gắn liền với sinh viên, ít khi truy vấn độc lập. Nhúng vào `Student` giúp giảm thao tác Join/Lookup.
  - **Điểm số (`scores`)**: Các con điểm (giữa kỳ, cuối kỳ, tổng kết) thuộc 1 đợt đăng ký môn, nhúng trực tiếp vào `Enrollment`.
- **Nên dùng REFERENCING (Tham chiếu)**:
  - **Lớp học (`class`) trong `Student`**: Quan hệ 1-N. Một lớp có hàng trăm sinh viên. Nếu nhúng thông tin lớp vào từng sinh viên sẽ bị dư thừa dữ liệu (Data Duplication); nếu nhúng mảng sinh viên vào Lớp sẽ bị vượt quá giới hạn 16MB/Document của MongoDB.
  - **Giảng viên & Môn học trong `Enrollment`**: Tham chiếu `ObjectId` để đảm bảo dữ liệu môn học/giảng viên được quản lý tập trung, khi sửa tên môn học không phải update hàng ngàn enrollment documents.

### 4. So sánh Thiết kế MySQL và MongoDB
| Tiêu chí | MySQL (Relational SQL) | MongoDB (Document NoSQL) |
|---|---|---|
| **Mô hình dữ liệu** | Bảng quan hệ (Tables & Rows) | Tài liệu JSON/BSON (Collections & Documents) |
| **Cấu trúc Schema** | Schema cố định (Rigid Schema, DDL) | Schema linh hoạt (Dynamic Schema) |
| **Mối quan hệ** | Sử dụng Khóa ngoại (FK) & JOIN | Sử dụng Embedding hoặc Tham chiếu ObjectId |
| **Tính toàn vẹn (ACID)** | Tuân thủ ACID nghiêm ngặt ở mức cơ sở dữ liệu | Hỗ trợ ACID transaction nhưng tối ưu cho Single Document |
| **Khả năng mở rộng** | Thường mở rộng theo chiều dọc (Vertical Scaling) | Mở rộng theo chiều ngang cực tốt (Horizontal Scaling / Sharding) |

---

## BÀI TẬP 3: AI Hỗ trợ Tối ưu Truy vấn và Index

### 1. Prompt sử dụng cho AI
```text
Tôi có CSDL MySQL Quản lý Sinh viên. Hãy phân tích 3 câu lệnh truy vấn sau và đề xuất các chỉ mục (Index) tối ưu nhất:
1. SELECT * FROM Student WHERE Email='student@example.com';
2. SELECT * FROM Student WHERE ClassID=1 ORDER BY FullName;
3. SELECT CourseID, COUNT(*) FROM Enrollment GROUP BY CourseID;

Yêu cầu:
- Nêu lý do chọn loại Index (Unique Index, Composite Index, Covering Index).
- Giải thích cơ chế B-Tree Index giúp cải thiện hiệu năng như thế nào.
- Nhận xét và đánh giá đề xuất của AI.
```

### 2. Phân tích & Đề xuất Index cho 3 Truy vấn

#### Truy vấn 1: Tìm kiếm sinh viên theo Email
```sql
SELECT * FROM Student WHERE Email='student@example.com';
```
- **Vấn đề**: Không có Index, MySQL phải thực hiện **Full Table Scan** (quét qua toàn bộ bản ghi trong bảng).
- **Đề xuất Index**: `CREATE UNIQUE INDEX idx_student_email ON Student(Email);`
- **Giải thích**: Email có tính duy nhất cao (High Cardinality). `UNIQUE INDEX` xây dựng cây B-Tree với thời gian tìm kiếm $O(\log N)$ thay vì $O(N)$, dừng ngay khi tìm thấy bản ghi trùng khớp.

#### Truy vấn 2: Tìm sinh viên theo Lớp và Sắp xếp theo Họ tên
```sql
SELECT * FROM Student WHERE ClassID=1 ORDER BY FullName;
```
- **Vấn đề**: Tìm theo `ClassID` nhưng khi sắp xếp theo `FullName` MySQL phải dùng bộ nhớ đệm để sắp xếp lại (**Using filesort**).
- **Đề xuất Index**: `CREATE INDEX idx_student_class_fullname ON Student(ClassID, FullName);`
- **Giải thích**: Sử dụng **Composite Index (Chỉ mục tổ hợp)** gồm 2 cột theo thứ tự `(ClassID, FullName)`. Cột `ClassID` phục vụ điều kiện `WHERE`, và dữ liệu thuộc cùng `ClassID` đã được sắp xếp sẵn theo `FullName` trên B-Tree index, loại bỏ hoàn toàn chi phí `Using filesort`.

#### Truy vấn 3: Thống kê số lượng sinh viên theo Môn học
```sql
SELECT CourseID, COUNT(*) FROM Enrollment GROUP BY CourseID;
```
- **Vấn đề**: Phải quét dữ liệu bảng `Enrollment` và gom nhóm dữ liệu.
- **Đề xuất Index**: `CREATE INDEX idx_enrollment_courseid ON Enrollment(CourseID);`
- **Giải thích**: Tạo **Covering Index Scan**. MySQL chỉ cần duyệt trực tiếp trên cây chỉ mục `CourseID` để thực hiện hàm `COUNT(*)` mà không cần phải truy cập (random I/O) vào bảng dữ liệu chính trên đĩa cứng.

### 3. Nhận xét & Đánh giá kết quả đề xuất của AI
- AI đề xuất chính xác các loại chỉ mục phù hợp cho từng loại câu lệnh.
- Lợi ích: Tăng tốc độ truy vấn từ hàng chục lần đến hàng trăm lần trên tập dữ liệu lớn.
- Lưu ý khi áp dụng: Việc tạo quá nhiều Index sẽ làm tăng dung lượng lưu trữ trên đĩa và giảm hiệu năng của các thao tác ghi dữ liệu (`INSERT`, `UPDATE`, `DELETE`).
