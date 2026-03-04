# Tattoo Studio Full Stack Project

This project contains a Node.js Backend Server and a Flutter Web Admin Panel for a Tattoo Studio.

## Folder Structure
```
d:\anti_mayart_tattoo
├── backend/                  # Node.js + Express + MongoDB Backend
│   ├── config/               # Database Connection configuration
│   ├── controllers/          # API Controllers for handling business logic
│   ├── models/               # MongoDB models (Mongoose)
│   ├── routes/               # Express Routes
│   ├── uploads/              # Local storage for uploaded images
│   └── server.js             # Entry Point for Node.js App
│
└── admin_panel/              # Flutter Web Admin Panel
    ├── lib/
    │   ├── models/           # Dart Models for mapping JSON
    │   ├── providers/        # Provider State Management & HTTP Requests
    │   ├── screens/          # UI Dashboard & Management Screens
    │   ├── widgets/          # Reusable UI components (Sidebar)
    │   └── main.dart         # Flutter Admin Panel Entry point
    └── pubspec.yaml          # Flutter dependencies
```

## Setup Instructions

### 1. Running the Node.js Backend

1. **Navigate to backend folder:**
   ```bash
   cd backend
   ```
2. **Setup Dependencies** (Already installed):
   ```bash
   npm install
   ```
3. **Run the server:**
   ```bash
   node server.js
   ```
   *The server runs on `http://localhost:5000` and connects to the provided MongoDB cluster. The console should log `MongoDB connected successfully`.*

### 2. Running the Flutter Web Admin Panel

1. **Navigate to the admin_panel folder:**
   ```bash
   cd admin_panel
   ```
2. **Install Packages** (Already installed):
   ```bash
   flutter pub get
   ```
3. **Run Flutter Web:**
   ```bash
   flutter run -d chrome
   ```
   *The app uses Material 3 dark theme and will fetch from `http://localhost:5000/api`.*

---

## Testing APIs (Example API Responses)

All APIs exclusively use the `POST` method per the requirements.

### About API Example: `POST /api/getAbout`

**Request:** None

**Response:**
```json
{
  "data": [
    {
      "_id": "649c123...",
      "title": "About MaayArt Tattoo",
      "description": "We specialize in cinematic and beautiful tattoo styles.",
      "createdAt": "2024-03-04T12:00:00.000Z",
      "updatedAt": "2024-03-04T12:00:00.000Z"
    }
  ]
}
```

### Portfolio API Example: `POST /api/createPortfolio`

**Request Config:** Form-Data (`multipart/form-data`)
* `title`: `Text` "Dragon Tattoo"
* `image`: `File` (Select from filesystem)

**Response:**
```json
{
  "message": "Portfolio created successfully",
  "data": {
    "title": "Dragon Tattoo",
    "image": "/uploads/1709540000000-123456789.jpg",
    "_id": "649c456...",
    "createdAt": "2024-03-04T12:00:00.000Z",
    "updatedAt": "2024-03-04T12:00:00.000Z"
  }
}
```

### Contact API Example: `POST /api/createContact`

**Request Config:** JSON Body (`application/json`)
```json
{
    "fullName": "John Doe",
    "email": "john@example.com",
    "phoneNumber": "1234567890",
    "message": "I want to get a tattoo appointment!"
}
```

**Response:**
```json
{
  "message": "Contact created successfully",
  "data": {
    "fullName": "John Doe",
    "email": "john@example.com",
    "phoneNumber": "1234567890",
    "message": "I want to get a tattoo appointment!",
    "_id": "649c789...",
    "createdAt": "2024-03-04T12:00:00.000Z",
    "updatedAt": "2024-03-04T12:00:00.000Z"
  }
}
```

## Features Delivered
- MVC Express Backend using Mongoose Object-Modeling over MongoDB Atlas.
- API Design strictly follows `POST` method requirement.
- Image storage handled automatically in the `backend/uploads` directory. Files map beautifully to Flutter UI using absolute base URL paths bridging web app context to physical storage.
- Admin Panel includes a responsive dashboard counting database elements, data-grid view, image gallery rendering natively from uploaded buffers, contact list management, beautiful dark Material 3 cards, and cohesive state using multiple Provider endpoints.
