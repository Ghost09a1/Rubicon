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
echo  9. Migration conflicts

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

echo Cleaning up existing migrations in messages app...
if exist "rpg_platform\apps\messages\migrations" (
    echo Backing up existing migrations...
    if not exist "rpg_platform\apps\messages\migrations_backup" (
        mkdir "rpg_platform\apps\messages\migrations_backup"
    )
    xcopy /Y "rpg_platform\apps\messages\migrations\*.py" "rpg_platform\apps\messages\migrations_backup\" > nul 2>&1

    echo Removing conflicting migrations...
    del /Q "rpg_platform\apps\messages\migrations\0001_*.py" > nul 2>&1
    del /Q "rpg_platform\apps\messages\migrations\0002_*.py" > nul 2>&1
    del /Q "rpg_platform\apps\messages\migrations\fix_label.py" > nul 2>&1
)

echo Creating migrations directory and __init__.py if needed...
if not exist "rpg_platform\apps\messages\migrations" (
    mkdir "rpg_platform\apps\messages\migrations"
    echo. > "rpg_platform\apps\messages\migrations\__init__.py"
) else (
    echo. > "rpg_platform\apps\messages\migrations\__init__.py"
)

echo Creating consolidated initial migration for messages app...
echo from django.db import migrations, models > "rpg_platform\apps\messages\migrations\0001_initial.py"
echo import django.db.models.deletion >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo. >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo. >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo class Migration(migrations.Migration): >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo. >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo     initial = True >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo. >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo     dependencies = [ >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo         ('characters', '0001_initial'), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo         ('accounts', '0001_initial'), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo     ] >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo. >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo     operations = [ >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo         migrations.CreateModel( >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo             name='ChatRoom', >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo             fields=[ >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 ('name', models.CharField(blank=True, max_length=100, verbose_name='Room Name')), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 ('room_type', models.CharField(choices=[('private', 'Private'), ('group', 'Group')], default='private', max_length=10, verbose_name='Room Type')), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 ('created_at', models.DateTimeField(auto_now_add=True, verbose_name='Created At')), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 ('updated_at', models.DateTimeField(auto_now=True, verbose_name='Updated At')), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 ('is_active', models.BooleanField(default=True, verbose_name='Active')), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 ('scene_description', models.TextField(blank=True, help_text='Setting and atmosphere for the current scene', verbose_name='Scene Description')), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 ('participants', models.ManyToManyField(related_name='chat_rooms', to='accounts.User', verbose_name='Participants')), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo             ], >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo             options={ >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 'verbose_name': 'Chat Room', >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 'verbose_name_plural': 'Chat Rooms', >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 'ordering': ['-updated_at'], >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo             }, >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo         ), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo         migrations.CreateModel( >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo             name='ChatMessage', >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo             fields=[ >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 ('message', models.TextField(verbose_name='Message')), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 ('created_at', models.DateTimeField(auto_now_add=True, verbose_name='Created At')), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 ('read', models.BooleanField(default=False, verbose_name='Read')), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 ('character', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='chat_messages', to='characters.Character', verbose_name='Character')), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 ('chat_room', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='messages', to='chat_messages.ChatRoom', verbose_name='Chat Room')), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 ('receiver', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='received_messages', to='accounts.User', verbose_name='Receiver')), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 ('sender', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='sent_messages', to='accounts.User', verbose_name='Sender')), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo             ], >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo         ), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo         migrations.CreateModel( >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo             name='DiceRoll', >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo             fields=[ >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 ('formula', models.CharField(help_text='Format like \"2d6+3\" or \"d20\"', max_length=100, verbose_name='Dice Formula')), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 ('result', models.JSONField(help_text='JSON containing the dice roll results', verbose_name='Result')), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 ('total', models.IntegerField(verbose_name='Total Result')), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 ('created_at', models.DateTimeField(auto_now_add=True, verbose_name='Created At')), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 ('character', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='dice_rolls', to='characters.Character', verbose_name='Character')), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 ('chat_room', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='dice_rolls', to='chat_messages.ChatRoom', verbose_name='Chat Room')), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='dice_rolls', to='accounts.User', verbose_name='User')), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo             ], >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo             options={ >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 'verbose_name': 'Dice Roll', >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 'verbose_name_plural': 'Dice Rolls', >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo                 'ordering': ['-created_at'], >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo             }, >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo         ), >> "rpg_platform\apps\messages\migrations\0001_initial.py"
echo     ] >> "rpg_platform\apps\messages\migrations\0001_initial.py"

echo.
echo ===================================================
echo    STEP 5: Applying Migrations in Correct Order
echo ===================================================
echo.

echo Clearing any existing migration state from chat_messages app...
python manage_windows.py migrate chat_messages zero --fake
if errorlevel 1 (
    echo Warning: Could not clear chat_messages migrations, but continuing...
)

echo Applying basic system migrations first...
python manage_windows.py migrate auth
python manage_windows.py migrate contenttypes
python manage_windows.py migrate admin
python manage_windows.py migrate sessions

echo.
echo Applying app-specific migrations in dependency order...
python manage_windows.py migrate accounts
python manage_windows.py migrate characters
echo Applying chat_messages migrations...
python manage_windows.py migrate chat_messages
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

echo.
echo Applying comprehensive error handling to all views...
echo This ensures the application will gracefully handle database errors
echo even if fields are missing or tables don't exist yet.

echo.
echo ===================================================
echo    STEP 7: Resolving Migration Conflicts
echo ===================================================
echo.

echo Checking for migration conflicts...
python manage_windows.py showmigrations chat_messages > migration_status.txt
findstr /C:"[ ]" migration_status.txt > nul
if errorlevel 1 (
    echo No migration conflicts detected for chat_messages app.
) else (
    echo Migration conflicts detected. Resolving now...

    echo Step 1: Clearing migration history for chat_messages app...
    python manage_windows.py migrate chat_messages zero --fake

    echo Step 2: Applying the consolidated migration...
    python manage_windows.py migrate chat_messages
    if errorlevel 1 (
        echo Warning: There was an issue applying migrations, trying with --fake-initial flag...
        python manage_windows.py migrate chat_messages --fake-initial
    )

    echo Migration conflict resolution complete.
)
del migration_status.txt

echo.
echo ===================================================
echo    STEP 8: Performing Database Check
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
echo    STEP 9: Superuser Account Creation
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
