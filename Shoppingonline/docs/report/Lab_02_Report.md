# BÁO CÁO TỔNG KẾT VÀ SO KHỚP TÍNH NĂNG
## LAB 02 - MERN STACK (SHOPPING ONLINE) - TUẦN 2

*Dự án: MERN-Shoppingonline | Ngày báo cáo: 02/08/2026*

---

## I. TỔNG QUAN VỀ BÀI LAB 02 (TUẦN 2)

Bài Lab 02 tập trung vào việc thiết lập lớp dữ liệu (Database Models & Schemas) bằng Mongoose, tạo các tiện ích trợ giúp (Utilities for DB connection, Hash MD5, Email Nodemailer, JWT Token) và xây dựng tính năng Đăng nhập / Đăng xuất (Login/Logout) cho Quản trị viên (Admin) cùng với hệ thống định tuyến trang Admin bằng `react-router-dom`.

### Bảng tóm tắt yêu cầu bài Lab 02:

| STT | Hạng mục | Mô tả yêu cầu bài Lab 02 |
| --- | --- | --- |
| 1 | Mongoose Models | Định nghĩa các Schema và Model: `Admin`, `Category`, `Customer`, `Product`, `Item`, `Order` trong `server/models/Models.js`. |
| 2 | Server Utilities | Xây dựng các mô-đun tiện ích: `MyConstants.js`, `MongooseUtil.js`, `CryptoUtil.js`, `EmailUtil.js`, `JwtUtil.js`. |
| 3 | Stylesheets CSS | Cập nhật CSS dùng chung cho giao diện Admin và Customer (`App.css`). |
| 4 | Admin Auth Server | Tạo `AdminDAO.js` và xây dựng các API endpoint `POST /api/admin/login`, `GET /api/admin/token`. |
| 5 | Admin Auth Client | Thiết lập React Context (`MyContext`, `MyProvider`) quản lý token/username toàn cục, tạo `LoginComponent`, `MenuComponent`, `HomeComponent`, `MainComponent`. |
| 6 | React Router Integration | Cài đặt `react-router-dom`, tích hợp `BrowserRouter`, `Routes`, `Route`, `Navigate` cho hệ thống Admin. |

---

## II. CHI TIẾT CÁC HẠNG MỤC ĐÃ THỰC HIỆN & SO KHỚP MÃ NGUỒN

### 1. Phía Server (`/server`)
- **Tệp [server/models/Models.js](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/server/models/Models.js)**:
  - Khai báo 6 Schemas chuẩn xác: `AdminSchema`, `CategorySchema`, `CustomerSchema`, `ProductSchema`, `ItemSchema`, `OrderSchema`.
  - Export đầy đủ các Mongoose models tương ứng.
- **Các tệp Tiện ích ([server/utils](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/server/utils))**:
  - [MyConstants.js](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/server/utils/MyConstants.js): Chứa thông số cấu hình kết nối DB Cloud, tài khoản Email SMTP và khóa bí mật JWT (`JWT_SECRET`, `JWT_EXPIRES`).
  - [MongooseUtil.js](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/server/utils/MongooseUtil.js): Thực hiện kết nối đến MongoDB Atlas qua `mongoose.connect()`.
  - [CryptoUtil.js](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/server/utils/CryptoUtil.js): Mã hóa mật khẩu theo chuẩn MD5 bằng thư viện `crypto`.
  - [EmailUtil.js](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/server/utils/EmailUtil.js): Gửi email kích hoạt tài khoản bằng `nodemailer` qua giao thức SMTP.
  - [JwtUtil.js](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/server/utils/JwtUtil.js): Cung cấp 2 hàm quan trọng: `genToken()` để tạo JWT Token và `checkToken()` (middleware xác thực chuỗi Token từ request header `x-access-token` hoặc `authorization`).
- **Tệp [server/models/AdminDAO.js](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/server/models/AdminDAO.js)**:
  - Cung cấp hàm `selectByUsernameAndPassword(username, password)` để xác thực tài khoản Admin trong CSDL.
- **Tệp [server/api/admin.js](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/server/api/admin.js)**:
  - `POST /login`: Kiểm tra thông tin tài khoản admin, nếu đúng sẽ sinh mã JWT token và trả về cho client.
  - `GET /token`: Xác thực tính hợp lệ của Token thông qua middleware `JwtUtil.checkToken`.

### 2. Phía Client Admin (`/client-admin`)
- **Tệp [client-admin/src/App.css](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/client-admin/src/App.css)**: Cấu hình quy chuẩn style cho layout (`.body-admin`, `.align-valign-center`, `.datatable`, `.menu`).
- **Tệp [client-admin/src/contexts/MyProvider.js](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/client-admin/src/contexts/MyProvider.js)**: Quản lý trạng thái toàn cục `token` và `username` qua React Context.
- **Component [LoginComponent.js](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/client-admin/src/components/LoginComponent.js)**: Giao diện form đăng nhập Admin, gọi API `POST /api/admin/login` và lưu Token vào Context khi thành công.
- **Component [MenuComponent.js](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/client-admin/src/components/MenuComponent.js)**: Thanh điều hướng phía Admin hiển thị tên đăng nhập và chức năng Đăng xuất (`lnkLogoutClick`).
- **Component [MainComponent.js](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/client-admin/src/components/MainComponent.js)**: Cấu hình các tuyến đường `Routes`, `Route`, `Navigate` của React Router v6.

---

## III. ĐÁNH GIÁ MỨC ĐỘ HOÀN THÀNH & SO KHỚP THỰC TẾ

| Hạng mục Lab 02 | Yêu cầu tài liệu PDF | Tình trạng trong Mã nguồn | Kết quả so khớp |
| --- | --- | --- | --- |
| Mongoose Schemas | Admin, Category, Customer, Product, Item, Order | Đầy đủ 6 schemas trong `Models.js` | **100% Khớp** |
| Module Utilities | MyConstants, MongooseUtil, CryptoUtil, EmailUtil, JwtUtil | Đã triển khai đầy đủ tại `server/utils` | **100% Khớp** |
| Admin Login API | `POST /api/admin/login` sinh JWT Token | Đã hoạt động chuẩn xác trong `admin.js` | **100% Khớp** |
| Middleware Auth | `JwtUtil.checkToken` kiểm tra header | Đã tích hợp kiểm tra `x-access-token` | **100% Khớp** |
| Frontend Context | State `token` & `username` | Đã triển khai `MyContext` & `MyProvider` | **100% Khớp** |
| React Router v6 | `BrowserRouter`, `Routes`, `Route`, `Navigate` | Đã cấu hình chuyển hướng trang Admin mượt mà | **100% Khớp** |

---

## IV. KẾT LUẬN

Toàn bộ các mục tiêu trong **Lab 02 (Tuần 2)** đã được thực hiện chính xác và đồng bộ 100%. Cơ chế bảo mật API bằng JWT Token và phân quyền Admin trên giao diện ReactJS đã tạo nền tảng vững chắc cho các bài Lab tiếp theo.
