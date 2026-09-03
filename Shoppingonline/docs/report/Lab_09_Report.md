# BÁO CÁO TỔNG KẾT VÀ SO KHỚP TÍNH NĂNG
## LAB 09 - MERN STACK (SHOPPING ONLINE) - TUẦN 9

*Dự án: MERN-Shoppingonline | Ngày báo cáo: 03/09/2026*

---

## I. TỔNG QUAN VỀ BÀI LAB 09 (TUẦN 9)

Bài Lab 09 tập trung vào việc hoàn thiện phân hệ Quản trị viên (Admin) cho nghiệp vụ quản lý tài khoản khách hàng (`Customer Management`) trong ứng dụng thương mại điện tử MERN Stack. Mục tiêu chính là:
1. Cho phép Quản trị viên theo dõi toàn bộ danh sách khách hàng đã đăng ký (`CUSTOMER LIST`), xem danh sách các đơn hàng tương ứng của từng khách hàng (`ORDER LIST`) và xem chi tiết sản phẩm thuộc đơn hàng được chọn (`ORDER DETAIL`).
2. Cung cấp tính năng vô hiệu hóa (`DEACTIVE`) tài khoản khách hàng đang hoạt động (`active = 1` chuyển sang `active = 0`).
3. Cung cấp tính năng gửi lại email xác thực (`EMAIL` / `sendmail`) đối với các tài khoản khách hàng chưa kích hoạt (`active = 0`) để hỗ trợ khách hàng kích hoạt tài khoản bằng ID và token.

### Bảng tóm tắt yêu cầu bài Lab 09:

| STT | Chức năng | Mô tả yêu cầu bài Lab 09 | Tệp tin liên quan |
| --- | --- | --- | --- |
| 1 | Admin - listcustomer | Thêm hàm `selectAll()` vào `CustomerDAO.js`, bổ sung 2 API `GET /api/admin/customers` và `GET /api/admin/orders/customer/:cid` trong `admin.js` bảo vệ bởi JWT. Xây dựng `CustomerComponent.js` hiển thị danh sách khách hàng, danh sách đơn hàng của khách hàng, chi tiết đơn hàng. Đăng ký menu và định tuyến `/admin/customer`. | `CustomerDAO.js`, `admin.js`, `CustomerComponent.js`, `MenuComponent.js`, `MainComponent.js` |
| 2 | Admin - deactive | Bổ sung API `PUT /api/admin/customers/deactive/:id` trong `admin.js` gọi `CustomerDAO.active(_id, token, 0)`. Phía giao diện `CustomerComponent.js`, gán sự kiện click `DEACTIVE` gọi `apiPutCustomerDeactive` và tự động làm mới danh sách khách hàng sau khi cập nhật thành công. | `admin.js`, `CustomerComponent.js` |
| 3 | Admin - sendmail | Thêm hàm `selectByID(_id)` vào `CustomerDAO.js`, bổ sung API `GET /api/admin/customers/sendmail/:id` trong `admin.js` sử dụng `EmailUtil.send(cust.email, cust._id, cust.token)`. Phía giao diện `CustomerComponent.js`, gán sự kiện click `EMAIL` gọi `apiGetCustomerSendmail` và hiển thị thông báo alert kết quả gửi email. | `CustomerDAO.js`, `admin.js`, `CustomerComponent.js` |

---

## II. CHI TIẾT CÁC HẠNG MỤC ĐÃ THỰC HIỆN

### 1. Phía Server (Node.js & Express & Mongoose)
- **`server/models/CustomerDAO.js`** [CẬP NHẬT]:
  - `selectAll()`: Truy vấn danh sách toàn bộ khách hàng trong cơ sở dữ liệu MongoDB bằng `Models.Customer.find({}).exec()`.
  - `selectByID(_id)`: Tìm kiếm thông tin một khách hàng theo mã `_id` bằng `Models.Customer.findById(_id).exec()`.
  
- **`server/api/admin.js`** [CẬP NHẬT]:
  - Import tiện ích gửi email `EmailUtil` và DAO `CustomerDAO`.
  - `GET /api/admin/customers`: Lấy danh sách toàn bộ khách hàng, có bảo vệ xác thực qua `JwtUtil.checkToken`.
  - `GET /api/admin/orders/customer/:cid`: Lấy danh sách toàn bộ đơn hàng của khách hàng có mã `_cid` thông qua `OrderDAO.selectByCustID(_cid)`, bảo vệ bởi `JwtUtil.checkToken`.
  - `PUT /api/admin/customers/deactive/:id`: Cập nhật trạng thái `active = 0` cho khách hàng qua `CustomerDAO.active(_id, token, 0)`, bảo vệ bởi `JwtUtil.checkToken`.
  - `GET /api/admin/customers/sendmail/:id`: Kiểm tra sự tồn tại của khách hàng qua `CustomerDAO.selectByID(_id)` và tiến hành gửi email chứa `_id` cùng `token` kích hoạt qua `EmailUtil.send(cust.email, cust._id, cust.token)`, bảo vệ bởi `JwtUtil.checkToken`.

