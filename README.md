# Chủ đề 04: Thiết kế giao diện đa phong cách (Material & Cupertino) và nguyên tắc UX

Ứng dụng **multi_style_ui** là một màn hình demo cho phép đổi phong cách giao diện giữa **Material Design 3** và **Cupertino (iOS)**, đổi màu chủ đạo, chế độ sáng/tối và cỡ chữ ngay khi chạy, kèm một form phản hồi minh họa các nguyên tắc UX. Dự án được làm để minh họa cách xây dựng một **hệ thống thiết kế nhất quán** trong Flutter và cách xử lý ngoại lệ chặt chẽ.


---

## 1. Thông tin nhóm

| STT | Họ và tên | MSSV | Phụ trách |
|---|---|---|---|
| 1 | Phạm Viết Duy | 106230008 | Nền tảng và hệ thống thiết kế (`core/`, `app/`, `main.dart`), xử lý ngoại lệ, soạn slide |
| 2 | Cao Minh Phụng | 106230023 | Tính năng và giao diện (`features/`), kiểm thử, dàn ý slide |

Tỷ lệ đóng góp: 50% – 50%. Hai thành viên review chéo phần của nhau.

Trường Đại học Bách khoa, Khoa Điện tử và Trí tuệ nhân tạo.

## 2. Yêu cầu của đề

**Nội dung:**

- Tổng quan Material Design và Cupertino.
- `Scaffold`, `AppBar`, theme, typography và hệ thống màu.
- Tính nhất quán, phản hồi tương tác, khả năng đọc và khả năng tiếp cận cơ bản.

**Yêu cầu demo:**

- Xây dựng giao diện tuân theo một hệ thống thiết kế nhất quán.
- Giải thích các lựa chọn về thành phần, chủ đề và trải nghiệm người dùng.
- Cấu trúc thư mục chuẩn, clean code, tuân thủ Dart style guide, xử lý ngoại lệ chặt chẽ.

## 3. Tính năng

- Chọn phong cách giao diện: **Material**, **Cupertino** hoặc **Tự động** (theo nền tảng đang chạy).
- Đổi chế độ **Sáng / Tối / Hệ thống**, chọn 1 trong 4 màu chủ đạo, chỉnh cỡ chữ từ 80% đến 160%.
- Xem thang chữ của theme và tỷ lệ tương phản màu theo chuẩn WCAG AA.
- Form phản hồi có kiểm tra dữ liệu từng ô, trạng thái đang gửi, thông báo thành công hoặc lỗi.
- Công tắc **Mô phỏng lỗi mạng** để trình diễn luồng xử lý lỗi.

## 4. Kiến trúc hệ thống thiết kế

```
┌────────────────┐   cài đặt    ┌───────────────────┐   lưu    ┌────────────┐
│  Widget        │ ───────────► │ SettingsController│ ───────► │ Repository │
│  (presentation)│ ◄─────────── │ (ChangeNotifier)  │          │ (guard)    │
└────────────────┘  notify      └───────────────────┘          └────────────┘
        ▲                                │
        │ ListenableBuilder              ▼
        └──────────────── App (MaterialApp) ── AppTheme.build()
```

| Thành phần | Thư mục | Vai trò |
|---|---|---|
| **Domain** | `lib/features/*/domain/` | Lớp dữ liệu thuần: `AppSettings`, `DesignStyle`, `UserFeedback`. Không gọi mạng, không dựng widget. |
| **Data** | `lib/features/*/data/` | `SettingsRepository` (bản `InMemory`), `FeedbackRepository` (bản `Fake`). Giao diện trừu tượng nên dễ thay nguồn dữ liệu. |
| **Presentation** | `lib/features/*/presentation/` | `SettingsController` giữ trạng thái; các widget và trang chỉ hiển thị và gửi lệnh. |
| **Theme** | `lib/core/theme/` | `AppColors`, `AppTypography`, `AppTheme`: nguồn duy nhất của màu, chữ và kiểu thành phần. |
| **Widgets dùng chung** | `lib/core/widgets/` | `AdaptiveScaffold`, `AdaptiveButton`, `AdaptiveSegmentedControl`, `StatusMessage`. |
| **Errors** | `lib/core/errors/` | `AppException` (sealed), `Result`, `ErrorHandler`. |

### Luồng dữ liệu một chiều

1. Người dùng chọn phong cách, màu, chế độ sáng/tối hoặc cỡ chữ → widget gọi `controller.update(settings.copyWith(...))`.
2. `SettingsController` gán trạng thái mới ngay (cập nhật lạc quan) và gọi `notifyListeners()`.
3. Controller gọi `repository.save()` bọc trong `ErrorHandler.guard`.
4. Nếu thành công, trạng thái được giữ nguyên. Nếu `Failure`, controller **hoàn lại giá trị cũ**, lưu `lastError` và gọi `notifyListeners()` lần nữa.
5. `ListenableBuilder` ở gốc ứng dụng dựng lại `MaterialApp` với theme mới; `SettingsPanel` hiện lỗi (nếu có) bằng `StatusMessage`.

Lệnh đi **lên** (widget → controller), trạng thái đi **xuống** (controller → widget). Widget không tự sửa cài đặt.

