# 🩺 Care Sync

A Flutter-based mobile application designed to streamline document management, analysis, and syncing features for healthcare or related use cases.

---

## 🧭 Project Maintenance Notes

### 🔢 Version and Build Number

Whenever you release or add a new version of the app, **update the version and build number** in the `pubspec.yaml` file.

Example:

```yaml
version: 1.0.1+2
```

### 📁 Folder Structure

lib/
│
├── src/
│ ├── models/ # Data models
│ ├── screens/ # UI screens
│ ├── service/
│ │ └── api/
│ │ └── httpService.dart # Contains Base URL configuration
│ ├── widgets/ # Reusable widgets
│ └── utils/ # Helper functions, constants, etc.
│
└── main.dart # Entry point

### 🌐 Live Server Configuration

Before building or deploying the app to production:
Navigate to:
lib/src/service/api/httpService.dart
Ensure the baseUrl points to the live (production) server before building a release.

⚠️ Do not release the app with a staging or local server URL.
