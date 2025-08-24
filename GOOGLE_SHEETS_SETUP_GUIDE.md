# 🔧 دليل إعداد Google Sheets مع تطبيق تسجيل السيارات

## 📋 نظرة عامة

هذا الدليل سيوضح لك كيفية ربط تطبيق Flutter مع Google Sheets خطوة بخطوة، لإنشاء قاعدة بيانات سحابية لتخزين أرقام السيارات.

## 🎯 ما سنقوم به

1. إنشاء مشروع Google Cloud
2. تفعيل Google Sheets API
3. إنشاء حساب خدمة (Service Account)
4. إنشاء جدول بيانات
5. مشاركة الجدول مع حساب الخدمة
6. ربط التطبيق مع Google Sheets

---

## 🚀 الخطوة 1: إنشاء مشروع Google Cloud

### 1.1 الذهاب إلى Google Cloud Console

- افتح المتصفح واذهب إلى: [https://console.cloud.google.com/](https://console.cloud.google.com/)
- سجل دخول بحساب Google الخاص بك

### 1.2 إنشاء مشروع جديد

- اضغط على اسم المشروع الحالي في أعلى الصفحة
- اضغط "New Project" (مشروع جديد)
- أدخل اسم المشروع: `Car Numbers App`
- اضغط "Create" (إنشاء)

### 1.3 اختيار المشروع

- انتظر حتى يتم إنشاء المشروع
- تأكد من أن المشروع الجديد محدد

---

## ⚙️ الخطوة 2: تفعيل Google Sheets API

### 2.1 الذهاب إلى APIs & Services

- من القائمة الجانبية، اضغط "APIs & Services"
- ثم اضغط "Library" (المكتبة)

### 2.2 البحث عن Google Sheets API

- اكتب في مربع البحث: `Google Sheets API`
- اضغط على "Google Sheets API" من النتائج

### 2.3 تفعيل API

- اضغط "Enable" (تفعيل)
- انتظر حتى يتم التفعيل
- ستظهر رسالة "API enabled" (تم تفعيل API)

---

## 🔑 الخطوة 3: إنشاء حساب خدمة (Service Account)

### 3.1 الذهاب إلى Credentials

- من القائمة الجانبية، اضغط "APIs & Services"
- ثم اضغط "Credentials" (الاعتماديات)

### 3.2 إنشاء حساب خدمة

- اضغط "Create Credentials" (إنشاء اعتماديات)
- اختر "Service Account" (حساب خدمة)

### 3.3 ملء بيانات حساب الخدمة

- **Service account name**: `savecarnum`
- **Service account ID**: سيتم ملؤه تلقائياً
- **Description**: `Service account for Car Numbers App`
- اضغط "Create and Continue"

### 3.4 إعداد الصلاحيات

- **Role**: اختر "Editor" (محرر)
- اضغط "Continue"

### 3.5 إنشاء المفتاح

- اضغط "Done"
- اضغط على اسم حساب الخدمة الذي تم إنشاؤه
- انتقل إلى تبويب "Keys" (المفاتيح)
- اضغط "Add Key" (إضافة مفتاح)
- اختر "Create new key" (إنشاء مفتاح جديد)
- اختر "JSON"
- اضغط "Create"

### 3.6 حفظ ملف JSON

- سيتم تحميل ملف JSON تلقائياً
- احفظ الملف في مجلد آمن
- **اسم الملف**: `carnumbersapp-469914-3fcef272fb5e.json`

---

## 📊 الخطوة 4: إنشاء جدول بيانات Google Sheets

### 4.1 الذهاب إلى Google Sheets

- اذهب إلى: [https://sheets.google.com/](https://sheets.google.com/)
- اضغط "Blank" (فارغ) لإنشاء جدول جديد

### 4.2 تسمية الجدول

- اضغط على "Untitled spreadsheet" (جدول بيانات بدون عنوان)
- أدخل الاسم: `CarNumbers`
- اضغط Enter

### 4.3 إعداد العمود

- في الخلية A1، اكتب: `number`
- اضغط Enter
- هذا سيكون عنوان العمود

### 4.4 تنسيق العنوان

- حدد الخلية A1
- اضغط على زر "B" لجعل النص عريض
- اضغط على زر "Fill color" واختر لوناً مميزاً

---

## 🔗 الخطوة 5: مشاركة الجدول مع حساب الخدمة

### 5.1 فتح إعدادات المشاركة

- اضغط على زر "Share" (مشاركة) في أعلى اليمين
- أو اضغط `Ctrl + Shift + P`

### 5.2 إضافة حساب الخدمة

- في حقل "Add people and groups"، اكتب:
  ```
  savecarnum@carnumbersapp-469914.iam.gserviceaccount.com
  ```

### 5.3 تعيين الصلاحيات

- **Role**: اختر "Editor" (محرر)
- **Notify people**: اتركه غير محدد
- اضغط "Send" (إرسال)

### 5.4 نسخ معرف الجدول

- من شريط العنوان، انسخ المعرف:
  ```
  1oFT2fPcKhFImGXZDJpRh9c0DdCM60AENtzoDMKjU_ow
  ```

---

## 📁 الخطوة 6: إعداد التطبيق

### 6.1 نسخ ملف JSON

- انسخ ملف `carnumbersapp-469914-3fcef272fb5e.json`
- الصقه في مجلد `assets/` في مشروع Flutter

### 6.2 تحديث ملف التكوين

- افتح `lib/core/config/app_config.dart`
- تأكد من أن المعرف صحيح:
  ```dart
  static const String spreadsheetId = '1oFT2fPcKhFImGXZDJpRh9c0DdCM60AENtzoDMKjU_ow';
  ```
- تأكد من أن مسار الملف صحيح:
  ```dart
  static const String credentialsPath = 'assets/carnumbersapp-469914-3fcef272fb5e.json';
  ```

### 6.3 تحديث pubspec.yaml

- تأكد من أن assets مضاف:
  ```yaml
  assets:
    - assets/carnumbersapp-469914-3fcef272fb5e.json
  ```

---

## 🧪 الخطوة 7: اختبار الربط

### 7.1 تشغيل التطبيق

```bash
flutter pub get
flutter run
```

### 7.2 اختبار الإضافة

- انتظر شاشة البداية
- أدخل رقم سيارة: `12345`
- اضغط "حفظ"
- يجب أن تظهر رسالة "تم الحفظ بنجاح"

### 7.3 التحقق من Google Sheets

- افتح الجدول مرة أخرى
- يجب أن ترى الرقم `12345` في العمود `number`

---

## 🔍 استكشاف الأخطاء

### مشكلة: "فشل في تحميل ملف الاعتماديات"

**الحل:**

- تأكد من أن ملف JSON في مجلد `assets/`
- تأكد من أن `pubspec.yaml` يحتوي على المسار الصحيح
- شغل `flutter clean` ثم `flutter pub get`

### مشكلة: "فشل في تهيئة Google Sheets"

**الحل:**

- تأكد من تفعيل Google Sheets API
- تأكد من أن حساب الخدمة له صلاحيات "Editor"
- تحقق من معرف الجدول

### مشكلة: "حدث خطأ ما، يرجى المحاولة مرة أخرى"

**الحل:**

- تحقق من اتصال الإنترنت
- تأكد من مشاركة الجدول مع حساب الخدمة
- تحقق من أن المشروع نشط في Google Cloud

---

## 📱 اختبار الوظائف

### ✅ قائمة التحقق:

- [ ] شاشة البداية تعمل
- [ ] إضافة رقم سيارة يعمل
- [ ] رسالة النجاح تظهر
- [ ] الرقم يظهر في القائمة
- [ ] العداد يتحدث
- [ ] البيانات تظهر في Google Sheets
- [ ] حذف رقم يعمل
- [ ] العداد يتحدث بعد الحذف

---

## 🚀 النشر والإنتاج

### بناء APK:

```bash
flutter build apk --release
```

### موقع APK:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 📞 الدعم والمساعدة

### إذا واجهت مشاكل:

1. تحقق من رسائل الخطأ في Console
2. تأكد من اتباع جميع الخطوات
3. تحقق من الصلاحيات والإعدادات
4. راجع ملف `TEST_APP.md` للاختبار

### روابط مفيدة:

- [Google Cloud Console](https://console.cloud.google.com/)
- [Google Sheets](https://sheets.google.com/)
- [Flutter Documentation](https://flutter.dev/docs)

---

## 🎉 تم الإعداد!

بعد اتباع هذه الخطوات، سيكون تطبيقك مرتبطاً بـ Google Sheets ويعمل بشكل مثالي!

**ملاحظة مهمة**: احتفظ بملف JSON في مكان آمن ولا تشاركه مع أحد، فهو يحتوي على مفاتيح حساسة.
