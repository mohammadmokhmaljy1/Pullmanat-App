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

---

## 2. استعادة كلمة المرور (Forgot Password)

- **الغرض:** رابط "هل نسيت كلمة المرور؟" في شاشة تسجيل الدخول.
- **الطريقة والمسار المقترح:** `POST /users/forgot-password.php`
- **Request Body:**
  ```json
  {
    "email": "user@example.com"
  }
  ```
- **Response Payload:**
  ```json
  {
    "success": true,
    "message": "تم إرسال رابط إعادة التعيين"
  }
  ```

---

## 3. تسجيل الدخول عبر Google

- **الغرض:** زر "تسجيل دخول باستخدام غوغل" في شاشات Sign in و Sign up.
- **الطريقة والمسار المقترح:** `POST /users/google-auth.php`
- **Request Body:**
  ```json
  {
    "id_token": "GOOGLE_ID_TOKEN"
  }
  ```
- **Response Payload:**
  ```json
  {
    "success": true,
    "user": {
      "user_id": 44,
      "name": "Ahmed Ali",
      "email": "user@gmail.com",
      "phone": 0,
      "image": "profile.png"
    }
  }
  ```

---

## 4. توحيد شكل استجابة Login / Register

- **الغرض:** التطبيق يحتاج استجابة موحّدة تحتوي `user` object بعد نجاح login/register.
- **الطريقة والمسار:** `POST /users/login.php` و `POST /users/create.php`
- **Response Payload المقترح:**
  ```json
  {
    "success": true,
    "message": "تم بنجاح",
    "user": {
      "user_id": 44,
      "name": "Test User",
      "email": "test@example.com",
      "phone": 912345678,
      "image": "profile.png"
    }
  }
  ```