### 2. Phía Client Admin (React.js & React Router)
- **`client-admin/src/components/CustomerComponent.js`** [MỚI]:
  - Quản lý state tập trung: `customers: []` (danh sách khách hàng), `orders: []` (danh sách đơn hàng của khách hàng được chọn), `order: null` (đơn hàng được chọn xem chi tiết).
  - Khởi tạo nạp dữ liệu khách hàng ngay khi render (`componentDidMount` -> `apiGetCustomers`).
  - Bảng **CUSTOMER LIST**: Liệt kê đầy đủ thông tin: `ID`, `Username`, `Password`, `Name`, `Phone`, `Email`, `Active`, `Action`.
    - Điều kiện hiển thị cột Action: Nếu `item.active === 0`, hiển thị link `EMAIL`; nếu `item.active !== 0`, hiển thị link `DEACTIVE`.
  - Sự kiện click dòng khách hàng (`trCustomerClick`): Xóa đơn hàng chi tiết cũ, gọi API `apiGetOrdersByCustID(item._id)` để nạp và hiển thị bảng **ORDER LIST**.
  - Bảng **ORDER LIST**: Liệt kê `ID`, `Creation date` (định dạng theo locale), `Cust. name`, `Cust. phone`, `Total`, `Status`.
  - Sự kiện click dòng đơn hàng (`trOrderClick`): Lưu đơn hàng vào `state.order` và hiển thị bảng **ORDER DETAIL**.
  - Bảng **ORDER DETAIL**: Liệt kê chi tiết từng sản phẩm trong đơn gồm `No.`, `Prod. ID`, `Prod. name`, `Image` (ảnh base64 kích thước 70x70px), `Price`, `Quantity`, `Amount`.
  - Thao tác `lnkDeactiveClick`: Gửi request PUT vô hiệu hóa tài khoản khách hàng, sau đó cập nhật lại danh sách khách hàng mới nhất.
  - Thao tác `lnkEmailClick`: Gửi request GET kích hoạt server gửi mail xác thực và thông báo alert phản hồi từ server.

- **`client-admin/src/components/MenuComponent.js`** [CẬP NHẬT]:
  - Cập nhật liên kết mục menu `Customer` trỏ đến đường dẫn `/admin/customer`.

- **`client-admin/src/components/MainComponent.js`** [CẬP NHẬT]:
  - Import `Customer` từ `./CustomerComponent`.
  - Khai báo route bảo vệ `<Route path='/admin/customer' element={<Customer />} />`.

---

## III. SO KHỚP VỚI HÌNH ẢNH MẪU VÀ KẾT QUẢ TRIỂN KHAI

Đối chiếu mã nguồn và giao diện thực tế hệ thống với tài liệu chuẩn `Lab 09.pdf`:

### 1. Danh sách khách hàng và đơn đặt hàng (Admin - listcustomer)
- **Giao diện & Cấu trúc bảng**: Khớp 100% hình mẫu tại Trang 5 (`Lab 09.pdf`). Bảng `CUSTOMER LIST` hiển thị trực quan, phân định rõ ràng giữa các khách hàng có `active = 1` và `active = 0`.
- **Luồng tương tác 3 tầng (3-tier view)**:
  - Tầng 1: Chọn khách hàng bất kỳ trên `CUSTOMER LIST`.
  - Tầng 2: Xuất hiện bảng `ORDER LIST` liệt kê các đơn hàng riêng của khách hàng đó.
  - Tầng 3: Nhấp vào bất kỳ đơn hàng nào trên `ORDER LIST`, bảng `ORDER DETAIL` xuất hiện ngay phía dưới với thông tin sản phẩm và ảnh thumbnail chi tiết.

### 2. Vô hiệu hóa tài khoản (Admin - deactive)
- Khớp 100% đặc tả tại Trang 5-6 (`Lab 09.pdf`).
- Đối với khách hàng đang active (`active = 1`), hiển thị nút `DEACTIVE`. Khi click, hệ thống gửi lệnh PUT `/api/admin/customers/deactive/:id` kèm `token` qua request body. Ngay sau khi hoàn tất, danh sách khách hàng được làm mới tự động và nút bấm chuyển thành `EMAIL`.

### 3. Gửi email xác thực (Admin - sendmail)
- Khớp 100% đặc tả tại Trang 6-7 (`Lab 09.pdf`).
- Đối với tài khoản chưa active (`active = 0`), hiển thị nút `EMAIL`. Khi click, API `/api/admin/customers/sendmail/:id` được gọi để gửi email chứa ID và token xác thực đến email của khách hàng. Hệ thống hiển thị hộp thoại alert phản hồi thông báo từ máy chủ (`Please check email`).

---

## IV. KẾT LUẬN

Tất cả các nội dung và yêu cầu trong bài **Lab 09 - MERN stack Shopping Online** đã được hoàn thành trọn vẹn, chính xác 100% theo tài liệu hướng dẫn `Lab 09.pdf`. Không có tính năng nào bị thiếu sót hoặc thêm bớt ngoài phạm vi yêu cầu. Toàn bộ mã nguồn phía Server và Client Admin đã được kiểm tra tính hợp lệ và sẵn sàng vận hành.
