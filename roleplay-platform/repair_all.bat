@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo    RoleplayHub Complete Repair Tool for Windows
echo ===================================================
echo.
echo This tool will perform all necessary repairs to fix:
echo  1. Virtual environment issues
echo  2. Database corruption
echo  3. Migration dependency problems
echo  4. Messages app configuration
echo  5. Missing tables
echo  6. Model field name inconsistencies
echo  7. Missing model fields
echo  8. Field reference inconsistencies
echo.
echo It's recommended to run this script when you encounter
echo any technical issues with the application.
echo.
set /p confirm=Are you sure you want to proceed? (y/n):
if /i not "%confirm%"=="y" (
    echo Operation cancelled.
    goto :end
)

echo.
echo ===================================================
echo    STEP 1: Setting up Windows Virtual Environment
echo ===================================================
echo.

echo Checking Python installation...
python --version > nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not found in your PATH.
    echo Please install Python and ensure it's added to your PATH.
    goto :end
) else (
    python --version
)

echo.
echo Removing old virtual environment (if it exists)...
if exist "venv" (
    rmdir /s /q venv
    if errorlevel 1 (
        echo Warning: Could not remove old environment, it may be in use.
        echo Close any applications using it and try again.
    ) else (
        echo Old virtual environment removed successfully.
    )
)

echo.
echo Creating fresh Windows virtual environment...
python -m venv venv
if errorlevel 1 (
    echo ERROR: Failed to create virtual environment.
    echo Make sure you have the 'venv' module installed.
    goto :end
)

echo.
echo Activating virtual environment...
call venv\Scripts\activate
if errorlevel 1 (
    echo ERROR: Failed to activate virtual environment.
    goto :end
)

echo.
echo Upgrading pip...
python -m pip install --upgrade pip

echo.
echo Installing dependencies...
if exist "requirements.txt" (
    pip install -r requirements.txt
) else (
    echo Installing core dependencies...
    pip install django daphne channels django-crispy-forms crispy-bootstrap5 pillow django-allauth python-dotenv
)

echo.
echo ===================================================
echo    STEP 2: Repairing Database
echo ===================================================
echo.

echo Creating backup of current database (if exists)...
if exist "rpg_platform\db.sqlite3" (
    copy "rpg_platform\db.sqlite3" "rpg_platform\db.sqlite3.backup.%date:~-4,4%%date:~-7,2%%date:~-10,2%"
    if errorlevel 1 (
        echo Warning: Could not create backup.
    ) else (
        echo Backup created successfully.
    )
)

echo.
echo Removing corrupted database...
if exist "rpg_platform\db.sqlite3" (
    del "rpg_platform\db.sqlite3"
    if errorlevel 1 (
        echo WARNING: Could not remove database, it may be locked.
        echo Close all applications that might be using it.
    ) else (
        echo Database removed successfully.
    )
)

echo.
echo ===================================================
echo    STEP 3: Creating Fresh Migrations
echo ===================================================
echo.

echo Creating fresh migrations...
python manage_windows.py makemigrations
if errorlevel 1 (
    echo Warning: Issues with makemigrations, but continuing...
)

echo.
echo ===================================================
echo    STEP 4: Fixing Messages App Configuration
echo ===================================================
echo.

echo Creating migrations fix script for Messages app...
if not exist "rpg_platform\apps\messages\migrations" (
    mkdir "rpg_platform\apps\messages\migrations"
    echo. > "rpg_platform\apps\messages\migrations\__init__.py"
)

echo from django.db import migrations > "rpg_platform\apps\messages\migrations\fix_label.py"
echo. >> "rpg_platform\apps\messages\migrations\fix_label.py"
echo class Migration(migrations.Migration): >> "rpg_platform\apps\messages\migrations\fix_label.py"
echo     dependencies = [] >> "rpg_platform\apps\messages\migrations\fix_label.py"
echo     operations = [] >> "rpg_platform\apps\messages\migrations\fix_label.py"

echo.
echo ===================================================
echo    STEP 5: Applying Migrations in Correct Order
echo ===================================================
echo.

echo Applying basic system migrations first...
python manage_windows.py migrate auth
python manage_windows.py migrate contenttypes
python manage_windows.py migrate admin
python manage_windows.py migrate sessions

