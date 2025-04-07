# RoleplayHub - Django Backend

This is the Django backend for RoleplayHub, a text-based roleplay platform. The backend handles the core functionality, landing pages, user authentication, and more.

## 💻 Quick Start

**Windows Users:**
```
cd roleplay-platform
start.bat
```

**Unix/Linux/Mac Users:**
```
cd roleplay-platform
chmod +x start.sh
./start.sh
```

Then access the application at: [http://localhost:8000/](http://localhost:8000/)

## 📚 Project Documentation

We have created detailed documentation to help you get started:

- [Setup Guide](SETUP_GUIDE.md) - **Start here!** Complete setup instructions
- [Windows Setup](WINDOWS_SETUP.md) - Windows-specific troubleshooting
- [Fixed Issues](FIXED_ISSUES.md) - Solutions to common problems

## 🔍 Diagnostics

If you encounter any issues, run our diagnostic tool:

```
python test_environment.py
```

This will check your environment and help identify any problems.

## 🏗️ Project Structure

```
roleplay-platform/
├── manage.py                   # Django management script
├── manage_windows.py           # Enhanced Windows script
├── start.sh                    # Unix startup script
├── start.bat                   # Windows startup script
└── rpg_platform/
    ├── apps/                   # Django apps
    │   ├── accounts/           # User accounts
    │   ├── characters/         # Character management
    │   ├── messages/           # Chat system (labeled as chat_messages)
    │   ├── notifications/      # User notifications
    │   ├── moderation/         # Admin moderation tools
    │   ├── recommendations/    # Character recommendations
    │   └── landing/            # Landing pages
    ├── templates/              # HTML templates
    ├── static/                 # Static files (CSS, JS, images)
    └── rpg_platform/           # Project settings
```

## ✨ Features

- **User Authentication and Profiles**: Registration, login, and profile management
- **Character Creation**: Detailed character creation and management
- **Chat System**: Real-time messaging with WebSockets
- **Consent System**: Boundary setting and consent management for roleplay
- **Quick Responses**: Save and reuse common phrases and actions
- **Scene Settings**: Create and apply immersive scene descriptions
- **Private Notes**: Keep personal notes for your roleplay sessions

## 💡 Usage Notes

- The Django admin interface is available at: [http://localhost:8000/admin/](http://localhost:8000/admin/)
- To create an admin user, run: `python manage_windows.py createsuperuser` (Windows) or `python manage.py createsuperuser` (Unix)
- The project is configured to use SQLite by default for simplicity

## 🔧 Development

This Django backend works with the Next.js frontend located in the `roleplay-chat-platform` directory. The frontend connects to this backend API to provide a modern user interface.

## 🚀 Production Deployment

For production deployment, you should:

1. Change `DEBUG` to `False` in settings
2. Use a more robust database (PostgreSQL recommended)
3. Set up proper email configuration
4. Use a production-ready web server (Gunicorn, uWSGI)
5. Consider using Docker for containerization
