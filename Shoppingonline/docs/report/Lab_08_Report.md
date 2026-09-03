# BÁO CÁO TỔNG KẾT VÀ SO KHỚP TÍNH NĂNG
## LAB 08 - MERN STACK (SHOPPING ONLINE) - TUẦN 8

*Dự án: MERN-Shoppingonline | Ngày báo cáo: 25/08/2026*

---

## I. TỔNG QUAN VỀ BÀI LAB 08 (TUẦN 8)

Bài Lab 08 tập trung vào việc xây dựng các chức năng thuộc phân hệ Quản trị viên (Admin) cho quy trình quản lý đơn hàng (Order Management) và cập nhật trạng thái đơn hàng (Order Approval / Status Update) trong ứng dụng thương mại điện tử MERN Stack. Mục tiêu chính là hoàn thiện luồng nghiệp vụ quản lý đơn hàng phía Admin: từ việc bổ sung các phương thức truy vấn danh sách đơn hàng `selectAll()` và cập nhật trạng thái `update(_id, newStatus)` tại DAO phía Server, xây dựng các API endpoint tương ứng bảo vệ bởi JWT Token (`GET /api/admin/orders`, `PUT /api/admin/orders/status/:id`), đến việc tạo giao diện `OrderComponent.js` phía Client Admin hiển thị danh sách đơn hàng (`ORDER LIST`) sắp xếp giảm dần theo ngày tạo, xem thông tin chi tiết từng mặt hàng (`ORDER DETAIL`) khi chọn dòng đơn hàng, và cung cấp các liên kết `APPROVE` / `CANCEL` cho phép Admin phê duyệt hoặc hủy bỏ các đơn hàng đang ở trạng thái `PENDING`.

### Bảng tóm tắt yêu cầu bài Lab 08:

| STT | Chức năng | Mô tả yêu cầu bài Lab 08 | Tệp tin liên quan |
| --- | --- | --- | --- |
| 1 | Admin - listorder | Thêm hàm `selectAll()` trong `OrderDAO.js` sắp xếp `cdate: -1`, khai báo API `GET /api/admin/orders` bảo vệ bởi JWT token. Xây dựng `OrderComponent.js` hiển thị danh sách đơn hàng (`ORDER LIST`) và chi tiết mặt hàng (`ORDER DETAIL`). Đăng ký tuyến đường `/admin/order` tại `MenuComponent.js` và `MainComponent.js`. | `OrderDAO.js`, `admin.js`, `OrderComponent.js`, `MenuComponent.js`, `MainComponent.js` |
| 2 | Admin - updatestatus | Thêm hàm `update(_id, newStatus)` trong `OrderDAO.js`, khai báo API `PUT /api/admin/orders/status/:id` cập nhật trạng thái. Tại `OrderComponent.js`, thêm nút `APPROVE` và `CANCEL` cho các đơn hàng `PENDING`, gọi hàm `apiPutOrderStatus` cập nhật dữ liệu và làm mới lại danh sách. | `OrderDAO.js`, `admin.js`, `OrderComponent.js` |

---

## II. CHI TIẾT CÁC HẠNG MỤC ĐÃ THỰC HIỆN

### 1. Phía Server (Node.js & Express & Mongoose)
- **`server/models/OrderDAO.js`** [CẬP NHẬT]:
  - `selectAll()`: Truy vấn toàn bộ đơn hàng trong MongoDB, sắp xếp giảm dần theo thời gian tạo (`cdate: -1`).
  - `update(_id, newStatus)`: Cập nhật trạng thái đơn hàng theo `_id` thông qua `Models.Order.findByIdAndUpdate(_id, { status: newStatus }, { new: true })`.

