# BÁO CÁO TỔNG KẾT VÀ SO KHỚP TÍNH NĂNG
## LAB 07 - MERN STACK (SHOPPING ONLINE) - TUẦN 7

*Dự án: MERN-Shoppingonline | Ngày báo cáo: 14/08/2026*

---

## I. TỔNG QUAN VỀ BÀI LAB 07 (TUẦN 7)

Bài Lab 07 tập trung vào việc xây dựng quy trình quản lý giỏ hàng (Cart Management), thanh toán đặt hàng (Checkout Process) và quản lý lịch sử đơn hàng (My Orders) cho phía Khách hàng (Customer) trong ứng dụng thương mại điện tử MERN Stack. Mục tiêu chính là hoàn thiện luồng nghiệp vụ mua hàng: từ việc chọn số lượng sản phẩm, thêm vào giỏ hàng lưu trữ trong React Context, xem/xóa sản phẩm trong giỏ, tính tổng số tiền qua Utility, đến tiến hành thanh toán gửi dữ liệu về Server để lưu đơn hàng vào MongoDB với trạng thái `PENDING`, và cho phép khách hàng xem lại danh sách đơn hàng cũng như chi tiết từng đơn hàng đã đặt.

### Bảng tóm tắt yêu cầu bài Lab 07:

| STT | Chức năng | Mô tả yêu cầu bài Lab 07 | Tệp tin liên quan |
| --- | --- | --- | --- |
| 1 | Customer - add2cart | Cập nhật React Context toàn cục để quản lý danh sách giỏ hàng `mycart: []`, kết nối `ProductDetailComponent` với Context, bổ sung ô nhập số lượng `txtQuantity` và xử lý sự kiện `btnAdd2CartClick` (thêm mới hoặc cộng dồn số lượng sản phẩm). | `MyProvider.js`, `MyContext.js`, `ProductDetailComponent.js`, `InformComponent.js` |
| 2 | Customer - mycart | Xây dựng module tiện ích `CartUtil.js` tính tổng tiền, tạo giao diện `MycartComponent.js` hiển thị danh sách sản phẩm trong giỏ kèm bảng chi tiết, tính tổng tiền, cập nhật thanh `InformComponent` (reset giỏ hàng khi Logout, hiển thị số item động) và khai báo route `/mycart` tại `MainComponent.js`. | `CartUtil.js`, `MycartComponent.js`, `InformComponent.js`, `MainComponent.js` |
| 3 | Customer - remove2cart | Xây dựng sự kiện `lnkRemoveClick(id)` trong `MycartComponent.js` cho phép xóa sản phẩm khỏi giỏ hàng theo `_id` sản phẩm và cập nhật lại trạng thái giỏ hàng trong React Context. | `MycartComponent.js`, `MyProvider.js` |
| 4 | Customer - checkout | Tạo `OrderDAO.js` với hàm `insert(order)`, xây dựng API `POST /api/customer/checkout` bảo vệ bởi JWT Token. Tại Client, thêm hàm `lnkCheckoutClick` xác nhận đặt hàng và `apiCheckout` gửi thông tin đơn hàng (`total`, `items`, `customer`, `status: 'PENDING'`) về Server, xóa sạch giỏ hàng và chuyển hướng về `/home`. | `OrderDAO.js`, `customer.js`, `MycartComponent.js` |
| 5 | Customer - myorders | Thêm hàm `selectByCustID(_cid)` trong `OrderDAO.js`, xây dựng API `GET /api/customer/orders/customer/:cid` lấy danh sách đơn hàng. Tạo giao diện `MyordersComponent.js` hiển thị danh sách đơn hàng (`ORDER LIST`) và chi tiết đơn hàng (`ORDER DETAIL`) khi click dòng tương ứng. Thêm liên kết `My orders` trên `InformComponent` và route `/myorders` tại `MainComponent`. | `OrderDAO.js`, `customer.js`, `MyordersComponent.js`, `InformComponent.js`, `MainComponent.js` |

---

## II. CHI TIẾT CÁC HẠNG MỤC ĐÃ THỰC HIỆN

### 1. Phía Server (Node.js & Express & Mongoose)
- **`server/models/OrderDAO.js`** [MỚI]:
  - `insert(order)`: Sinh ObjectId mới cho đơn hàng và thực hiện chèn dữ liệu vào bảng Orders trong MongoDB thông qua model `Models.Order.create`.
  - `selectByCustID(_cid)`: Truy vấn danh sách tất cả các đơn hàng thuộc về khách hàng theo trường `'customer._id'`.

