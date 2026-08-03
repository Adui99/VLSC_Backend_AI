# BÁO CÁO TỔNG KẾT VÀ SO KHỚP TÍNH NĂNG
## LAB 04 - MERN STACK (SHOPPING ONLINE) - TUẦN 4

*Dự án: MERN-Shoppingonline | Ngày báo cáo: 02/08/2026*

---

## I. TỔNG QUAN VỀ BÀI LAB 04 (TUẦN 4)

Bài Lab 04 mở rộng hệ thống quản trị dành cho Admin với chức năng Quản lý Sản phẩm (Product Management). Điểm nổi bật của bài lab này là tích hợp kỹ thuật Phân trang ở phía Server (Server-side Pagination), xử lý upload và xem trước hình ảnh dạng mã hóa Base64 (`FileReader` API), liên kết danh mục sản phẩm và đầy đủ bộ chức năng CRUD (Create, Read, Update, Delete).

### Bảng tóm tắt yêu cầu bài Lab 04:

| STT | Chức năng | Mô tả yêu cầu bài Lab 04 |
| --- | --- | --- |
| 1 | Admin - List Product | Hiển thị danh sách sản phẩm phân trang (4 sản phẩm/trang), có thanh chọn số trang (`| 1 | 2 | 3 |`) và hiển thị ảnh thumbnail Base64. |
| 2 | Admin - Add Product | Thêm mới sản phẩm bao gồm Tên, Giá, Danh mục (Dropdown select) và Chọn tệp ảnh tải lên (Chuyển thành chuỗi Base64). |
| 3 | Admin - Update Product | Cập nhật thông tin sản phẩm (Tên, Giá, Danh mục, Hình ảnh) theo `_id` sản phẩm đã chọn. |
| 4 | Admin - Delete Product | Xóa sản phẩm theo `_id` kèm xử lý chuyển trang tự động khi trang hiện tại không còn sản phẩm. |

---

## II. CHI TIẾT CÁC HẠNG MỤC ĐÃ THỰC HIỆN & SO KHỚP MÃ NGUỒN

### 1. Phía Server (`/server`)
- **Tệp [server/models/ProductDAO.js](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/server/models/ProductDAO.js)**:
  - `selectAll()`: Truy vấn danh sách toàn bộ sản phẩm.
  - `selectByID(_id)`: Lấy chi tiết thông tin 1 sản phẩm theo ID.
  - `insert(product)`: Tạo mới sản phẩm với `_id` ObjectId tự động.
  - `update(product)`: Cập nhật thông tin sản phẩm qua `findByIdAndUpdate`.
  - `delete(_id)`: Xóa sản phẩm khỏi MongoDB qua `findByIdAndRemove`.
- **Tệp [server/api/admin.js](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/server/api/admin.js)**:
  - `GET /api/admin/products?page=xxx`: Thực hiện tính toán phân trang:
    - `sizePage = 4`
    - `noPages = Math.ceil(products.length / sizePage)`
    - `offset = (curPage - 1) * sizePage`
    - Trả về đối tượng `{ products, noPages, curPage }`.
  - `POST /api/admin/products`: Nhận thông tin sản phẩm và chuỗi ảnh Base64, lấy thông tin danh mục qua `CategoryDAO.selectByID(cid)`, gắn thời gian tạo `cdate = new Date().getTime()`, sau đó lưu vào CSDL.
  - `PUT /api/admin/products/:id`: Cập nhật lại sản phẩm theo ID.
  - `DELETE /api/admin/products/:id`: Xóa sản phẩm theo ID.

### 2. Phía Client Admin (`/client-admin`)
- **Component [ProductComponent.js](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/client-admin/src/components/ProductComponent.js)**:
  - Hiển thị bảng danh sách sản phẩm với các cột: ID, Name, Price, Creation date, Category, Image (`data:image/jpg;base64,...`).
  - Xây dựng dải phân trang động `pagination`: highlight trang hiện tại và cho phép click chọn trang (`lnkPageClick(index + 1)`).
  - Tích hợp tự động quay lại trang trước nếu trang hiện tại bị trống sau khi xóa sản phẩm (`apiDeleteProduct`).
- **Component [ProductDetailComponent.js](file:///c:/ADUI/VLSC_BACKEND/MERN-Shoppingonline/VLSC_Backend_AI/Shoppingonline/client-admin/src/components/ProductDetailComponent.js)**:
  - Hiển thị danh mục động trong ô chọn `<select>` qua `apiGetCategories()`.
  - Xử lý đọc tệp hình ảnh bằng `FileReader` qua hàm `previewImage(e)`, chuyển đổi tệp chọn thành chuỗi Base64 để gửi lên server và hiển thị hình xem trước (preview) kích thước 300x300px.
  - Các nút `ADD NEW`, `UPDATE`, `DELETE` tương tác với server chuẩn xác qua Axios.

---

## III. ĐÁNH GIÁ MỨC ĐỘ HOÀN THÀNH & SO KHỚP THỰC TẾ

| Chức năng Lab 04 | Yêu cầu kỹ thuật PDF | Tình trạng trong Mã nguồn | Kết quả so khớp |
| --- | --- | --- | --- |
| Server Pagination | Slice 4 items/page, tính `noPages` | Đã triển khai chuẩn xác trong `admin.js` | **100% Khớp** |
| Upload & Preview Image | Mã hóa Base64 bằng `FileReader` | Đã xử lý xem trước và lưu chuỗi Base64 | **100% Khớp** |
| Liên kết Category | Lưu chi tiết Category object trong Product | Đã gọi `CategoryDAO.selectByID` để nhúng vào Product | **100% Khớp** |
| Thao tác CRUD Sản phẩm | Đầy đủ 4 phương thức API GET, POST, PUT, DELETE | Đã test và hoạt động hoàn hảo trên giao diện | **100% Khớp** |
| Xử lý phân trang khi Xóa | Lùi về trang trước nếu `products.length === 0` | Đã code logic fallback tự động trong `apiGetProducts` | **100% Khớp** |

---

## IV. KẾT LUẬN

Mô-đun **Quản lý Sản phẩm (Lab 04 - Tuần 4)** đã hoàn thành 100% yêu cầu. Kỹ thuật phân trang Server-side và lưu trữ hình ảnh mã hóa Base64 giúp hệ thống quản trị xử lý dữ liệu nhanh chóng và linh hoạt.