- **`server/api/admin.js`** [CẬP NHẬT]:
  - Import `OrderDAO` từ `../models/OrderDAO`.
  - `GET /api/admin/orders`: Endpoint lấy toàn bộ danh sách đơn hàng cho admin, bảo vệ bởi middleware `JwtUtil.checkToken`.
  - `PUT /api/admin/orders/status/:id`: Endpoint cập nhật trạng thái đơn hàng theo `id`, bảo vệ bởi middleware `JwtUtil.checkToken`.

### 2. Phía Client Admin (React.js & React Router)
- **`src/components/OrderComponent.js`** [MỚI]:
  - Quản lý state gồm `orders: []` (danh sách đơn hàng) và `order: null` (đơn hàng được chọn để xem chi tiết).
  - Khi mount component (`componentDidMount`), gọi API `apiGetOrders()` để nạp danh sách đơn hàng từ Server.
  - Bảng `ORDER LIST`: Hiển thị các cột `ID`, `Creation date`, `Cust. name`, `Cust. phone`, `Total`, `Status`, `Action`.
  - Cột `Action`: Nếu đơn hàng ở trạng thái `PENDING`, hiển thị 2 liên kết `APPROVE` và `CANCEL`. Khi click sẽ kích hoạt tương ứng `lnkApproveClick(id)` hoặc `lnkCancelClick(id)` gọi API `apiPutOrderStatus(id, status)` và tải lại danh sách đơn hàng sau khi cập nhật thành công.
  - Sự kiện `trItemClick(item)`: Đơn hàng được click sẽ lưu vào state `order`.
  - Bảng `ORDER DETAIL`: Tự động xuất hiện khi `state.order` có dữ liệu, hiển thị chi tiết sản phẩm thuộc đơn hàng gồm: `No.`, `Prod. ID`, `Prod. name`, `Image` (base64 70x70px), `Price`, `Quantity`, `Amount`.

- **`src/components/MenuComponent.js`** [CẬP NHẬT]:
  - Cập nhật mục menu `Order` liên kết tới route `/admin/order`.

- **`src/components/MainComponent.js`** [CẬP NHẬT]:
  - Import `Order` từ `./OrderComponent`.
  - Thêm tuyến đường `<Route path='/admin/order' element={<Order />} />`.

---

## III. SO KHỚP VỚI HÌNH ẢNH MẪU VÀ KẾT QUẢ TRIỂN KHAI

Đối chiếu mã nguồn và giao diện thực tế hệ thống với tài liệu chuẩn `Lab 08.pdf`:

### 1. Danh sách đơn hàng phía Admin (Admin - listorder)
- **Giao diện & Bảng dữ liệu**: Khớp 100% hình mẫu tại Trang 5 (`Lab 08.pdf`). Tiêu đề `ORDER LIST` với đầy đủ các cột thông tin khách hàng, tổng tiền, trạng thái đơn hàng.
- **Xem chi tiết đơn hàng**: Khi click vào từng đơn hàng trên danh sách, bảng `ORDER DETAIL` phía dưới xuất hiện hiển thị các mặt hàng trong đơn kèm hình ảnh thumbnail và thành tiền chính xác.

### 2. Cập nhật trạng thái đơn hàng (Admin - updatestatus)
- **Duyệt & Hủy đơn hàng**: Khớp 100% mã nguồn và quy trình tại Trang 5-6 (`Lab 08.pdf`). Nhấn `APPROVE` chuyển trạng thái đơn thành `APPROVED`, nhấn `CANCEL` chuyển thành `CANCELED`. Ngay sau khi API cập nhật thành công, danh sách đơn hàng tự động làm mới để phản ánh trạng thái mới.

---

## IV. KẾT LUẬN

Tất cả các chức năng thuộc bài **Lab 08 - MERN stack Shopping Online** đã được hoàn thành trọn vẹn, chính xác 100% theo đúng tài liệu hướng dẫn `Lab 08.pdf`. Hệ thống quản trị đơn hàng phía Admin hoạt động ổn định và kết nối đồng bộ với cơ sở dữ liệu MongoDB.
