# 🔧 Google Sheets Setup Guide for Car Register App

## 📋 Overview

This guide will walk you through setting up Google Sheets integration with your Flutter app step by step, creating a cloud database for storing car numbers.

## 🎯 What We'll Do

1. Create a Google Cloud Project
2. Enable Google Sheets API
3. Create a Service Account
4. Create a Google Sheet
5. Share the sheet with the service account
6. Connect the app with Google Sheets

---

## 🚀 Step 1: Create Google Cloud Project

### 1.1 Go to Google Cloud Console

- Open your browser and go to: [https://console.cloud.google.com/](https://console.cloud.google.com/)
- Sign in with your Google account

### 1.2 Create New Project

- Click on the current project name at the top of the page
- Click "New Project"
- Enter project name: `Car Numbers App`
- Click "Create"

### 1.3 Select the Project

- Wait for the project to be created
- Make sure the new project is selected

---

## ⚙️ Step 2: Enable Google Sheets API

### 2.1 Go to APIs & Services

- From the left sidebar, click "APIs & Services"
- Then click "Library"

### 2.2 Search for Google Sheets API

- Type in the search box: `Google Sheets API`
- Click on "Google Sheets API" from the results

### 2.3 Enable API

- Click "Enable"
- Wait for the API to be enabled
- You'll see "API enabled" message

---

## 🔑 Step 3: Create Service Account

### 3.1 Go to Credentials

- From the left sidebar, click "APIs & Services"
- Then click "Credentials"

### 3.2 Create Service Account

- Click "Create Credentials"
- Select "Service Account"

### 3.3 Fill Service Account Details

- **Service account name**: `savecarnum`
- **Service account ID**: Will be filled automatically
- **Description**: `Service account for Car Numbers App`
- Click "Create and Continue"

### 3.4 Set Permissions

- **Role**: Select "Editor"
- Click "Continue"

### 3.5 Create Key

- Click "Done"
- Click on the created service account name
- Go to "Keys" tab
- Click "Add Key"
- Select "Create new key"
- Choose "JSON"
- Click "Create"

### 3.6 Save JSON File

- JSON file will be downloaded automatically
- Save the file in a secure folder
- **Filename**: `carnumbersapp-469914-3fcef272fb5e.json`

---

## 📊 Step 4: Create Google Sheets

### 4.1 Go to Google Sheets

- Go to: [https://sheets.google.com/](https://sheets.google.com/)
- Click "Blank" to create a new sheet

### 4.2 Name the Sheet

- Click on "Untitled spreadsheet"
- Enter name: `CarNumbers`
- Press Enter

### 4.3 Set Up Column

- In cell A1, type: `number`
- Press Enter
- This will be the column header

### 4.4 Format Header

- Select cell A1
- Click "B" button to make text bold
- Click "Fill color" and choose a distinctive color

---

## 🔗 Step 5: Share Sheet with Service Account

### 5.1 Open Sharing Settings

- Click "Share" button in the top right
- Or press `Ctrl + Shift + P`

### 5.2 Add Service Account

- In "Add people and groups" field, type:
  ```
  savecarnum@carnumbersapp-469914.iam.gserviceaccount.com
  ```

### 5.3 Set Permissions

- **Role**: Select "Editor"
- **Notify people**: Leave unchecked
- Click "Send"

### 5.4 Copy Sheet ID

- From the address bar, copy the ID:
  ```
  1oFT2fPcKhFImGXZDJpRh9c0DdCM60AENtzoDMKjU_ow
  ```

---

## 📁 Step 6: Set Up the App

### 6.1 Copy JSON File

- Copy the `carnumbersapp-469914-3fcef272fb5e.json` file
- Paste it in the `assets/` folder of your Flutter project

### 6.2 Update Config File

- Open `lib/core/config/app_config.dart`
- Make sure the sheet ID is correct:
  ```dart
  static const String spreadsheetId = '1oFT2fPcKhFImGXZDJpRh9c0DdCM60AENtzoDMKjU_ow';
  ```
- Make sure the file path is correct:
  ```dart
  static const String credentialsPath = 'assets/carnumbersapp-469914-3fcef272fb5e.json';
  ```

### 6.3 Update pubspec.yaml

- Make sure assets are added:
  ```yaml
  assets:
    - assets/carnumbersapp-469914-3fcef272fb5e.json
  ```

---

## 🧪 Step 7: Test the Connection

### 7.1 Run the App

```bash
flutter pub get
flutter run
```

### 7.2 Test Adding

- Wait for splash screen
- Enter a car number: `12345`
- Click "Save"
- You should see "Saved successfully" message

### 7.3 Check Google Sheets

- Open the sheet again
- You should see `12345` in the `number` column

---

## 🔍 Troubleshooting

### Problem: "Failed to load credentials file"

**Solution:**

- Make sure JSON file is in `assets/` folder
- Make sure `pubspec.yaml` has the correct path
- Run `flutter clean` then `flutter pub get`

### Problem: "Failed to initialize Google Sheets"

**Solution:**

- Make sure Google Sheets API is enabled
- Make sure service account has "Editor" permissions
- Check the sheet ID

### Problem: "Something went wrong, please try again"

**Solution:**

- Check internet connection
- Make sure sheet is shared with service account
- Make sure project is active in Google Cloud

---

## 📱 Function Testing

### ✅ Checklist:

- [ ] Splash screen works
- [ ] Adding car number works
- [ ] Success message appears
- [ ] Number appears in list
- [ ] Counter updates
- [ ] Data appears in Google Sheets
- [ ] Deleting number works
- [ ] Counter updates after deletion

---

## 🚀 Deployment & Production

### Build APK:

```bash
flutter build apk --release
```

### APK Location:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 📞 Support & Help

### If you encounter problems:

1. Check error messages in Console
2. Make sure you followed all steps
3. Check permissions and settings
4. Review `TEST_APP.md` for testing

### Useful Links:

- [Google Cloud Console](https://console.cloud.google.com/)
- [Google Sheets](https://sheets.google.com/)
- [Flutter Documentation](https://flutter.dev/docs)

---

## 🎉 Setup Complete!

After following these steps, your app will be connected to Google Sheets and working perfectly!

**Important Note**: Keep the JSON file in a secure location and don't share it with anyone, as it contains sensitive keys.
