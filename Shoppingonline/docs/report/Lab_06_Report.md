# BÁO CÁO TỔNG KẾT VÀ SO KHỚP TÍNH NĂNG
## LAB 06 - MERN STACK (SHOPPING ONLINE) - TUẦN 6

*Dự án: MERN-Shoppingonline | Ngày báo cáo: 09/08/2026*

---

## I. TỔNG QUAN VỀ BÀI LAB 06 (TUẦN 6)

Bài Lab 06 tập trung vào việc xây dựng hệ thống xác thực và quản lý thông tin Khách hàng (Customer Authentication & Profile Management) trong ứng dụng thương mại điện tử MERN Stack. Mục tiêu chính là hoàn thiện luồng nghiệp vụ từ đăng ký tài khoản, gửi email xác thực kèm token kích hoạt, kích hoạt tài khoản, đăng nhập/đăng xuất bằng React Context & JWT Token cho tới quản lý và cập nhật thông tin cá nhân.

### Bảng tóm tắt yêu cầu bài Lab 06:

| STT | Chức năng | Mô tả yêu cầu bài Lab 06 | Tệp tin liên quan |
| --- | --- | --- | --- |
| 1 | Customer - Signup | Xây dựng DAO & API đăng ký tài khoản mới, kiểm tra trùng username/email, tạo token MD5, tạo giao diện Sign-up và tự động gửi email xác thực qua Nodemailer. | `CustomerDAO.js`, `customer.js`, `EmailUtil.js`, `SignupComponent.js` |
| 2 | Customer - Active | Xây dựng API kích hoạt tài khoản dựa trên `_id` và `token`, tạo giao diện Active Account để người dùng kích hoạt tài khoản `active: 1`. | `CustomerDAO.js`, `customer.js`, `ActiveComponent.js` |
| 3 | Customer - Login & Logout | Xây dựng API đăng nhập (kiểm tra tài khoản đã kích hoạt `active === 1`, cấp JWT token), API kiểm tra token, thiết lập React Context (`MyContext`, `MyProvider`), giao diện Login và xử lý Đăng xuất. | `CustomerDAO.js`, `customer.js`, `MyContext.js`, `MyProvider.js`, `LoginComponent.js`, `InformComponent.js` |
| 4 | Customer - My Profile | Xây dựng API cập nhật thông tin khách hàng bảo vệ bởi JWT Token (`PUT /api/customer/customers/:id`), giao diện My Profile cho phép xem và cập nhật thông tin cá nhân. | `CustomerDAO.js`, `customer.js`, `MyprofileComponent.js`, `InformComponent.js` |

---

## II. CHI TIẾT CÁC HẠNG MỤC ĐÃ THỰC HIỆN

### 1. Phía Server (Node.js & Express & Mongoose)
- **`server/models/CustomerDAO.js`** [MỚI]:
  - `selectByUsernameOrEmail(username, email)`: Kiểm tra tài khoản đã tồn tại theo username hoặc email bằng truy vấn `$or`.
  - `insert(customer)`: Thêm tài khoản khách hàng mới vào MongoDB với ObjectId tự sinh.
  - `active(_id, token, active)`: Cập nhật trạng thái `active: 1` cho tài khoản khớp `_id` và `token`.
  - `selectByUsernameAndPassword(username, password)`: Tìm kiếm tài khoản phục vụ xác thực đăng nhập.
  - `update(customer)`: Cập nhật thông tin cá nhân (`username`, `password`, `name`, `phone`, `email`) theo `_id`.

- **`server/utils/MyConstants.js` & `server/utils/EmailUtil.js`** [CẬP NHẬT]:
  - Cấu hình thông tin tài khoản Gmail gửi xác thực (`EMAIL_USER`, `EMAIL_PASS`) cùng dịch vụ nodemailer `service: 'gmail'`.
  - Hàm `EmailUtil.send(email, id, token)` thực hiện gửi email tự động chứa `_id` và `token` kích hoạt đến hộp thư của người dùng sau khi đăng ký thành công.

- **`server/api/customer.js`** [CẬP NHẬT]:
  - `POST /api/customer/signup`: Tiếp nhận thông tin đăng ký, tạo mã token MD5 từ timestamp, lưu thông tin khách hàng (`active: 0`) và gọi `EmailUtil` gửi email xác thực.
  - `POST /api/customer/active`: Tiếp nhận `id` và `token`, cập nhật trạng thái kích hoạt tài khoản (`active: 1`).
  - `POST /api/customer/login`: Kiểm tra đăng nhập, xác minh tài khoản đã kích hoạt (`active === 1`), trả về JWT token và thông tin khách hàng.
  - `GET /api/customer/token`: Đóng vai trò kiểm tra token hợp lệ bằng middleware `JwtUtil.checkToken`.
  - `PUT /api/customer/customers/:id`: Endpoint cập nhật hồ sơ cá nhân được bảo vệ bởi middleware `JwtUtil.checkToken`.

### 2. Phía Client Customer (React.js & React Context & React Router)
- **`src/contexts/MyContext.js` & `src/contexts/MyProvider.js`** [MỚI]:
  - Xây dựng React Context toàn cục lưu trữ trạng thái đăng nhập (`token`, `customer`) cùng các hàm cập nhật trạng thái (`setToken`, `setCustomer`).
- **`src/App.js`** [CẬP NHẬT]:
  - Bao bọc ứng dụng `<BrowserRouter>` bên trong `<MyProvider>` để cung cấp dữ liệu xác thực cho toàn hệ thống.
- **`src/components/SignupComponent.js`** [MỚI]:
  - Giao diện form đăng ký tài khoản với các trường: Username, Password, Name, Phone, Email. Xử lý sự kiện gửi request đến API `/api/customer/signup`.
