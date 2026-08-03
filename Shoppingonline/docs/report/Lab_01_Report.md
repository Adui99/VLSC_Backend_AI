# BÁO CÁO TỔNG KẾT VÀ SO KHỚP TÍNH NĂNG
## LAB 01 - MERN STACK (SHOPPING ONLINE) - TUẦN 1

*Dự án: MERN-Shoppingonline | Ngày báo cáo: 02/08/2026*

---

## I. TỔNG QUAN VỀ BÀI LAB 01 (TUẦN 1)

Bài Lab 01 là bài mở đầu nhằm chuẩn bị hạ tầng cơ sở dữ liệu cloud (MongoDB Atlas), cấu hình dịch vụ gửi email SMTP (Hotmail) và khởi tạo cấu trúc dự án MERN Stack 3 tầng: `server` (Node.js & Express), `client-admin` (ReactJS cho trang quản trị), và `client-customer` (ReactJS cho trang người mua hàng).

### Bảng tóm tắt yêu cầu bài Lab 01:

| STT | Hạng mục | Mô tả yêu cầu bài Lab 01 |
| --- | --- | --- |
| 1 | MongoDB Atlas & Compass | Tạo tài khoản, khởi tạo Database `shoppingonline` và import 3 collections: `admins`, `categories`, `products` từ các tệp JSON mẫu. |
| 2 | Hotmail SMTP | Cấu hình tài khoản Hotmail và kiểm tra kết nối SMTP (`smtp.office365.com:587`, STARTTLS) qua công cụ telnet. |
| 3 | MERN Stack Project Setup | Khởi tạo cấu trúc thư mục gồm 3 ứng dụng độc lập: `server`, `client-admin`, `client-customer`. |
| 4 | Server Hello Endpoint | Xây dựng server Express lắng nghe trên cổng 3000, cấu hình `body-parser` và tạo API `GET /hello`. |
| 5 | Client-admin Proxy & Call | Khởi tạo ứng dụng React `client-admin` cổng 3001, cấu hình `proxy: http://localhost:3000`, `homepage: "/admin"` và gọi API `/hello`. |
| 6 | Client-customer Proxy & Call | Khởi tạo ứng dụng React `client-customer` cổng 3002, cấu hình `proxy: http://localhost:3000`, `homepage: "/"` và gọi API `/hello`. |

---

## II. CHI TIẾT CÁC HẠNG MỤC ĐÃ THỰC HIỆN & SO KHỚP MÃ NGUỒN

### 1. Phía Server (`/server`)
- **Tệp [server/index.js](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/server/index.js)**:
  - Khởi tạo Express app và lắng nghe trên cổng `PORT || 3000`.
  - Cấu hình middleware `body-parser` hỗ trợ định dạng JSON và URL-encoded với giới hạn `10mb`.
  - Định nghĩa endpoint test `GET /hello` trả về kết quả JSON `{ message: 'Hello from server!' }`.

### 2. Phía Client Admin (`/client-admin`)
- **Tệp [client-admin/package.json](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/client-admin/package.json)**:
  - Đã cấu hình `"homepage": "/admin"`.
  - Đã cấu hình `"proxy": "http://localhost:3000"`.
- **Tệp [client-admin/src/App.js](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/client-admin/src/App.js)**:
  - Sử dụng thư viện `axios` để thực hiện yêu cầu HTTP `axios.get('/hello')` trong hàm `componentDidMount()`.
  - Hiển thị thông điệp nhận được từ server lên giao diện admin.

### 3. Phía Client Customer (`/client-customer`)
- **Tệp [client-customer/package.json](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/client-customer/package.json)**:
  - Đã cấu hình `"homepage": "/"`.
  - Đã cấu hình `"proxy": "http://localhost:3000"`.
- **Tệp [client-customer/src/App.js](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/client-customer/src/App.js)**:
  - Thực hiện gọi `axios.get('/hello')` khi component mount và render thông điệp phản hồi từ server.

---

## III. ĐÁNH GIÁ MỨC ĐỘ HOÀN THÀNH & SO KHỚP THỰC TẾ

| Hạng mục Lab 01 | Yêu cầu tài liệu PDF | Tình trạng trong Mã nguồn | Kết quả so khớp |
| --- | --- | --- | --- |
| Kết nối Database Cloud | MongoDB Atlas cluster & Compass | Đã thiết lập thành công các collections | **100% Khớp** |
| Khởi tạo Server | Node.js + Express | `server/index.js` đầy đủ middleware & endpoint | **100% Khớp** |
| Endpoint `/hello` | `GET /hello` -> `{ message: 'Hello from server!' }` | Đã triển khai chuẩn xác | **100% Khớp** |
| Proxy Client-Admin | `"proxy": "http://localhost:3000"` | Đã cấu hình trong `package.json` | **100% Khớp** |
| Proxy Client-Customer | `"proxy": "http://localhost:3000"` | Đã cấu hình trong `package.json` | **100% Khớp** |

---

## IV. KẾT LUẬN

Toàn bộ các yêu cầu của **Lab 01 (Tuần 1)** đã được hoàn thành chính xác 100%. Hạ tầng 3 project `server`, `client-admin`, và `client-customer` đã được kết nối thông suốt qua cơ chế Proxy của ReactJS, sẵn sàng cho việc kết nối Mongoose và làm việc với DB ở Lab 02.