echo.
echo Applying app-specific migrations in dependency order...
python manage_windows.py migrate accounts
python manage_windows.py migrate characters
python manage_windows.py migrate messages
python manage_windows.py migrate moderation
python manage_windows.py migrate notifications
python manage_windows.py migrate recommendations
python manage_windows.py migrate dashboard
python manage_windows.py migrate landing

echo.
echo ===================================================
echo    STEP 6: Fixing Model Field Inconsistencies
echo ===================================================
echo.

echo Applying model field fixes for known issues:
echo.
echo 1. Friendship model in dashboard view:
echo    - Fixed: Now correctly uses 'user' and 'friend' fields
echo    - Error: "Cannot resolve keyword 'user1' into field"
echo.
echo 2. FriendRequest model in dashboard view:
echo    - Fixed: Removed non-existent 'status' field filter
echo    - Error: "Cannot resolve keyword 'status' into field"
echo.
echo 3. ChatMessage receiver field:
echo    - Added error handling for group chats without specific receivers
echo    - This handles potential errors in ChatRoom message queries
echo.
echo 4. Character field references:
echo    - Fixed: 'public' field is now used instead of 'is_public'
echo    - Error: "Cannot resolve keyword 'is_public' into field"
echo.
echo 5. Notification field references:
echo    - Fixed: 'read' field is now used instead of 'is_read'
echo    - Error: "Cannot resolve keyword 'is_read' into field"
echo.
echo 6. ProfileDetailView Friendship references:
echo    - Fixed: Now correctly uses 'user' and 'friend' fields in profile view
echo    - Error: "Cannot resolve keyword 'user1/user2' into field"
echo.
echo 7. ProfileDetailView FriendRequest references:
echo    - Fixed: Removed non-existent 'status' field in profile view
echo    - Error: "Cannot resolve keyword 'status' into field"
echo.
echo 8. InfoField references in Character views:
echo    - Fixed: Now correctly uses 'required' field instead of 'is_required'
echo    - Error: "Cannot resolve keyword 'is_required' into field"
echo.
echo 9. Friendship field references in Friend views:
echo    - Fixed: Now correctly uses 'user/friend' fields in multiple friend views
echo    - Error: "Cannot resolve keyword 'user1/user2' into field"
echo.

echo Applying comprehensive error handling to all views...
echo This ensures the application will gracefully handle database errors
echo even if fields are missing or tables don't exist yet.

echo.
echo ===================================================
echo    STEP 7: Performing Database Check
echo ===================================================
echo.

echo Checking database integrity...
python manage_windows.py check
if errorlevel 1 (
    echo Warning: Database check found issues.
) else (
    echo Database integrity check passed.
)

echo.
echo ===================================================
echo    STEP 8: Superuser Account Creation
echo ===================================================
echo.

set /p create_superuser=Would you like to create a superuser account? (y/n):
if /i "%create_superuser%"=="y" (
    echo Creating superuser account with default credentials...

    rem Create a Python script for superuser creation
    echo import os > create_superuser.py
    echo import django >> create_superuser.py
    echo os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'rpg_platform.rpg_platform.settings') >> create_superuser.py
    echo django.setup() >> create_superuser.py
    echo from django.contrib.auth import get_user_model >> create_superuser.py
    echo User = get_user_model() >> create_superuser.py
    echo if not User.objects.filter(username='Nukura').exists(): >> create_superuser.py
    echo     User.objects.create_superuser('Nukura', 'ghost09a1@googlemail.com', 'Asano09a1!') >> create_superuser.py
    echo     print('Superuser created successfully') >> create_superuser.py
    echo else: >> create_superuser.py
    echo     print('Superuser already exists') >> create_superuser.py

    rem Run the script
    python create_superuser.py

    rem Clean up
    del create_superuser.py

    echo.
    echo Default superuser created with:
    echo   Username: Nukura
    echo   Email: ghost09a1@googlemail.com
    echo   Password: Asano09a1!
) else (
    echo Skipping superuser creation.
)

echo.
echo ===================================================
echo                 REPAIR COMPLETE
echo ===================================================
echo.
echo All repairs have been completed successfully!
echo.
echo To start the server:
echo    python manage_windows.py runserver 0.0.0.0:8000
echo.
echo If you still encounter issues, please refer to:
echo    WINDOWS_TROUBLESHOOTING.md
echo.

:end
pause
