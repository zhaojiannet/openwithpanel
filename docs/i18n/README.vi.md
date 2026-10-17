<p align="center">
  <img src="../assets/icon.png" width="128" alt="Biểu tượng ứng dụng OpenWithPanel">
</p>

<h1 align="center">OpenWithPanel</h1>

<p align="center">
  <strong>Chọn ứng dụng mở từng loại tệp trên máy Mac — kể cả những tệp mà macOS không cho bạn đặt.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-26%2B-blue" alt="macOS 26 trở lên">
  <img src="https://img.shields.io/badge/Swift-6-orange" alt="Swift 6">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="Giấy phép MIT">
</p>

<p align="center">
  <a href="../../README.md">English</a> ·
  <a href="README.zh-Hans.md">简体中文</a> ·
  <a href="README.zh-Hant.md">繁體中文</a> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.ko.md">한국어</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.fr.md">Français</a> ·
  <a href="README.es.md">Español</a> ·
  <a href="README.pt.md">Português</a> ·
  <a href="README.id.md">Bahasa Indonesia</a> ·
  <a href="README.th.md">ไทย</a> ·
  <b>Tiếng Việt</b> ·
  <a href="README.ar.md">العربية</a> ·
  <a href="README.ru.md">Русский</a> ·
  <a href="README.hi.md">हिन्दी</a>
</p>

OpenWithPanel là ứng dụng macOS miễn phí, mã nguồn mở để quản lý **ứng dụng mặc định**: chọn ứng dụng mở từng loại tệp, từng phần mở rộng tệp và từng loại liên kết, tất cả trong một cửa sổ. OpenWithPanel còn làm được điều mà Finder không làm được: đặt trình soạn thảo của bạn làm ứng dụng mặc định cho **tệp không có phần mở rộng**, như `.env`, `.gitignore`, `Dockerfile` và `.npmrc`.

<p align="center">
  <img src="../assets/screenshot.png" width="720" alt="Cửa sổ chính của OpenWithPanel">
</p>

## Mục lục

