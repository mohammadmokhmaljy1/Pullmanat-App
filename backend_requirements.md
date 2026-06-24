# Backend Requirements

هذا الملف يوثّق نقاط النهاية (Endpoints) المفقودة أو غير المكتملة في الـ Backend مقارنة بتصاميم Figma.

---

## 1. تسجيل الدخول برقم الهاتف

- **الغرض:** واجهة تسجيل الدخول تسمح بإدخال "رقم الهاتف أو البريد الإلكتروني"، لكن `POST /users/login.php` يوثّق فقط `email` و `password`.
- **الطريقة والمسار المقترح:** `POST /users/login.php` (توسيع الموجود)
- **Request Body:**
  ```json
  {
    "email": "user@example.com",
    "phone": 987654321,
    "password": "password123"
  }
  ```
  (أحد الحقلين: `email` أو `phone`)
- **Response Payload:**
  ```json
  {
    "success": true,
    "user": {
      "user_id": 44,
      "name": "Ahmed Ali",
      "email": "user@example.com",
      "phone": 987654321,
      "image": "profile.png"
    }
  }
  ```

## 2. قائمة نقاط الانطلاق (Departure Points List)

- **الغرض:** شاشة البحث تحتاج جلب نقاط الانطلاق حسب المدينة، لكن Postman يوثّق فقط POST/PUT على `departure_points/`.
- **الطريقة والمسار المقترح:** `GET /departure_points/view.php` أو `GET /departure_points/index.php?city_name=حلب`
- **Response Payload:**
  ```json
  {
    "success": true,
    "data": [
      {
        "station_id": 1,
        "city_name": "Aleppo",
        "station_name": "كراج الراموسة",
        "station_location": "City Center"
      }
    ]
  }
  ```

---

### 3. جلب طلبات مستخدم محدد (للتطبيق)

- **الطريقة والمسار المقترح:** `GET /special_requests/index.php?user_id=44`
- **Request:** `user_id` كـ query parameter (أو JSON body كبديل — كما في `reservations/index.php`)
- **Response Payload:**
  ```json
  {
    "success": true,
    "data": [
      {
        "request_id": 8,
        "departure_point": "Damascus",
        "arrival_point": "Aleppo",
        "date": "2026-06-20",
        "time": "14:30:00",
        "notes": "ملاحظات إضافية",
        "user_id": 44
      }
    ]
  }
  ```

### 6.3 مرجع جدول قاعدة البيانات (`special_requests`)

| العمود | النوع | ملاحظة |
|--------|--------|--------|
| `request_id` | int | المفتاح الأساسي |
| `departure_point` | varchar(255) | مدينة/نقطة الانطلاق |
| `arrival_point` | varchar(255) | مدينة/نقطة الوصول |
| `time` | time | الوقت المفضل |
| `date` | date | التاريخ المفضل |
| `notes` | varchar(255) | ملاحظات إضافية |
| `user_id` | int (nullable) | صاحب الطلب |

### 6.4 ملاحظة للمطورين

- يُفضّل **عدم** استخدام `POST /special_requests/index.php` للقراءة؛ إنشاء مسار GET منفصل (`view.php` للكل، أو GET على `index.php` مع `user_id`) يتماشى مع باقي الـ API (مثل `trips/view.php` و `reservations/view.php`).
- التطبيق حالياً **لا يستدعي** endpoint العرض — هذا الطلب للتطوير المستقبلي في الـ Dashboard وشاشة «طلباتي».
