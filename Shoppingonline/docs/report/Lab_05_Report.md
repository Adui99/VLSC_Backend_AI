# BÁO CÁO TỔNG KẾT VÀ SO KHỚP TÍNH NĂNG
## LAB 05 - MERN STACK (SHOPPING ONLINE) - TUẦN 5

*Dự án: MERN-Shoppingonline | Ngày báo cáo: 02/08/2026*

---

## I. TỔNG QUAN VỀ BÀI LAB 05 (TUẦN 5)

Bài Lab 05 tập trung vào việc xây dựng các chức năng dành cho Khách hàng (Customer) trong ứng dụng thương mại điện tử MERN Stack. Mục tiêu chính là cung cấp giao diện trực quan cho người dùng cuối bao gồm: xem sản phẩm mới, sản phẩm bán chạy trên trang chủ, lọc sản phẩm theo danh mục, tìm kiếm theo từ khóa và xem trang chi tiết của từng sản phẩm.

| STT | Chức năng | Mô tả yêu cầu Lab 05 |
| --- | --- | --- |
| 1 | Customer - Home | Hiển thị menu danh mục, thanh trạng thái giỏ hàng, danh sách 3 sản phẩm mới nhất (New Products) và 3 sản phẩm bán chạy (Hot Products). |
| 2 | Customer - List Product | Lọc và hiển thị danh sách sản phẩm thuộc danh mục được chọn khi click vào item menu (`/product/category/:cid`). |
| 3 | Customer - Search | Tìm kiếm sản phẩm theo từ khóa nhập vào khung search trên menu bar (`/product/search/:keyword`). |
| 4 | Customer - Details | Hiển thị chi tiết thông tin sản phẩm (mã, tên, giá, danh mục, hình ảnh, ô nhập số lượng và nút Add To Cart) khi click vào sản phẩm (`/product/:id`). |

---

## II. CHI TIẾT CÁC HẠNG MỤC ĐÃ THỰC HIỆN

### 1. Phía Server (Node.js & Express & Mongoose)
- **`ProductDAO.js`**: Cập nhật thêm các phương thức truy vấn MongoDB:
  - `selectTopNew(top)`: Lấy danh sách sản phẩm mới nhất sắp xếp theo `cdate: -1`.
  - `selectTopHot(top)`: Thực hiện MongoDB Aggregation gom nhóm các đơn hàng có `status: 'APPROVED'` để lấy các sản phẩm có tổng số lượng bán ra nhiều nhất.
  - `selectByCatID(_cid)`: Lấy các sản phẩm thuộc danh mục `_cid`.
  - `selectByKeyword(keyword)`: Tìm kiếm sản phẩm theo tên sử dụng Regex (`$regex`, `i`).
- **`customer.js`**: Tạo Express Router chứa các endpoint (`/categories`, `/products/new`, `/products/hot`, `/products/category/:cid`, `/products/search/:keyword`, `/products/:id`).
- **`index.js`**: Đăng ký router khách hàng tại đường dẫn base `/api/customer`.

### 2. Phía Client Customer (React.js & React Router)
- Cài đặt thư viện `react-router-dom` hỗ trợ điều hướng SPA.
- **`src/utils/withRouter.js`**: Xây dựng Higher-Order Component (HOC) truyền `useParams()` và `useNavigate()` cho các Class Component trong React v6/v7.
- **Component `MenuComponent.js`**: Render menu danh mục động từ API và ô tìm kiếm từ khóa kèm sự kiện `btnSearchClick`.
- **Component `InformComponent.js`**: Thanh trạng thái liên kết tài khoản và đếm số lượng giỏ hàng.
- **Component `HomeComponent.js`**: Gọi API `/products/new` và `/products/hot` để hiển thị 2 khối sản phẩm.
- **Component `ProductComponent.js`**: Xử lý hiển thị danh sách sản phẩm theo danh mục và từ khóa (kèm `componentDidUpdate` để tự động load lại khi đổi param trên URL).
- **Component `ProductDetailComponent.js`**: Hiển thị giao diện thông tin chi tiết sản phẩm.
- **Component `MainComponent.js` & `App.js`**: Cấu hình hệ thống Route và bao bọc `BrowserRouter`.