- [Vì sao cần OpenWithPanel](#vì-sao-cần-openwithpanel)
- [Tính năng](#tính-năng)
- [Tải về và cài đặt](#tải-về-và-cài-đặt)
- [Cách dùng](#cách-dùng)
- [Chẩn đoán](#chẩn-đoán)
- [Cài đặt](#cài-đặt)
- [Chế độ nhà phát triển](#chế-độ-nhà-phát-triển)
- [Cách hoạt động](#cách-hoạt-động)
- [Câu hỏi thường gặp](#câu-hỏi-thường-gặp)
- [Hạn chế đã biết](#hạn-chế-đã-biết)
- [Biên dịch từ mã nguồn](#biên-dịch-từ-mã-nguồn)

## Vì sao cần OpenWithPanel

macOS xếp hầu hết các tệp không có phần mở rộng vào loại `public.data`, và không cho phép bất kỳ ứng dụng nào trở thành mặc định cho loại này. **Lấy thông tin › Mở bằng › Thay đổi tất cả…** của Finder không có tác dụng với các tệp này, còn các công cụ dòng lệnh thì báo lỗi `-50`. **Luôn mở bằng** của Finder chỉ áp dụng cho đúng một tệp bạn đã chọn.

Vì vậy `.env`, `.gitignore`, `Dockerfile` và các tệp tương tự vẫn cứ mở bằng TextEdit — hoặc không mở được — dù bạn đặt thế nào. OpenWithPanel khắc phục điều này bằng một ứng dụng trợ giúp nhỏ tên là OpenWithPanel Helper, được mô tả trong [Cách hoạt động](#cách-hoạt-động).

OpenWithPanel cũng bù đắp những chỗ khác mà macOS bỏ sót: khi một ứng dụng mới cài (thường là Xcode) chiếm lấy các liên kết tệp của bạn, macOS không báo cho bạn biết, và cũng không có nút nào để đưa mọi thứ về như cũ.

## Tính năng

- **Ứng dụng mặc định theo nhóm.** Các loại tệp được nhóm theo mục đích — Văn bản, Markdown, Mã nguồn, Cấu hình & Dữ liệu, Tệp không có phần mở rộng, PDF, Tài liệu, Hình ảnh, Video, Âm thanh, Tệp nén — và mỗi nhóm có một menu chọn ứng dụng.
- **Áp dụng một lần.** Đặt cả một nhóm định dạng cùng lúc mà không phải xác nhận từng định dạng; thay đổi có hiệu lực sau vài giây.
- **Ngoại lệ cho từng định dạng.** Mở rộng một nhóm để gán ứng dụng riêng cho một định dạng, như `.md` hoặc `.py`. Đổi ứng dụng của nhóm sau đó sẽ không ảnh hưởng đến các ngoại lệ.
- **Tệp không có phần mở rộng.** Mở `.env`, `Dockerfile`, `.gitignore` và các tệp không có phần mở rộng khác bằng trình soạn thảo bạn chọn, kể cả khi trình soạn thảo đó không khai báo hỗ trợ chúng.
- **Phần mở rộng tùy chỉnh.** Thêm bất kỳ phần mở rộng nào chưa có trong danh sách, kể cả những phần mở rộng mà macOS chỉ biết dưới dạng loại tạm thời, như `.go`, `.rs`, `.kt`, `.dart` và `.lua`.
- **Ứng dụng mặc định cho liên kết.** Chọn ứng dụng cho liên kết web (`http`, `https`), email (`mailto`), đăng ký lịch (`webcal`), cuộc gọi, tin nhắn văn bản, FaceTime, SSH, FTP và chia sẻ màn hình — hoặc chọn **Không mở** để việc bấm vào loại liên kết đó không làm gì cả.
- **Tìm theo phần mở rộng.** Gõ `py` hoặc `env` để nhảy thẳng đến đúng hàng.
- **Chẩn đoán bất kỳ tệp nào.** Thả một tệp vào để xem vì sao nó mở bằng một ứng dụng nhất định, rồi chọn ứng dụng khác ngay tại đó. Thả một thư mục vào để tìm các tệp có cài đặt **Mở bằng** riêng và xóa chúng.
- **Cảnh báo bị chiếm quyền.** Nếu một ứng dụng khác (Xcode, một trình duyệt) chiếm lấy liên kết bạn đã đặt, OpenWithPanel hiện một biểu ngữ để sửa chỉ bằng một cú bấm.
- **Hoàn tác và khôi phục.** Một ảnh chụp được lưu trước mỗi thay đổi. Hoàn tác bằng `⌘Z`, khôi phục bất kỳ ảnh chụp nào trước đó, hoặc đưa mọi thứ về như trước khi OpenWithPanel thay đổi bất cứ điều gì, kèm bản xem trước từng thay đổi.
- **Quy tắc thư mục.** Một phương án dự phòng tùy chọn: đặt các tệp không có phần mở rộng trong những thư mục bạn chọn, như `~/Projects`, mở bằng trình soạn thảo của bạn, chỉ dùng API chính thức của macOS.
- **Chế độ nhà phát triển.** Quy tắc định tuyến tệp theo mẫu tên (ví dụ `Dockerfile*`), theo thư mục hoặc theo nội dung văn bản hay nhị phân; toàn bộ chuỗi quyết định trong phần chẩn đoán, gồm các loại mà mỗi ứng dụng khai báo và thứ hạng của chúng; nhập và xuất cài đặt sẵn.
- **Gỡ cài đặt sạch sẽ.** Trình gỡ cài đặt tích hợp trả mọi liên kết về ứng dụng ban đầu trước khi chuyển OpenWithPanel vào Thùng rác.
- **15 ngôn ngữ.** Tiếng Anh, tiếng Trung giản thể, tiếng Trung phồn thể, tiếng Nhật, tiếng Hàn, tiếng Đức, tiếng Pháp, tiếng Tây Ban Nha, tiếng Bồ Đào Nha, tiếng Indonesia, tiếng Thái, tiếng Việt, tiếng Ả Rập, tiếng Nga và tiếng Hindi, có thể chuyển ngay trong ứng dụng.

## Tải về và cài đặt

Yêu cầu macOS 26 Tahoe trở lên.

1. Mở [trang Releases](https://github.com/zhaojiannet/openwithpanel/releases) và tải `OpenWithPanel-<version>.dmg` trong mục **Assets** của bản phát hành mới nhất.
2. Bấm đúp vào tệp DMG vừa tải để mở.
3. Kéo **OpenWithPanel** vào thư mục **Ứng dụng** hiển thị trong cùng cửa sổ.
4. Đẩy DMG ra, rồi mở OpenWithPanel từ thư mục Ứng dụng. Lần đầu, macOS sẽ yêu cầu bạn cho phép; xem [Lần mở đầu tiên](#lần-mở-đầu-tiên).

Không có trình cài đặt và không cần mật khẩu quản trị viên.

**Cập nhật:** tải DMG mới và kéo OpenWithPanel vào thư mục Ứng dụng lần nữa, thay thế bản cũ. Cài đặt, quy tắc và ảnh chụp của bạn được giữ nguyên. Để xem đã có phiên bản mới hơn chưa, hãy chọn **OpenWithPanel › Kiểm tra bản cập nhật…**.

**Gỡ cài đặt:** xem [Gỡ cài đặt](#gỡ-cài-đặt).

### Lần mở đầu tiên

OpenWithPanel chưa được Apple công chứng, nên macOS chặn ứng dụng trong lần mở đầu tiên. Hãy cho phép một lần:

1. Bấm đúp vào OpenWithPanel. Khi macOS báo không thể xác minh OpenWithPanel, bấm **Xong**. Đừng bấm nút **Chuyển vào Thùng rác** màu xanh.

   <img src="../assets/first-launch-1.png" width="372" alt="Cảnh báo đầu tiên: bấm Xong">

2. Mở **Cài đặt hệ thống › Quyền riêng tư & Bảo mật**, cuộn xuống phần **Bảo mật** và bấm **Vẫn mở** bên cạnh OpenWithPanel. Nút này xuất hiện trong khoảng một giờ sau bước 1.

   <img src="../assets/first-launch-2.png" width="560" alt="Quyền riêng tư & Bảo mật: bấm Vẫn mở">

3. Nhập mật khẩu đăng nhập hoặc dùng Touch ID. Trong hộp thoại tiếp theo, bấm **Vẫn mở** lần nữa.

   <img src="../assets/first-launch-3.png" width="372" alt="Xác nhận: bấm Vẫn mở">

Sau đó, OpenWithPanel mở bình thường. Trình trợ giúp tích hợp cũng được cho phép cùng lúc, nên tệp không có phần mở rộng sẽ mở mà không hỏi thêm. DMG cũng có các bước này trong tệp `First Launch.txt`. Ảnh chụp màn hình hiển thị giao diện tiếng Anh; trên macOS tiếng Việt, các nút có tên như đã ghi ở trên.

## Cách dùng

### Nhóm loại tệp

Tab **Loại tệp** liệt kê mỗi nhóm thành một thẻ:

| Nhóm | Bao gồm |
|---|---|
| Văn bản | `.txt` `.log` |
| Markdown | `.md` `.markdown` |
| Mã nguồn | Các ngôn ngữ lập trình phổ biến, xem bên dưới |
| Cấu hình & Dữ liệu | `.json` `.yaml` `.toml` `.xml` `.ini` `.plist` `.csv` |
| Tệp không có phần mở rộng | `.env` `Dockerfile` `.gitignore` và các tệp tương tự |
| PDF | `.pdf` |
| Tài liệu | `.rtf` `.docx` `.doc` `.pages` `.odt` |
| Hình ảnh, Video, Âm thanh, Tệp nén | Các định dạng thông dụng của chúng |
| Tùy chỉnh | Các phần mở rộng bạn đã thêm mà không thuộc nhóm nào khác; chỉ hiện khi có |

Nhóm Mã nguồn bao gồm các ngôn ngữ được ít nhất 5% người tham gia Khảo sát nhà phát triển Stack Overflow 2025 sử dụng: JavaScript, TypeScript (`.tsx`), Python, Java, C, C++, C#, PHP, Ruby, Swift, Go, Rust, Kotlin, Dart, Lua, Shell (sh, bash, zsh), PowerShell, SQL và hợp ngữ, cùng với CSS, Makefile và JSX. Bạn có thể tự thêm ngôn ngữ khác, xem [Thêm phần mở rộng](#thêm-phần-mở-rộng).

### Đặt ứng dụng cho cả một nhóm

Chọn một ứng dụng từ menu bên phải thẻ. Mọi định dạng trong nhóm sẽ mở bằng ứng dụng đó. Menu liệt kê các ứng dụng mà macOS cho là mở được nhóm này; chọn **Khác…** để chọn bất kỳ ứng dụng nào trong thư mục Ứng dụng.

### Gán ứng dụng riêng cho một định dạng

Bấm vào hàng của nhóm, hoặc mũi tên bên trái nó, để mở rộng. Mỗi định dạng có một hàng riêng, với biểu tượng hệ thống của loại tệp đó và tiêu đề là phần mở rộng. Chọn ứng dụng khác trong menu của một hàng, và từ đó định dạng ấy dùng ứng dụng này; hàng được đánh dấu **Đặt riêng**, còn hàng của nhóm cho biết có bao nhiêu định dạng được đặt riêng.

- Định dạng không có ứng dụng riêng hiện chữ **Giống nhóm** màu xám trong menu.
- Để định dạng theo nhóm trở lại, chọn **Theo nhóm** trong menu của nó.
- Đổi ứng dụng của nhóm sau đó không ảnh hưởng đến các định dạng có ứng dụng riêng.

Nhóm có hơn 8 định dạng chỉ hiện những định dạng bạn đặt riêng hoặc tự thêm; **Hiện tất cả N định dạng** ở cuối sẽ liệt kê phần còn lại. Khi nhóm Mã nguồn hiện tất cả, nó được chia thành các phần như Web, Hệ thống & Ứng dụng, JVM và Script & Shell.

### Tìm kiếm

Gõ một phần mở rộng, như `py` hoặc `env`, vào ô tìm kiếm ở góc trên bên phải. Nhóm khớp sẽ mở rộng với tất cả định dạng của nó và hàng khớp được làm nổi bật. Nếu phần mở rộng không thuộc nhóm nào, kết quả tìm kiếm sẽ đưa ra **Thêm…**.

### Thêm phần mở rộng

Dùng **Thêm phần mở rộng…** ở cuối danh sách, hoặc **Thêm…** trong kết quả tìm kiếm.

1. Gõ phần mở rộng, như `nim`. Bảng sẽ cho biết macOS nhận diện nó là gì.
2. Dựa vào đó, OpenWithPanel đề xuất một nhóm: mã nguồn vào Mã nguồn, hình ảnh vào Hình ảnh, những gì không nhận diện được vào Tùy chỉnh. Bạn có thể chọn nhóm khác.
3. Bấm **Thêm**. Định dạng xuất hiện trong nhóm đó, được đánh dấu **Tùy chỉnh**, và theo ứng dụng của nhóm; bạn cũng có thể gán ứng dụng riêng cho nó.

Phần mở rộng đã có trong một nhóm sẽ không được thêm lần hai; bảng sẽ cho biết nó nằm trong nhóm nào. Các định dạng bạn đã thêm có nút xóa trên hàng của chúng.

### Áp dụng

Mọi thay đổi ở trên đều được tạm giữ trước. Một thanh ở cuối cửa sổ cho biết có bao nhiêu thay đổi đang chờ; **Áp dụng** làm chúng có hiệu lực, còn **Bỏ** hủy chúng.

- Thay đổi loại tệp không yêu cầu xác nhận. Dù bạn đổi bao nhiêu định dạng, OpenWithPanel ghi tất cả vào tùy chọn hệ thống cùng một lúc và cho hệ thống nạp lại đúng một lần; mọi thứ có hiệu lực sau vài giây.
- Thay đổi liên kết và tệp web (`.html`) vẫn yêu cầu bạn xác nhận trong hộp thoại hệ thống, ví dụ khi bạn đổi trình duyệt web. Lặng lẽ đổi trình duyệt là việc mà phần mềm chiếm quyền trình duyệt hay làm, nên macOS cần hỏi trực tiếp bạn.
- Nếu việc ghi thất bại (ví dụ do quyền truy cập), hoặc một định dạng không có hiệu lực, OpenWithPanel đặt lại nó qua API hệ thống, từng cái một; khi đó macOS hỏi bạn muốn dùng ứng dụng mới hay giữ ứng dụng cũ. Nếu bạn giữ ứng dụng cũ, OpenWithPanel ghi nhận định dạng đó là đặt riêng cho ứng dụng ấy và từ đó không động đến nó nữa.
- Sau khi áp dụng, OpenWithPanel đọc lại trạng thái thực của hệ thống, nên danh sách luôn hiển thị những gì thực sự có hiệu lực.

### Hoàn tác và khôi phục

- **Sửa › Hoàn tác** (`⌘Z`) hoàn tác lần áp dụng gần nhất. Bạn có thể hoàn tác nhiều lần liên tiếp.
- Nút mũi tên vòng trên thanh công cụ là **Khôi phục ban đầu**: mọi loại tệp và liên kết mà OpenWithPanel đã thay đổi sẽ trỏ về ứng dụng mà chúng dùng khi bạn mở OpenWithPanel lần đầu. Mỗi thay đổi được liệt kê trước khi bất cứ điều gì xảy ra.

macOS không có cách nào xóa một liên kết tệp, chỉ có thể trỏ nó sang ứng dụng khác, nên khôi phục nghĩa là trỏ từng loại về ứng dụng được ghi trong ảnh chụp. Một loại trước đây do macOS tự chọn ứng dụng sẽ có một cài đặt tường minh cho chính ứng dụng đó; nó mở y như trước.

### Liên kết

Bên dưới các loại tệp, một thẻ đặt ứng dụng cho từng loại liên kết:

| Hàng | Lược đồ URL |
|---|---|
| Trình duyệt web | `http:` `https:` |
| Email | `mailto:` |
| Đăng ký lịch | `webcal:` |
| Cuộc gọi, Tin nhắn văn bản, FaceTime | `tel:` `sms:` `facetime:` |
| SSH, FTP, Chia sẻ màn hình | `ssh:` `ftp:` `vnc:` |

Mọi loại liên kết mà một ứng dụng nào đó trên máy Mac của bạn xử lý được đều được liệt kê. Ở cuối mỗi menu là **Không mở**: chọn nó và việc bấm vào loại liên kết đó trong bất kỳ ứng dụng nào sẽ không làm gì cả — ví dụ để một số điện thoại trên trang web không khởi động cuộc gọi. Để hoàn tác, hãy chọn lại một ứng dụng trong menu. Chọn **Không mở** cho trình duyệt web sẽ yêu cầu xác nhận trước, vì khi đó không liên kết web nào mở được. Bạn cũng có thể tìm theo lược đồ (như `mailto`) hoặc theo tên hàng.

Liên kết được tạm giữ, áp dụng, chụp ảnh, hoàn tác và khôi phục giống hệt loại tệp. Đổi trình duyệt web sẽ yêu cầu xác nhận trong hộp thoại hệ thống; trên macOS 27, đổi `http` cũng đổi luôn `https`, và khi đó OpenWithPanel bỏ qua việc đặt lại `https`, nên bạn chỉ xác nhận một lần.

## Chẩn đoán

Chuyển sang tab **Chẩn đoán** ở đầu cửa sổ.

**Vì sao một tệp mở bằng ứng dụng này?** Thả một tệp vào ô viền nét đứt. Kết quả cho biết ứng dụng nào mở nó và vì sao:

- tệp có cài đặt **Mở bằng** riêng, được đặt trong **Lấy thông tin** của Finder;
- OpenWithPanel Helper đã nhận tệp và một quy tắc hoặc cài đặt nhóm đã gửi nó đến một ứng dụng;
- bạn đã chọn ứng dụng này cho loại tệp này;
- không có gì được đặt, nên macOS tự chọn ứng dụng.

Bên dưới kết quả, **Dùng thay thế** chuyển thẳng sang ứng dụng khác. Nếu tệp có cài đặt **Mở bằng** riêng, nút **Xóa cài đặt riêng của tệp này** sẽ xuất hiện thay vào đó.

**Tìm các tệp có cài đặt "Mở bằng" riêng.** Thả một thư mục vào ô viền nét đứt. OpenWithPanel liệt kê mọi tệp trong đó có cài đặt **Mở bằng** riêng, kèm ứng dụng mà nó trỏ tới. Chọn các tệp và bấm **Xóa cài đặt riêng của chúng**; sau đó chúng theo cài đặt của loại tương ứng. Quá trình quét bỏ qua các thư mục `.git`, `node_modules`, `.build`, `DerivedData`, `Pods`, `vendor`, `.venv` và `__pycache__`.

**Xuất báo cáo chẩn đoán.** **Xuất báo cáo chẩn đoán…** ở cuối tab lưu một báo cáo văn bản gồm cấu hình của bạn, ứng dụng hiện đang mở từng loại mà OpenWithPanel quản lý, nhật ký của phiên này và tệp bạn vừa chẩn đoán. Gửi nó cho nhà phát triển khi báo lỗi.

## Cài đặt

Mở **OpenWithPanel › Cài đặt…** hoặc nhấn `⌘,`.

**Chung**

- **Ngôn ngữ:** chọn **Theo hệ thống** hoặc một trong 15 ngôn ngữ, rồi bấm **Mở lại ngay**. Nếu còn thay đổi chưa áp dụng, hãy áp dụng hoặc bỏ chúng trước.
- **Chế độ nhà phát triển:** hiển thị thêm chi tiết, xem [Chế độ nhà phát triển](#chế-độ-nhà-phát-triển). Chế độ này chỉ thay đổi những gì được hiển thị, không bao giờ thay đổi cài đặt của bạn.

**Quy tắc thư mục**

Phương án dự phòng cho trường hợp cách xử lý tệp không có phần mở rộng ngừng hoạt động. Thêm một thư mục và chọn một ứng dụng, OpenWithPanel sẽ gán cho mọi tệp văn bản không có phần mở rộng trong thư mục đó một cài đặt **Mở bằng** riêng trỏ tới ứng dụng ấy.

- Tệp nhị phân và các tệp bạn tự đặt sẽ không bị động đến.
- Tệp mới được xử lý mỗi lần bạn mở OpenWithPanel, hoặc ngay lập tức bằng **Áp dụng ngay**.
- **Hoàn tác mọi cài đặt thư mục** đưa mọi tệp mà OpenWithPanel đã thay đổi về như cũ.
- **Bỏ qua thư mục có tên** có thể chỉnh sửa; mặc định nó liệt kê các thư mục mà quá trình quét thư mục trong Chẩn đoán bỏ qua.

**Lịch sử**

Liệt kê ảnh chụp được lưu trước mỗi lần áp dụng, tối đa 20, mới nhất ở trên. Mục cuối cùng, **Ban đầu (trước khi OpenWithPanel thay đổi bất cứ điều gì)**, là trạng thái được ghi lại lần đầu bạn mở OpenWithPanel. Có thể khôi phục bất kỳ mục nào bằng **Khôi phục…**, kèm bản xem trước các khác biệt.

**Những gì OpenWithPanel đã ghi**

Liệt kê mọi nơi OpenWithPanel thay đổi hoặc ghi trên máy Mac của bạn, mỗi nơi có nút **Hiển thị trong Finder**:

- **Liên kết tệp:** số mục (loại tệp và liên kết) mà OpenWithPanel quản lý;
- **Mục tùy chọn LaunchServices:** các mục OpenWithPanel đã ghi cho loại tệp, kể cả tệp không có phần mở rộng;
- **OpenWithPanel Helper:** nằm bên trong ứng dụng OpenWithPanel;
- **Quy tắc và ảnh chụp:** `~/Library/Application Support/net.zhaojian.openwithpanel/`;
- **Cài đặt “Mở bằng” cho từng tệp:** chỉ có nếu bạn đã dùng quy tắc thư mục.

OpenWithPanel không chạy nền, không có mục đăng nhập và không thu thập dữ liệu. Ứng dụng chỉ kết nối Internet khi bạn chọn **Kiểm tra bản cập nhật…**, để đọc số phiên bản mới nhất từ GitHub.

### Gỡ cài đặt

Ở cuối **Những gì OpenWithPanel đã ghi**, bấm **Gỡ cài đặt OpenWithPanel…** và chọn có xóa luôn quy tắc và ảnh chụp hay không. Sau đó OpenWithPanel sẽ:

1. trỏ mọi loại tệp và liên kết mà nó đã thay đổi về ứng dụng ban đầu;
2. hoàn tác mọi cài đặt cho từng tệp do quy tắc thư mục tạo ra;
3. xóa hoặc giữ `~/Library/Application Support/net.zhaojian.openwithpanel/` theo lựa chọn của bạn;
4. tự chuyển vào Thùng rác.

Nếu có loại tệp hoặc liên kết nào không trỏ về được — ví dụ vì bạn đã từ chối một yêu cầu xác nhận của hệ thống — quá trình gỡ cài đặt sẽ dừng lại và không có gì bị xóa.

Nếu bạn giữ lại quy tắc và ảnh chụp, khi cài lại OpenWithPanel sẽ hiện một biểu ngữ để khôi phục mọi cài đặt của bạn chỉ bằng một cú bấm. Các công cụ dọn dẹp ứng dụng, vốn xóa các tệp còn sót lại của một ứng dụng khi nó bị chuyển vào Thùng rác, cũng có thể xóa quy tắc và ảnh chụp mà bạn đã chọn giữ lại; hãy đặt công cụ đó bỏ qua OpenWithPanel.

Nếu bạn tự kéo OpenWithPanel vào Thùng rác, OpenWithPanel Helper cũng đi theo và macOS bỏ các liên kết trỏ tới nó; các loại khác vẫn giữ ứng dụng mà OpenWithPanel đã đặt. Tệp `UNINSTALL.txt` trong thư mục Application Support giải thích cách khôi phục chúng trong trường hợp đó.

## Chế độ nhà phát triển

Bật trong **Cài đặt › Chung**. Chế độ này thêm:

- mã định danh loại của hệ thống (UTI) bên dưới mỗi định dạng, và nhãn **Trình trợ giúp** trên các định dạng được định tuyến qua OpenWithPanel Helper;
- toàn bộ chuỗi quyết định trong phần chẩn đoán: loại, các loại cha, văn bản hay nhị phân, quyết định, và cách mỗi ứng dụng mở được tệp khai báo nó trong Info.plist (phần mở rộng hoặc loại khớp, vai trò và thứ hạng);
- tab **Quy tắc** trong cửa sổ chính;
- cách xử lý **Tệp không phải văn bản** và **Cài đặt sẵn** trong Cài đặt.

**Quy tắc** quyết định OpenWithPanel Helper gửi các tệp nó nhận được đến đâu. Một quy tắc gồm:

- điều kiện, phải điền ít nhất một: mẫu tên tệp (như `Dockerfile*`, không phân biệt hoa thường), thư mục chứa (như `~/Projects`), và nội dung là văn bản hay nhị phân;
- các loại mà quy tắc áp dụng, mặc định là `public.data` (tệp không có phần mở rộng); các loại khác bạn thêm cũng được định tuyến qua OpenWithPanel Helper;
- nơi gửi tệp: một ứng dụng, **Hiển thị trong Finder**, hoặc **Ứng dụng ban đầu**.

Quy tắc được kiểm tra từ trên xuống dưới và quy tắc khớp đầu tiên được áp dụng. Kéo để sắp xếp lại; công tắc bên trái tạm thời tắt một quy tắc. Các nhóm bị quy tắc chi phối hiển thị **Do quy tắc điều khiển** trong chế độ tiêu chuẩn.

**Tệp không phải văn bản** đặt việc OpenWithPanel Helper làm gì với tệp nhị phân: **Hiển thị trong Finder** (mặc định), **Mở bằng cùng ứng dụng**, hoặc **Mở bằng ứng dụng ban đầu**.

**Cài đặt sẵn** xuất cài đặt nhóm, cài đặt cho từng định dạng, phần mở rộng tùy chỉnh và quy tắc của bạn ra một tệp JSON mà bạn có thể nhập trên máy Mac khác; cài đặt được nhập có hiệu lực sau khi bạn bấm **Áp dụng**. Quy tắc thư mục và bản ghi ứng dụng ban đầu là riêng cho từng máy Mac, nên chúng không được xuất ra và cũng không bị ghi đè khi nhập.

## Cách hoạt động

OpenWithPanel kèm theo một ứng dụng trợ giúp rất nhỏ, **OpenWithPanel Helper**, bên trong gói ứng dụng của nó. Khi bạn chọn một trình soạn thảo cho tệp không có phần mở rộng, OpenWithPanel trỏ `public.data` tới trình trợ giúp. Khi bạn mở một tệp như vậy, trình trợ giúp kiểm tra quy tắc của bạn và nội dung tệp, chuyển tệp văn bản cho ứng dụng bạn đã chọn, hiển thị tệp nhị phân trong Finder, rồi thoát. Nó không chạy thường trực: macOS chỉ khởi động nó khi có tệp hoặc liên kết cần chuyển, và nó thoát sau chưa đầy một giây rảnh. Nó không có cửa sổ và không xuất hiện trên Dock. Liên kết được đặt **Không mở** cũng được gửi đến trình trợ giúp, và nó chỉ đơn giản bỏ qua chúng.

Một tệp được coi là nhị phân nếu 8 KB đầu tiên của nó chứa byte null hoặc không phải UTF-8 hợp lệ.

Các loại tệp mà ứng dụng bạn chọn đã hỗ trợ sẵn, như `.md` hoặc `.py`, được gán trực tiếp cho ứng dụng đó, không qua trình trợ giúp.

macOS không cung cấp API công khai để đặt ứng dụng mặc định cho `public.data`, và từ macOS 26.4, API công khai của nó yêu cầu xác nhận cho từng loại tệp bạn thay đổi. Vì vậy OpenWithPanel ghi tất cả thay đổi loại tệp vào tùy chọn của LaunchServices cùng một lúc và khởi động lại dịch vụ `lsd` một lần để chúng có hiệu lực. Cơ chế này không được Apple ghi trong tài liệu và có thể ngừng hoạt động sau một bản cập nhật hệ thống. Nếu một thay đổi không có hiệu lực, OpenWithPanel chuyển sang API công khai, vốn yêu cầu bạn xác nhận; với tệp không có phần mở rộng, OpenWithPanel đề xuất quy tắc thư mục thay thế.

## Câu hỏi thường gặp

**Làm sao đổi ứng dụng mặc định cho tệp không có phần mở rộng trên máy Mac?**
Mở OpenWithPanel, chọn một ứng dụng cho **Tệp không có phần mở rộng**, rồi nhấn **Áp dụng**. Các tệp như `.env` và `Dockerfile` khi đó sẽ mở bằng ứng dụng ấy.

**Vì sao "Thay đổi tất cả" của Finder không có tác dụng với tệp `.env`?**
macOS coi chúng là dữ liệu chung (`public.data`) và chặn việc đổi ứng dụng mặc định cho loại này qua các API công khai. OpenWithPanel vượt qua giới hạn này bằng ứng dụng trợ giúp của mình.

**Làm sao đặt VS Code, Zed hoặc Sublime Text làm trình soạn thảo mặc định cho tệp mã nguồn?**
Chọn trình soạn thảo cho nhóm **Mã nguồn**, hoặc cho từng định dạng, rồi nhấn **Áp dụng**. Các phần mở rộng không có loại chính thức trên macOS, như `.go` và `.rs`, cũng được hỗ trợ.

**Tôi có thể hoàn tác mọi thứ không?**
Có. OpenWithPanel ghi lại các liên kết ban đầu ngay lần chạy đầu tiên và không bao giờ ghi đè bản ghi đó. **Khôi phục ban đầu** trỏ mọi loại đã thay đổi về ứng dụng ban đầu của nó.

**OpenWithPanel có thu thập dữ liệu hoặc chạy nền không?**
Không. Ứng dụng không thu thập dữ liệu, chỉ kết nối Internet khi bạn chọn **Kiểm tra bản cập nhật…**, không cài tác tử nền và không tiếp tục chạy sau khi bạn thoát. **Cài đặt › Những gì OpenWithPanel đã ghi** liệt kê mọi nơi nó ghi vào.

**Vì sao OpenWithPanel không chạy trong sandbox?**
macOS không cho phép ứng dụng chạy trong sandbox thay đổi ứng dụng mặc định. Thay vào đó, OpenWithPanel dùng hardened runtime.

## Hạn chế đã biết

- Trên macOS, `.ts` được nhận diện là định dạng video (MPEG-2 transport stream), và đổi nó sẽ ảnh hưởng đến các tệp video thật, nên nhóm Mã nguồn chỉ bao gồm `.tsx` của TypeScript. Tương tự, với macOS thì `.r`, `.exs` và `.fs` là tài nguyên Rez, tệp sampler của Logic và shader, nên chúng không có trong nhóm Mã nguồn.
- Cài đặt loại tệp dựa vào một cơ chế hệ thống không có tài liệu, có thể ngừng hoạt động sau một bản cập nhật hệ thống. Khi đó, các loại tệp thông thường tự động chuyển sang API hệ thống (mỗi loại xác nhận một lần), còn tệp không có phần mở rộng có thể dùng quy tắc thư mục thay thế.
- macOS chỉ cho phép một ứng dụng đọc nhật ký của chính tiến trình của nó, nên báo cáo chẩn đoán không bao gồm nhật ký của OpenWithPanel Helper. Nếu cần, hãy tìm `net.zhaojian.openwithpanel` trong ứng dụng Bảng điều khiển.
- Bản dịch giao diện chưa được người bản ngữ xem lại.

## Biên dịch từ mã nguồn

Yêu cầu Xcode 27.

```sh
swift test --package-path OpenWithPanelKit
xcodebuild -project OpenWithPanel.xcodeproj -scheme OpenWithPanel build
```

Để tạo DMG:

```sh
scripts/package.sh
```

Kết quả được đặt trong `.build/dist/`, kèm một Homebrew cask tạo từ `packaging/openwithpanel.rb` với phiên bản và checksum đã được điền. Nếu không đặt biến môi trường, ứng dụng được ký ad hoc và không được công chứng; khi đó DMG kèm theo `First Launch.txt`. Đặt `DEVELOPER_ID` (tên chứng chỉ Developer ID Application) để ký bằng chứng chỉ đó, và đặt thêm `NOTARY_PROFILE` (hồ sơ thông tin xác thực được lưu bằng `xcrun notarytool store-credentials`) để công chứng và staple.

Các bản phát hành được tạo bởi workflow GitHub Actions trong `.github/workflows/release.yml`. Cách ký và cách phát hành một bản được mô tả trong [docs/release.md](../release.md).

## Cấu trúc dự án

- `OpenWithPanelKit/`: gói Swift cục bộ. `OpenWithPanelCore` chứa toàn bộ logic; `OpenWithPanelPlatform` bao bọc các API hệ thống.
- `Apps/OpenWithPanel/`: ứng dụng chính (SwiftUI).
- `Apps/Helper/`: trình trợ giúp được nhúng trong gói ứng dụng chính.
- `scripts/`, `packaging/`: script đóng gói và mẫu Homebrew cask.

## Giấy phép

[MIT](../../LICENSE) © 2026 zhaoJian