- **`server/api/customer.js`** [CẬP NHẬT]:
  - Import `OrderDAO` từ `../models/OrderDAO`.
  - `POST /api/customer/checkout`: Endpoint thanh toán giỏ hàng được bảo vệ bởi middleware `JwtUtil.checkToken`. Nhận thông tin `total`, `items`, `customer`, tạo mốc thời gian `cdate` dạng timestamp và thiết lập trạng thái mặc định `status: 'PENDING'`, sau đó gọi `OrderDAO.insert(order)` để ghi nhận đơn hàng.
  - `GET /api/customer/orders/customer/:cid`: Endpoint lấy lịch sử đơn hàng của khách hàng theo `cid`, được bảo vệ bởi middleware `JwtUtil.checkToken`.

### 2. Phía Client Customer (React.js & React Context & React Router)
- **`src/contexts/MyProvider.js`** [CẬP NHẬT]:
  - Thêm biến `mycart: []` vào state của `MyProvider`.
  - Khai báo hàm `setMycart = (value) => { this.setState({ mycart: value }); }` và truyền vào Value của Context Provider.

- **`src/components/ProductDetailComponent.js`** [CẬP NHẬT]:
  - Đăng ký `static contextType = MyContext`.
  - Bổ sung `txtQuantity: 1` vào state.
  - Gắn value và onChange cho input số lượng (`min="1" max="99"`).
  - Bổ sung hàm xử lý sự kiện `btnAdd2CartClick(e)`: Kiểm tra xem sản phẩm đã có trong giỏ hàng (`mycart`) hay chưa bằng `findIndex`. Nếu chưa có thì push item mới `{ product, quantity }`, nếu đã có thì cộng dồn `quantity += quantity`. Gọi `setMycart` và hiển thị thông báo `OK BABY !`.

- **`src/utils/CartUtil.js`** [MỚI]:
  - Định nghĩa utility `CartUtil` chứa hàm `getTotal(mycart)` duyệt qua danh sách sản phẩm trong giỏ và tính tổng số tiền `sum(price * quantity)`.

- **`src/components/MycartComponent.js`** [MỚI]:
  - Giao diện bảng danh sách sản phẩm trong giỏ hàng (`ITEM LIST`) với đầy đủ các cột: STT (`No.`), `ID`, `Name`, `Category`, `Image` (ảnh dạng base64), `Price`, `Quantity`, `Amount`, `Action`.
  - Cột `Total` gọi `CartUtil.getTotal(this.context.mycart)` hiển thị tổng thành tiền.
  - Cột `Action` có nút `Remove` gắn hàm `lnkRemoveClick(id)` thực hiện xóa item khỏi mảng `mycart` thông qua `splice` và gọi `setMycart`.
  - Nút `CHECKOUT` gắn sự kiện `lnkCheckoutClick()`: Xác nhận người dùng (`confirm('ARE YOU SURE?')`), kiểm tra giỏ hàng có dữ liệu, kiểm tra trạng thái đăng nhập (chuyển tới `/login` nếu chưa đăng nhập). Khi đủ điều kiện thì gọi `apiCheckout`, thực hiện request `POST /api/customer/checkout`, thông báo `OK BABY !`, xóa giỏ hàng (`setMycart([])`) và điều hướng về trang chủ (`/home`).

- **`src/components/MyordersComponent.js`** [MỚI]:
  - Kiểm tra token người dùng (nếu chưa đăng nhập tự động chuyển về `/login`).
  - Khi render, nạp danh sách đơn hàng từ API `apiGetOrdersByCustID(cid)` và hiển thị bảng `ORDER LIST` với các thông tin: `ID`, `Creation date`, `Cust.name`, `Cust.phone`, `Total`, `Status`.
  - Sự kiện `trItemClick(item)` khi click vào một hàng đơn hàng sẽ lưu đơn hàng được chọn vào `state.order`.
  - Khi `state.order` có giá trị, tự động hiển thị thêm bảng chi tiết đơn hàng `ORDER DETAIL` gồm các sản phẩm đã mua trong đơn hàng đó (`No.`, `Prod.ID`, `Prod.name`, `Image`, `Price`, `Quantity`, `Amount`).

- **`src/components/InformComponent.js`** [CẬP NHẬT]:
  - Cập nhật liên kết `My cart` dẫn tới route `/mycart` và hiển thị số lượng sản phẩm trong giỏ một cách linh hoạt qua `this.context.mycart.length`.
  - Cập nhật liên kết `My orders` dẫn tới route `/myorders`.
  - Cập nhật hàm `lnkLogoutClick()` thêm thao tác reset giỏ hàng `this.context.setMycart([])`.