- **`src/components/ActiveComponent.js`** [MỚI]:
  - Giao diện kích hoạt tài khoản nhận `ID` và `Token`, gọi API `/api/customer/active` và thông báo kết quả (`OK BABY!` / `SORRY BABY!`).
- **`src/components/LoginComponent.js`** [MỚI]:
  - Giao diện đăng nhập kết nối React Context (`static contextType = MyContext`) và HOC `withRouter`. Đăng nhập thành công sẽ lưu token/customer vào context và tự động chuyển hướng về `/home`.
- **`src/components/MyprofileComponent.js`** [MỚI]:
  - Giao diện quản lý thông tin cá nhân. Tự động kiểm tra đăng nhập (chuyển hướng `/login` nếu chưa đăng nhập), nạp dữ liệu từ context vào form khi `componentDidMount`, gửi request `PUT` kèm header `x-access-token` để cập nhật dữ liệu.
- **`src/components/InformComponent.js`** [CẬP NHẬT]:
  - Cập nhật hiển thị linh hoạt theo trạng thái xác thực trong Context:
    - Khi chưa đăng nhập: Hiển thị các liên kết `Login | Sign-up | Active`.
    - Khi đã đăng nhập: Hiển thị `Hello <name> | Logout | My profile | My orders` và xử lý sự kiện Đăng xuất.
- **`src/components/MainComponent.js`** [CẬP NHẬT]:
  - Tích hợp 4 tuyến đường mới vào hệ thống Router: `/signup`, `/active`, `/login`, `/myprofile`.

---

## III. SO KHỚP VỚI HÌNH ẢNH MẪU VÀ KẾT QUẢ TRIỂN KHAI

Đối chiếu mã nguồn và giao diện thực tế hệ thống với tài liệu chuẩn `Lab 06.pdf`:

### 1. Luồng Đăng ký & Email kích hoạt (Customer - signup)
- **Cấu trúc Form & Layout**: Khớp 100% hình mẫu tại Trang 5 (`Lab 06.pdf`). Tiêu đề `SIGN-UP`, bảng chứa các trường nhập liệu căn giữa.
- **Email gửi xác thực**: API tự động gửi email với nội dung chuẩn hóa chứa ID và Token kích hoạt.

### 2. Luồng Kích hoạt tài khoản (Customer - active)
- **Giao diện & Phản hồi**: Khớp 100% hình mẫu tại Trang 7 (`Lab 06.pdf`). Tiêu đề `ACTIVE ACCOUNT` với 2 ô nhập ID và Token.
- **Xử lý MongoDB**: Tài khoản được cập nhật `active: 1` chuẩn xác sau khi kích hoạt thành công.

### 3. Luồng Đăng nhập & Đăng xuất (Customer - login & logout)
- **Giao diện Login**: Khớp 100% hình mẫu tại Trang 11 (`Lab 06.pdf`). Tiêu đề `CUSTOMER LOGIN`.
- **Chuyển đổi trạng thái Inform Bar**: Khi đăng nhập thành công, thanh Inform tự động hiển thị tên khách hàng (`Hello <name>`) và liên kết `Logout`, `My profile`, `My orders` khớp hoàn toàn với màn hình mẫu tại Trang 11.
- **Đăng xuất**: Khi click `Logout`, Context reset `token: ''` và `customer: null`, thanh Inform quay về trạng thái `Login | Sign-up | Active`.

### 4. Luồng Hồ sơ cá nhân (Customer - myprofile)
- **Giao diện & Cập nhật**: Khớp 100% hình mẫu tại Trang 14 (`Lab 06.pdf`). Tự động load thông tin khách hàng hiện tại và cập nhật dữ liệu thành công qua phương thức `PUT`.

---

## IV. CÁC TÍNH NĂNG CHƯA ĐƯỢC THÊM VÀO (NGOÀI PHẠM VI LAB 06)

Do bài Lab 06 tập trung hoàn toàn vào việc xác thực tài khoản và quản lý thông tin cá nhân của Khách hàng, các chức năng nghiệp vụ sau chưa được thêm vào hoặc chưa xử lý logic (thuộc phạm vi bài Lab 07 tiếp theo):

| STT | Tính năng chưa có | Tình trạng & Phạm vi phát triển |
| --- | --- | --- |
| 1 | Quản lý Giỏ hàng (My Cart) | Các nút 'ADD TO CART' và trang xem chi tiết giỏ hàng chưa xử lý lưu giỏ hàng vào Context/Redux, số lượng 'My cart have 0 items' chưa cập nhật động. |
| 2 | Đặt hàng & Thanh toán (Checkout) | Chưa có quy trình tạo đơn hàng từ giỏ hàng, chọn phương thức thanh toán và lưu đơn hàng vào MongoDB. |
| 3 | Lịch sử Đơn hàng (My Orders) | Liên kết 'My orders' trên thanh Inform chưa được tạo màn hình giao diện xem danh sách đơn hàng đã đặt của khách hàng. |

---

## V. KẾT LUẬN

Toàn bộ các bước hướng dẫn trong tài liệu Lab 06 đã được thực hiện đầy đủ, đúng và chuẩn xác theo yêu cầu bài thực hành. Mã nguồn Backend Node.js và Frontend React Client được biên dịch 100% không có lỗi cú pháp hay xung đột phiên bản (`Compiled successfully`). Hệ thống xác thực khách hàng bằng React Context & JWT Token hoạt động ổn định, sẵn sàng cho việc phát triển tính năng giỏ hàng và đặt hàng ở Lab 07.
