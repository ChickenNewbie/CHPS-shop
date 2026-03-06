# 👟 CHPS - Mobile E-Commerce App (Flutter)

CHPS là ứng dụng di động mua sắm giày dép trực tuyến được phát triển bằng Flutter. Ứng dụng cung cấp giao diện người dùng hiện đại, mượt mà, tích hợp đăng nhập mạng xã hội và kết nối với Backend API riêng biệt để xử lý dữ liệu theo thời gian thực.

## ✨ Tính năng nổi bật
* **Xác thực người dùng:** Đăng nhập/Đăng ký tài khoản, Đăng nhập nhanh qua Facebook.
* **Quản lý sản phẩm:** Hiển thị danh sách giày dép, phân loại theo thương hiệu, xem chi tiết (chọn size, màu sắc).
* **Giỏ hàng & Thanh toán:** Thêm/sửa/xóa sản phẩm trong giỏ hàng, tính tổng tiền, đặt hàng.
* **Quản lý trạng thái (State Management):** Tối ưu hóa việc cập nhật giao diện mà không làm giật lag app.
* **Gọi API (Networking):** Tương tác với RESTful API để lấy và gửi dữ liệu.

## 🚀 Công nghệ & Thư viện sử dụng
* **Framework:** Flutter (Dart)
* **Networking:** `http`  (gọi API)
* **Bảo mật:** `flutter_dotenv` (quản lý biến môi trường)
* **Khác:** Thư viện hỗ trợ UI, quản lý state (như Provider, GetX, hoặc Bloc - *bạn đang dùng cái nào thì ghi vào đây nhé*).

## 🛠 Hướng dẫn cài đặt (Local Development)

### 1. Yêu cầu hệ thống
* Đã cài đặt [Flutter SDK](https://docs.flutter.dev/get-started/install).
* Android Studio / VS Code hoặc Xcode (nếu chạy máy ảo iOS).
* Điện thoại thật hoặc Emulator/Simulator.

### 2. Các bước cài đặt
**Bước 1: Clone mã nguồn**
```bash
git clone [https://github.com/ChickenNewbie/CHPS-shop.git](https://github.com/ChickenNewbie/CHPS-shop.git)
cd shoe-shop-app
Bước 2: Cài đặt các thư viện (Packages)

Bash
flutter pub get
Bước 3: Cấu hình biến môi trường (Bắt buộc)

Tạo một file có tên .env ở thư mục gốc của dự án (ngang hàng với pubspec.yaml).

Mở file .env.example, copy nội dung và dán vào file .env vừa tạo.

Điền các Key tương ứng của bạn vào:

Đoạn mã
FACEBOOK_APP_ID=nhap_id_facebook_cua_ban
FACEBOOK_CLIENT_TOKEN=nhap_token_facebook_cua_ban
API_BASE_URL=http://<ip_may_tinh_cua_ban>:3000/api
(Lưu ý: Không bao giờ commit file .env chứa key thật lên GitHub).

Bước 4: Chạy ứng dụng

Bash
flutter run
🔗 Hệ thống Backend API
App CHPS được kết nối với hệ thống Backend Node.js & MySQL do chính mình phát triển để tạo thành một luồng dữ liệu hoàn chỉnh (Fullstack Flow).
👉 Xem chi tiết mã nguồn Backend tại đây: https://github.com/ChickenNewbie/CHPS-Database.git