---

## III. SO KHỚP VỚI HÌNH ẢNH MẪU TRONG BÀI LAB

Đối chiếu giao diện và dữ liệu thực tế hệ thống với tài liệu mẫu `Lab_MERN_05.pdf`:

### 1. Khối HOT PRODUCTS trên Trang chủ
- **Hình chụp bài lab**: Hiển thị tiêu đề HOT PRODUCTS và 3 sản phẩm bán chạy bên dưới tiêu đề NEW PRODUCTS.
- **Nguyên nhân kỹ thuật**: Hàm `selectTopHot` thực hiện aggregate với điều kiện `status: 'APPROVED'`. Ban đầu trong MongoDB chưa có đơn hàng được duyệt, khiến array kết quả rỗng `[]` và React ẩn khối HOT PRODUCTS.
- **Xử lý hoàn thiện**: Đã khởi tạo dữ liệu mẫu 1 đơn hàng `APPROVED` chứa các sản phẩm hot vào MongoDB. Kết quả: Khối HOT PRODUCTS đã hiển thị đầy đủ 3 sản phẩm trên giao diện trang chủ khớp 100% hình mẫu.

### 2. Các danh mục trên Menu (Categories)
- **Hình chụp bài lab**: Menu chỉ hiển thị HOME, IPHONE, IPAD, MACBOOK.
- **Thực tế dự án**: Menu hiển thị HOME, IPAD, IPHONE, MACBOOK, ANDROID.
- **Giải thích**: Code `MenuComponent` lấy dữ liệu danh mục động từ MongoDB (`CategoryDAO.selectAll()`). Cơ sở dữ liệu MongoDB Atlas hiện tại của bạn chứa 4 danh mục bao gồm cả 'Android' (được thêm từ bài thực hành trước). Hệ thống tuân thủ theo nguyên tắc lấy dữ liệu động từ DB.

---

## IV. CÁC TÍNH NĂNG CHƯA ĐƯỢC THÊM VÀO (NGOÀI PHẠM VI LAB 05)

Do bài Lab 05 chỉ đóng vai trò xây dựng giao diện hiển thị cơ bản cho Khách hàng (Read-only Navigation), dưới đây là danh sách các tính năng chưa được thêm vào hoặc chưa hoàn thiện logic (thuộc phạm vi các bài Lab 06 & Lab 07 tiếp theo):

| STT | Tính năng chưa có | Tình trạng & Phạm vi phát triển |
| --- | --- | --- |
| 1 | Quản lý Giỏ hàng (Cart Management) | Nút 'ADD TO CART' trên trang chi tiết mới là form HTML chưa xử lý sự kiện thêm sản phẩm vào Redux/Context/LocalStorage. Số lượng 'My cart have 0 items' chưa cập nhật động. |
| 2 | Xác thực Khách hàng (Customer Auth) | Các liên kết 'Login', 'Sign-up', 'Active' trên thanh Inform chưa được tạo màn hình giao diện, chưa có API đăng nhập/đăng ký/kích hoạt tài khoản bằng OTP email. |
| 3 | Thanh toán & Đặt hàng (Checkout Process) | Chưa có quy trình cho khách hàng xem lại giỏ hàng, nhập địa chỉ nhận hàng và tạo đơn hàng (Checkout). |
| 4 | Phân trang sản phẩm (Pagination) | Trang hiển thị danh sách sản phẩm theo danh mục/tìm kiếm hiển thị toàn bộ kết quả trên một trang, chưa có thanh chuyển trang (Page index buttons). |

---

## V. KẾT LUẬN

Toàn bộ các bước hướng dẫn trong tài liệu Lab 05 đã được thực hiện đầy đủ, chính xác và chuẩn xác theo yêu cầu. Mã nguồn backend và frontend được tổ chức sạch sẽ, sẵn sàng cho việc phát triển các tính năng giỏ hàng và đặt hàng ở Lab 06.