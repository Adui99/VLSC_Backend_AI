# BÁO CÁO TỔNG KẾT VÀ SO KHỚP TÍNH NĂNG
## LAB 03 - MERN STACK (SHOPPING ONLINE) - TUẦN 3

*Dự án: MERN-Shoppingonline | Ngày báo cáo: 02/08/2026*

---

## I. TỔNG QUAN VỀ BÀI LAB 03 (TUẦN 3)

Bài Lab 03 tập trung vào việc xây dựng bộ chức năng Quản lý Danh mục sản phẩm (Category Management) đầy đủ CRUD (Create, Read, Update, Delete) cho trang Quản trị viên (Admin). Toàn bộ các thao tác chỉnh sửa danh mục đều được bảo mật thông qua việc kiểm tra JWT Token ở phía Backend và giao diện ReactJS được tổ chức theo mô hình bảng danh sách đi kèm form chi tiết.

### Bảng tóm tắt yêu cầu bài Lab 03:

| STT | Chức năng | Mô tả yêu cầu bài Lab 03 |
| --- | --- | --- |
| 1 | Admin - List Category | Lấy danh sách tất cả danh mục từ MongoDB (`selectAll`) và hiển thị lên bảng dữ liệu (Data table). |
| 2 | Admin - Add Category | Thêm mới danh mục (`insert`) với mã ID tự động sinh (`mongoose.Types.ObjectId()`). |
| 3 | Admin - Update Category | Cập nhật tên danh mục (`update`) dựa theo `_id` đã chọn. |
| 4 | Admin - Delete Category | Xóa danh mục (`delete`) theo `_id` với hộp thoại xác nhận ("ARE YOU SURE?"). |

---

## II. CHI TIẾT CÁC HẠNG MỤC ĐÃ THỰC HIỆN & SO KHỚP MÃ NGUỒN

### 1. Phía Server (`/server`)
- **Tệp [server/models/CategoryDAO.js](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/server/models/CategoryDAO.js)**:
  - `selectAll()`: Truy vấn toàn bộ danh mục từ CSDL `Models.Category.find(query).exec()`.
  - `insert(category)`: Tạo mới đối tượng danh mục kèm `_id = new mongoose.Types.ObjectId()`.
  - `update(category)`: Cập nhật thông tin danh mục theo ID qua `Models.Category.findByIdAndUpdate(category._id, newvalues, { new: true })`.
  - `delete(_id)`: Xóa danh mục khỏi CSDL qua `Models.Category.findByIdAndRemove(_id)`.
- **Tệp [server/api/admin.js](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/server/api/admin.js)**:
  - `GET /api/admin/categories`: Yêu cầu JWT checkToken, trả về danh sách danh mục.
  - `POST /api/admin/categories`: Yêu cầu JWT checkToken, nhận thông tin `name` và lưu mới.
  - `PUT /api/admin/categories/:id`: Yêu cầu JWT checkToken, nhận `_id` và `name` cập nhật.
  - `DELETE /api/admin/categories/:id`: Yêu cầu JWT checkToken, xóa danh mục theo `_id`.

### 2. Phía Client Admin (`/client-admin`)
- **Component [CategoryComponent.js](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/client-admin/src/components/CategoryComponent.js)**:
  - Quản lý danh sách `categories` và mục được chọn `itemSelected`.
  - Hiển thị bảng danh mục bên trái, khi nhấp dòng sẽ kích hoạt `trItemClick(item)` để truyền dữ liệu sang `CategoryDetailComponent`.
  - Tự động gọi `apiGetCategories()` khi component được mount.
- **Component [CategoryDetailComponent.js](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/client-admin/src/components/CategoryDetailComponent.js)**:
  - Chứa ô nhập `txtID` (chế độ readOnly) và `txtName`.
  - Chứa 3 nút bấm: `ADD NEW`, `UPDATE`, `DELETE`.
  - Bắt các sự kiện click (`btnAddClick`, `btnUpdateClick`, `btnDeleteClick`) và gọi tương ứng các hàm API: `apiPostCategory`, `apiPutCategory`, `apiDeleteCategory`.
  - Cập nhật tự động dữ liệu form khi người dùng click chọn item khác qua `componentDidUpdate(prevProps)`.

---

## III. ĐÁNH GIÁ MỨC ĐỘ HOÀN THÀNH & SO KHỚP THỰC TẾ

| Chức năng Lab 03 | Endpoint API & Method | Tình trạng trong Mã nguồn | Kết quả so khớp |
| --- | --- | --- | --- |
| Danh sách danh mục | `GET /api/admin/categories` | Đã triển khai đầy đủ Backend & Frontend | **100% Khớp** |
| Thêm mới danh mục | `POST /api/admin/categories` | Đã kiểm tra trùng lặp & tạo ObjectId tự động | **100% Khớp** |
| Sửa thông tin danh mục | `PUT /api/admin/categories/:id` | Đã cập nhật mượt mà theo `_id` | **100% Khớp** |
| Xóa danh mục | `DELETE /api/admin/categories/:id` | Đã có xác nhận confirm dialog & xóa trong DB | **100% Khớp** |
| Bảo mật API | Header `x-access-token` | Toàn bộ 4 router endpoint đều bọc `JwtUtil.checkToken` | **100% Khớp** |

---

## IV. KẾT LUẬN

Toàn bộ mô-đun **Quản lý Danh mục (Lab 03 - Tuần 3)** đã được triển khai hoàn chỉnh 100%. Quy trình luồng dữ liệu từ React Component -> Axios API (định dạng Header JWT) -> Express Router -> Mongoose DAO -> MongoDB Atlas hoạt động rất ổn định.
