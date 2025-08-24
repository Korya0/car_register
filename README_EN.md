# 🚗 Car Register App

A complete Flutter application for registering car plate numbers during brochure distribution campaigns, ensuring each car receives only one brochure.

## ✨ Features

- **Splash Screen**: Logo display with light blue background for 2 seconds
- **Home Screen**: Car registration interface with counter and list view
- **Google Sheets Integration**: Cloud database for data storage
- **Arabic RTL Support**: Full Arabic language support with right-to-left layout
- **Input Validation**: Numbers-only input with duplicate prevention
- **Error Handling**: Comprehensive error handling and offline support
- **Modern UI**: Clean, simple, and easy-to-use interface

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── config/          # App configuration and Google Sheets setup
│   ├── router/          # Navigation configuration
│   └── utils/           # Helper services
├── features/
│   └── car_register/
│       ├── data/        # Data services
│       └── presentation/
│           ├── cubit/   # State management
│           └── widgets/ # UI components
└── main.dart            # App entry point
```

## 🚀 Installation & Setup

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Run the App

```bash
flutter run
```

### 3. Build APK

```bash
flutter build apk --release
```

## ⚙️ Google Sheets Setup

### Step 1: Google Cloud Console

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable Google Sheets API

### Step 2: Service Account

1. Go to "APIs & Services" > "Credentials"
2. Click "Create Credentials" > "Service Account"
3. Download the JSON credentials file

### Step 3: Google Sheet

1. Create a new Google Sheet
2. Share it with the service account email (Editor permissions)
3. Copy the Spreadsheet ID from the URL

### Step 4: Update Configuration

1. Copy the JSON file to the `assets/` folder
2. Update `lib/core/config/app_config.dart`:
   - `spreadsheetId`: Your spreadsheet ID
   - `credentialsPath`: Path to your JSON file

## 📱 App Usage

1. **Launch**: Shows splash screen for 2 seconds
2. **Registration**: Enter car plate number (digits only) and tap Save
3. **Validation**: App checks for duplicates and validates input
4. **Management**: View all registered numbers with delete functionality
5. **Counter**: Real-time count of registered cars

## 🛡️ Error Handling

- **Duplicate Numbers**: "This car is already registered"
- **Invalid Input**: "Digits only are allowed"
- **No Internet**: "Internet connection required"
- **API Errors**: "Something went wrong, please try again"

## 🎨 Design

- **Colors**: Blue primary with white background
- **Typography**: Full Arabic language support
- **Layout**: Right-to-left (RTL) layout
- **Animations**: Smooth transitions and visual effects

## 🏛️ Architecture

- **Clean Architecture**: Organized by features and layers
- **State Management**: Cubit pattern for state management
- **Dependency Injection**: Services injected through constructor
- **Separation of Concerns**: UI, business logic, and data layers separated

## 📚 Dependencies

- `flutter_bloc`: State management
- `go_router`: Navigation
- `gsheets`: Google Sheets integration
- `connectivity_plus`: Connection monitoring
- `equatable`: Value equality support

## 🔧 Troubleshooting

### Common Issues:

1. **Dependencies not found**: Run `flutter pub get`
2. **Google Sheets API errors**: Check credentials and API enablement
3. **Permission denied**: Ensure service account has Editor access
4. **Build errors**: Check Flutter version compatibility

### Testing:

1. Run `flutter doctor` to check Flutter installation
2. Test with `flutter run` on device/emulator
3. Verify Google Sheets connection by adding a test entry

## 📋 System Requirements

- Flutter SDK 3.8.1 or later
- Dart SDK 3.0.0 or later
- Android Studio / VS Code
- Android device or emulator

## 🚀 Deployment

### Build Production APK:

```bash
flutter build apk --release
```

### APK Location:

```
build/app/outputs/flutter-apk/app-release.apk
```

## 📞 Support

- **Flutter Docs**: https://flutter.dev/docs
- **Google Sheets API**: https://developers.google.com/sheets/api
- **Flutter Bloc**: https://bloclibrary.dev/

## 📄 License

This project is for educational and commercial use.

---

**Developed with Flutter using modern best practices and clean architecture** 🚀