### Cơ chế chuyển phong cách

```dart
// AppTheme.build(): đặt platform theo phong cách đang chọn
platform: useCupertino ? TargetPlatform.iOS : TargetPlatform.android,

// Widget dùng chung: chọn bản Material hay Cupertino theo context
if (context.isCupertino) {
  return CupertinoButton.filled(onPressed: callback, child: content);
}
return FilledButton(onPressed: callback, child: content);
```

`ThemeData.platform` quyết định luôn `Switch.adaptive`, `Slider.adaptive`, kiểu cuộn và hiệu ứng chuyển trang. `cupertinoOverrideTheme` lấy màu từ cùng `ColorScheme`, nên hai phong cách giữ chung một bản sắc.

### Hệ thống màu, chữ và khoảng cách

- **Màu:** `ColorScheme.fromSeed(seedColor, brightness)` sinh bảng màu sáng và tối từ một màu hạt giống.
- **Chữ:** `AppTypography.textTheme` tinh chỉnh độ đậm và giãn dòng (1.5 cho đoạn văn); kích thước vẫn co giãn theo cỡ chữ hệ thống nhân với cỡ chữ người dùng chọn (giới hạn 0.8 – 2.0).
- **Khoảng cách:** `AppSpacing` (xs, sm, md, lg, bo góc, vùng chạm tối thiểu 48dp).

### Khởi tạo và liên kết phụ thuộc

Trong `main.dart`, các lớp được lắp bằng constructor, không dùng thư viện DI:

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorHandler.registerGlobalHandlers();

  final settingsController = SettingsController(InMemorySettingsRepository());
  final feedbackRepository = FakeFeedbackRepository();

  runApp(App(
    settingsController: settingsController,
    feedbackRepository: feedbackRepository,
  ));
  unawaited(settingsController.load());
}
```

Chỉ `main.dart` biết cả Repository, Controller và giao diện. Widget chỉ biết Controller hoặc Repository qua giao diện trừu tượng.

## 5. Cấu trúc thư mục

```
lib/
├── main.dart
├── app/
│   └── app.dart
├── core/
│   ├── constants/
│   │   └── app_spacing.dart
│   ├── errors/
│   │   ├── app_exception.dart
│   │   ├── error_handler.dart
│   │   └── result.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_theme.dart
│   │   └── app_typography.dart
│   ├── utils/
│   │   ├── contrast.dart
│   │   └── validators.dart
│   └── widgets/
│       ├── adaptive_button.dart
│       ├── adaptive_context.dart
│       ├── adaptive_scaffold.dart
│       ├── adaptive_segmented_control.dart
│       └── status_message.dart
└── features/
    ├── feedback/
    │   ├── data/feedback_repository.dart
    │   ├── domain/user_feedback.dart
    │   └── presentation/feedback_form.dart
    └── showcase/
        ├── data/settings_repository.dart
        ├── domain/app_settings.dart
        └── presentation/
            ├── settings_controller.dart
            ├── showcase_page.dart
            └── widgets/
                ├── settings_panel.dart
                └── typography_preview.dart