- **`src/components/MainComponent.js`** [CẬP NHẬT]:
  - Import `MycartComponent` và `MyordersComponent`.
  - Bổ sung 2 tuyến đường chính: `<Route path='/mycart' element={<Mycart />} />` và `<Route path='/myorders' element={<Myorders />} />`.

---

## III. SO KHỚP VỚI HÌNH ẢNH MẪU VÀ KẾT QUẢ TRIỂN KHAI

Đối chiếu mã nguồn và giao diện thực tế hệ thống với tài liệu chuẩn `Lab 07.pdf`:

### 1. Thêm sản phẩm vào giỏ hàng (Customer - add2cart)
- **Giao diện & Thao tác**: Khớp 100% hình mẫu tại Trang 3 (`Lab 07.pdf`).
- **Thanh Inform Bar**: Ngay khi click `ADD TO CART` và bật alert `OK BABY !`, số lượng sản phẩm ở thanh Inform Bar ngay lập tức cập nhật thành `My cart have X items`.

### 2. Xem giỏ hàng (Customer - mycart)
- **Cấu trúc Bảng & Layout**: Khớp 100% hình mẫu tại Trang 4 & 6 (`Lab 07.pdf`). Tiêu đề `ITEM LIST`, bảng hiển thị số thứ tự, hình ảnh thu nhỏ `70px x 70px`, đơn giá, số lượng, thành tiền từng dòng và dòng tổng cộng tiền (`Total`).

### 3. Xóa sản phẩm khỏi giỏ (Customer - remove2cart)
- **Thao tác xóa**: Khớp 100% hình mẫu tại Trang 6 (`Lab 07.pdf`). Khi nhấn liên kết `Remove`, sản phẩm tương ứng lập tức bị xóa khỏi giỏ và tổng tiền được tính toán lại chính xác.

### 4. Thanh toán đơn hàng (Customer - checkout)
- **Quy trình Xác nhận & API**: Khớp 100% hình mẫu tại Trang 7 & 8 (`Lab 07.pdf`). Đặt hàng thành công hiển thị thông báo `OK BABY !`, giỏ hàng tự động xóa trống (`0 items`) và chuyển hướng người dùng về trang chủ (`/home`). Đơn hàng lưu vào MongoDB với trạng thái `PENDING`.

### 5. Xem đơn hàng & Chi tiết đơn hàng (Customer - myorders)
- **Giao diện 2 Bảng**: Khớp 100% hình mẫu tại Trang 11 (`Lab 07.pdf`). Bảng `ORDER LIST` hiển thị danh sách đơn hàng đã đặt. Khi click vào từng đơn hàng, bảng `ORDER DETAIL` phía dưới lập tức xuất hiện hiển thị chính xác các mặt hàng đã mua cùng số lượng và số tiền tương ứng.

---

## IV. CÁC TÍNH NĂNG ĐÃ HOÀN THÀNH VÀ PHẠM VI TIẾP THEO (LAB 08)

Hiện tại, bài Lab 07 đã hoàn thành trọn vẹn toàn bộ tất cả các tính năng thuộc phân hệ Khách hàng (Customer) bao gồm:
1. Xem sản phẩm, danh mục, tìm kiếm sản phẩm.
2. Đăng ký, kích hoạt tài khoản qua email, đăng nhập, đăng xuất, cập nhật thông tin cá nhân.
3. Quản lý giỏ hàng (thêm, xóa, tính tổng tiền), đặt hàng thanh toán và theo dõi danh sách/chi tiết đơn hàng.

Phạm vi phát triển bài Lab 08 tiếp theo sẽ tập trung vào phân hệ **Quản trị viên (Admin)**:
- Đăng nhập Admin, quản lý Danh mục (Category), sản phẩm (Product), khách hàng (Customer) và quản lý cập nhật trạng thái đơn hàng (Order Approval / Status Update).

---

## V. KẾT LUẬN

Tất cả các chức năng thuộc bài **Lab 07 - MERN stack Shopping Online** đã được triển khai thành công, đảm bảo đúng 100% cấu trúc file, thuật toán và giao diện theo đúng tài liệu hướng dẫn `Lab 07.pdf`. Hệ thống hoạt động mượt mà, không phát sinh lỗi cú pháp hay lỗi xung đột dữ liệu.
