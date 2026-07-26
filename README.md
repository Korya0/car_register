<div align="center">

<!-- Badges at Top -->
<p>
  <a href="https://github.com/Korya0/car_register/graphs/contributors">
    <img src="https://img.shields.io/github/contributors/Korya0/car_register" alt="contributors" />
  </a>
  <a href="https://github.com/Korya0/car_register/commits/main">
    <img src="https://img.shields.io/github/last-commit/Korya0/car_register" alt="last update" />
  </a>
  <a href="https://github.com/Korya0/car_register/stargazers">
    <img src="https://img.shields.io/github/stars/Korya0/car_register" alt="stars" />
  </a>
  <a href="https://github.com/Korya0/car_register/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/Korya0/car_register" alt="license" />
  </a>
</p>

<!-- Typing Logo -->
<img src="https://readme-typing-svg.herokuapp.com/?font=Inter&weight=800&size=50&center=true&vCenter=true&width=600&height=100&duration=4000&lines=Car+Register+App"/>

<!-- Links Section -->
<p>
  <a href="https://mostaql.com/u/Korya/reviews/9091624">
    <img src="https://img.shields.io/badge/⭐_Client_Review-F5A623?style=for-the-badge" alt="Client Review"/>
  </a>
  <a href="https://www.linkedin.com/in/mahmoudk25/">
    <img src="https://img.shields.io/badge/💬_LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn"/>
  </a>
</p>

</div>

---

## 🚀 Key Features

<details>
<summary><b>📋 Registration & Validation</b></summary>
<br>

- **Custom Number Pad**: Enter plate numbers using an in-app keypad — no system keyboard needed.
- **Input Validation**: Numbers only, up to 8 digits, with duplicate prevention.
- **Instant Feedback**: Clear error messages for invalid or repeated entries.

</details>

<details>
<summary><b>☁️ Google Sheets Integration</b></summary>
<br>

- **Cloud Database**: All plate numbers synced to Google Sheets in real time.
- **Internal Cache**: Speeds up read operations to minimize API calls.
- **Full CRUD**: Add, view, and delete records directly from the app.

</details>

<details>
<summary><b>🗑️ Bulk Management</b></summary>
<br>

- **Multi-select Delete**: Long-press any item to enter selection mode, then delete multiple plates at once.
- **Delete All**: Long-press the save button to delete all records at once, with a confirmation dialog.

</details>

<details>
<summary><b>🌐 Network Awareness</b></summary>
<br>

- **Connectivity Tracking**: The app monitors network status and informs the user when offline.
- **Error Handling**: Comprehensive handling for API errors and connectivity issues.

</details>

---

## 🛠️ Tech Stack

- **Framework**: `Flutter`
- **Architecture**: `Clean Architecture`
- **State Management**: `BLoC / Cubit`
- **Database**: `Google Sheets API`
- **Navigation**: `GoRouter`
- **Language Support**: `Arabic (RTL)`

---

## 💻 Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/Korya0/car_register.git
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Add your credentials**
   - Place your Google Service Account JSON file at `assets/credentials.json`
   - Update `lib/core/config/app_config.dart` with your `spreadsheetId`

4. **Run the project**
   ```bash
   flutter run
   ```

---

## 📅 Roadmap

- [x] Core registration & Google Sheets sync
- [x] Multi-select & bulk delete
- [x] Network connectivity tracking
- [x] Internal cache for faster reads
- [x] Comprehensive Project Documentation
- [ ] Unit & widget testing

---

## 📄 License

Distributed under the **MIT License**. See `LICENSE` for more information.

---

<div align="center">
Made with ❤️ by Korya
<br/>
<b>© 2026 Car Register App</b>
</div>