test/
├── settings_controller_test.dart
└── validators_test.dart
```

## 6. Phản hồi tương tác của form

| Trạng thái | Điều kiện | Giao diện hiển thị |
|---|---|---|
| **Nhập sai** | Email không hợp lệ hoặc nội dung dưới 10 ký tự | Lỗi hiện ngay dưới từng ô và dòng thông báo "Vui lòng sửa các trường báo lỗi" |
| **Đang gửi** | Đang chờ `repository.submit()` | Nút bị vô hiệu, hiện vòng quay và chữ "Đang gửi..." (tránh bấm hai lần) |
| **Thành công** | `Success` | Thông báo thành công kèm biểu tượng, form được xóa trắng |
| **Lỗi** | `Failure` (ví dụ bật "Mô phỏng lỗi mạng") | Thông báo lỗi kèm biểu tượng, giữ nguyên dữ liệu đã nhập để gửi lại |

`StatusMessage` luôn dùng biểu tượng cùng chữ (không chỉ dựa vào màu) và là live region để trình đọc màn hình đọc thông báo khi nó xuất hiện.

## 7. Chứng minh hệ thống thiết kế nhất quán

1. **Màu chỉ khai báo ở một nơi:** tìm `Color(0x` trong thư mục `lib/` — chỉ có kết quả trong `lib/core/theme/app_colors.dart`, không có trong `lib/features/`.

   ```powershell
   Select-String -Path lib\features\*\*\*.dart,lib\features\*\*\*\*.dart -Pattern "Color\(0x"
   ```

   Trong VS Code: `Ctrl+Shift+F`, tìm `Color(0x`, giới hạn trong `lib/features`.

2. **Kiểu chữ chỉ lấy từ theme:** tìm `TextStyle(` trong `lib/` — kết quả rỗng; mọi kiểu chữ đều lấy từ `Theme.of(context).textTheme` và chỉ chỉnh bằng `copyWith`.

3. **Hai phong cách, một bảng màu:** chuyển giữa Material và Cupertino ở mục 1 của màn hình demo; màu chủ đạo, chế độ sáng/tối và cỡ chữ giữ nguyên, chỉ hình thức của thành phần đổi.

4. **Kiểm tra bằng unit test:** `SettingsController` chạy được với repository giả, không cần giao diện và không cần Internet.

## 8. Unit test

Thư mục: `test/`.

| Test | Trường hợp | Kết quả mong đợi |
|---|---|---|
| `settings_controller_test.dart` | Lưu thành công | Giữ cài đặt mới, `lastError` rỗng |
| `settings_controller_test.dart` | Repository ném `StorageException` | Hoàn lại giá trị cũ, `lastError` là `StorageException` |
| `validators_test.dart` | Email rỗng, sai định dạng, hợp lệ | Trả thông báo lỗi hoặc `null` đúng |
| `validators_test.dart` | Nội dung quá ngắn và đủ dài | Trả thông báo lỗi hoặc `null` đúng |
| `validators_test.dart` | Tỷ lệ tương phản đen trên trắng | 21:1 |

## 9. Hướng dẫn chạy

Yêu cầu: Flutter SDK (Dart `^3.5.0`).

```bash
git clone <đường-dẫn-repo>
cd <thư-mục-dự-án>
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

Nếu thư mục dự án chưa có các thư mục nền tảng (`windows/`, `web/`, `android/`), chạy thêm `flutter create . --project-name multi_style_ui --platforms=windows,web,android`.

Để xem giao diện Cupertino mà không cần máy iOS: chạy trên Chrome hoặc Windows rồi chọn **Cupertino** ở mục 1.

Để thử luồng lỗi: bật công tắc **Mô phỏng lỗi mạng** ở mục 3, nhập đúng email và nội dung rồi bấm **Gửi phản hồi**.

## 10. Công nghệ sử dụng

| Thư viện | Phiên bản | Vai trò |
|---|---|---|
| `flutter` | SDK | Framework giao diện, gồm Material và Cupertino |
| `cupertino_icons` | ^1.0.8 | Biểu tượng kiểu iOS |
| `flutter_test` | SDK | Chạy unit test |
| `flutter_lints` | ^5.0.0 | Quy tắc phân tích tĩnh |

`ChangeNotifier` và `ListenableBuilder` có sẵn trong Flutter nên không cần thư viện quản lý state bên ngoài. `analysis_options.yaml` bật thêm `strict-casts`, `strict-inference`, `strict-raw-types` cùng các luật như `prefer_single_quotes`, `always_use_package_imports`, `require_trailing_commas`, `unawaited_futures`.

## 11. Hạn chế và hướng phát triển

**Hạn chế:**

- Cài đặt chỉ lưu trong bộ nhớ (`InMemorySettingsRepository`), thoát ứng dụng là mất.
- Repository và Controller được tạo thủ công trong `main.dart`, chưa có cơ chế Dependency Injection.
- Ở chế độ Cupertino, trang vẫn dùng một số widget Material (`Card`, `InkWell`) đặt trong một `Material` trong suốt, nên giao diện Cupertino chỉ gần giống iOS thật.
- Chưa cấu hình ngôn ngữ tiếng Việt cho các chuỗi mặc định của Material; test chưa bao phủ widget.

**Hướng phát triển:**

- Lưu cài đặt bền vững bằng `shared_preferences`.
- Thêm đa ngôn ngữ với `flutter_localizations`.
- Viết widget test và kiểm thử với trình đọc màn hình thật (TalkBack, VoiceOver).
- Dùng `Provider` hoặc `Riverpod` để cấp controller cho cây widget.

## 12. Phân công công việc (WBS)

| Vai trò | Người phụ trách | File chính |
|---|---|---|
| Nền tảng, hệ thống thiết kế | Phạm Viết Duy | `main.dart`, `app/app.dart`, `core/theme/`, `core/widgets/`, `core/constants/` |
| Xử lý ngoại lệ, tiện ích | Phạm Viết Duy | `core/errors/`, `core/utils/` |
| Tính năng, giao diện | Cao Minh Phụng | `features/showcase/`, `features/feedback/` |
| Kiểm thử | Cao Minh Phụng | `test/` |
| Báo cáo, slide | Cả hai (Duy soạn slide, Phụng dàn ý) | `README.md`, file slide |
| Tích hợp | Cả hai | `pubspec.yaml`, `analysis_options.yaml`, chạy `flutter analyze` và `flutter test` |

## 13. Tài liệu tham khảo

- Material Design 3 — https://m3.material.io
- Apple, *Human Interface Guidelines* — https://developer.apple.com/design/human-interface-guidelines
- Flutter, *Adaptive and responsive design* — https://docs.flutter.dev/ui/adaptive-responsive
- Flutter, *Accessibility* — https://docs.flutter.dev/ui/accessibility
- Flutter API: `ThemeData`, `ColorScheme.fromSeed`, `ListenableBuilder` — https://api.flutter.dev
- W3C, *WCAG 2.1 – Contrast (Minimum)* — https://www.w3.org/TR/WCAG21/#contrast-minimum
- Dart, *Effective Dart: Style* — https://dart.dev/effective-dart/style
