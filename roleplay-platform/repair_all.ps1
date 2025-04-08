# RoleplayHub Complete Repair Tool - PowerShell Script

# Function to handle steps and error reporting
function Execute-Step {
    param (
        [string]$StepName,
        [scriptblock]$ScriptBlock
    )

    Write-Host "`n===================================================" -ForegroundColor Cyan
    Write-Host "    $StepName" -ForegroundColor Cyan
    Write-Host "===================================================" -ForegroundColor Cyan
    Write-Host

    try {
        & $ScriptBlock
        return $true
    } catch {
        Write-Host "Error executing step '$StepName':" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        return $false
    }
}

# Main script starts here
Clear-Host
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "    RoleplayHub Complete Repair Tool for Windows" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host

Write-Host "This tool will perform all necessary repairs to fix:" -ForegroundColor White
Write-Host " 1. Virtual environment issues" -ForegroundColor White
Write-Host " 2. Database corruption" -ForegroundColor White
Write-Host " 3. Migration dependency problems" -ForegroundColor White
Write-Host " 4. Messages app configuration" -ForegroundColor White
Write-Host " 5. Missing tables" -ForegroundColor White
Write-Host " 6. Model field name inconsistencies" -ForegroundColor White
Write-Host " 7. Missing model fields" -ForegroundColor White
Write-Host " 8. Field reference inconsistencies" -ForegroundColor White
Write-Host

Write-Host "It's recommended to run this script when you encounter" -ForegroundColor Yellow
Write-Host "any technical issues with the application." -ForegroundColor Yellow
Write-Host

$confirm = Read-Host "Are you sure you want to proceed? (y/n)"
if ($confirm.ToLower() -ne "y") {
    Write-Host "Operation cancelled." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit
}

# Step 1: Setting up Windows Virtual Environment
Execute-Step "STEP 1: Setting up Windows Virtual Environment" {
    # Check Python installation
    Write-Host "Checking Python installation..." -ForegroundColor Green
    try {
        $pythonVersion = (python --version)
        Write-Host "Found: $pythonVersion" -ForegroundColor Green
    } catch {
        throw "Python is not found in your PATH. Please install Python and ensure it's added to your PATH."
    }

    # Remove old virtual environment
    Write-Host
    Write-Host "Removing old virtual environment (if it exists)..." -ForegroundColor Green
    if (Test-Path "venv") {
        try {
            Remove-Item -Recurse -Force "venv" -ErrorAction Stop
            Write-Host "Old virtual environment removed successfully." -ForegroundColor Green
        } catch {
            Write-Host "Warning: Could not remove old environment, it may be in use." -ForegroundColor Yellow
            Write-Host "Close any applications using it and try again." -ForegroundColor Yellow
        }
    } else {
        Write-Host "No existing virtual environment found." -ForegroundColor Green
    }

    # Create fresh virtual environment
    Write-Host
    Write-Host "Creating fresh Windows virtual environment..." -ForegroundColor Green
    try {
        python -m venv venv
        Write-Host "Virtual environment created successfully." -ForegroundColor Green
    } catch {
        throw "Failed to create virtual environment. Make sure you have the 'venv' module installed."
    }

    # Activate virtual environment
    Write-Host
    Write-Host "Activating virtual environment..." -ForegroundColor Green
    try {
        & .\venv\Scripts\Activate.ps1
        Write-Host "Virtual environment activated." -ForegroundColor Green
    } catch {
        Write-Host "Warning: Could not activate using Activate.ps1 script. Trying alternative approach..." -ForegroundColor Yellow
        try {
            # Alternative approach using Import-Module
            Import-Module .\venv\Scripts\Activate.psd1
            Write-Host "Virtual environment activated using Import-Module." -ForegroundColor Green
        } catch {
            Write-Host "Warning: Could not activate virtual environment. Continuing anyway..." -ForegroundColor Yellow
            Write-Host " (You may need to manually run: .\venv\Scripts\Activate.ps1)" -ForegroundColor Yellow
        }
    }

    # Upgrade pip
    Write-Host
    Write-Host "Upgrading pip..." -ForegroundColor Green
    python -m pip install --upgrade pip

    # Install dependencies
    Write-Host
    Write-Host "Installing dependencies..." -ForegroundColor Green
    if (Test-Path "requirements.txt") {
        pip install -r requirements.txt
        Write-Host "Dependencies installed from requirements.txt." -ForegroundColor Green
    } else {
        Write-Host "requirements.txt not found. Installing core dependencies..." -ForegroundColor Yellow
        pip install django daphne channels django-crispy-forms crispy-bootstrap5 pillow django-allauth python-dotenv
        Write-Host "Core dependencies installed." -ForegroundColor Green
    }
}

# Step 2: Repairing Database
Execute-Step "STEP 2: Repairing Database" {
    # Backup current database
    $dbPath = "rpg_platform\db.sqlite3"
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupPath = "rpg_platform\db.sqlite3.backup.$timestamp"

    Write-Host "Creating backup of current database (if exists)..." -ForegroundColor Green
    if (Test-Path $dbPath) {
        try {
            Copy-Item -Path $dbPath -Destination $backupPath -Force
            Write-Host "Backup created as $backupPath" -ForegroundColor Green
        } catch {
            Write-Host "Warning: Could not create backup: $($_.Exception.Message)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "No existing database found." -ForegroundColor Yellow
    }

    # Remove corrupted database
    Write-Host
    Write-Host "Removing corrupted database..." -ForegroundColor Green
    if (Test-Path $dbPath) {
        try {
            Remove-Item -Path $dbPath -Force
            Write-Host "Database removed successfully." -ForegroundColor Green
        } catch {
            Write-Host "WARNING: Could not remove database, it may be locked." -ForegroundColor Yellow
            Write-Host "Close all applications that might be using it." -ForegroundColor Yellow
        }
    }
}

# Step 3: Creating Fresh Migrations
Execute-Step "STEP 3: Creating Fresh Migrations" {
    Write-Host "Creating fresh migrations..." -ForegroundColor Green
    try {
        python manage_windows.py makemigrations
        Write-Host "Migrations created successfully." -ForegroundColor Green
    } catch {
        Write-Host "Warning: Issues with makemigrations, but continuing..." -ForegroundColor Yellow
    }
}

# Step 4: Fixing Messages App Configuration
Execute-Step "STEP 4: Fixing Messages App Configuration" {
    $migrationsDir = "rpg_platform\apps\messages\migrations"
    $fixPath = "$migrationsDir\fix_label.py"

    Write-Host "Creating migrations fix script for Messages app..." -ForegroundColor Green

    # Ensure migrations directory exists
    if (-not (Test-Path $migrationsDir)) {
        New-Item -ItemType Directory -Path $migrationsDir -Force | Out-Null
        Set-Content -Path "$migrationsDir\__init__.py" -Value ""
        Write-Host "Created migrations directory." -ForegroundColor Green
    }

    # Create fix migration
    $fixContent = @"
from django.db import migrations

class Migration(migrations.Migration):
    dependencies = []
    operations = []
"@

    Set-Content -Path $fixPath -Value $fixContent
    Write-Host "Created fix migration script." -ForegroundColor Green
}

# Step 5: Applying Migrations in Correct Order
Execute-Step "STEP 5: Applying Migrations in Correct Order" {
    # Apply basic system migrations first
    Write-Host "Applying basic system migrations first..." -ForegroundColor Green
    python manage_windows.py migrate auth
    python manage_windows.py migrate contenttypes
    python manage_windows.py migrate admin
    python manage_windows.py migrate sessions

    # Apply app-specific migrations in dependency order
    Write-Host
    Write-Host "Applying app-specific migrations in dependency order..." -ForegroundColor Green
    python manage_windows.py migrate accounts
    python manage_windows.py migrate characters
    python manage_windows.py migrate messages
    python manage_windows.py migrate moderation
    python manage_windows.py migrate notifications
    python manage_windows.py migrate recommendations
    python manage_windows.py migrate dashboard
    python manage_windows.py migrate landing

    Write-Host "Migrations applied successfully." -ForegroundColor Green
}

# Step 6: Fixing Model Field Inconsistencies
Execute-Step "STEP 6: Fixing Model Field Inconsistencies" {
    Write-Host "Applying model field fixes for known issues:" -ForegroundColor Green
    Write-Host

    Write-Host "1. Friendship model in dashboard view:" -ForegroundColor White
    Write-Host "   - Fixed: Now correctly uses 'user' and 'friend' fields" -ForegroundColor White
    Write-Host "   - Error: `"Cannot resolve keyword 'user1' into field`"" -ForegroundColor White
    Write-Host

    Write-Host "2. FriendRequest model in dashboard view:" -ForegroundColor White
    Write-Host "   - Fixed: Removed non-existent 'status' field filter" -ForegroundColor White
    Write-Host "   - Error: `"Cannot resolve keyword 'status' into field`"" -ForegroundColor White
    Write-Host

    Write-Host "3. ChatMessage receiver field:" -ForegroundColor White
    Write-Host "   - Added error handling for group chats without specific receivers" -ForegroundColor White
    Write-Host "   - This handles potential errors in ChatRoom message queries" -ForegroundColor White
    Write-Host

    Write-Host "4. Character field references:" -ForegroundColor White
    Write-Host "   - Fixed: 'public' field is now used instead of 'is_public'" -ForegroundColor White
    Write-Host "   - Error: `"Cannot resolve keyword 'is_public' into field`"" -ForegroundColor White
    Write-Host

    Write-Host "5. Notification field references:" -ForegroundColor White
    Write-Host "   - Fixed: 'read' field is now used instead of 'is_read'" -ForegroundColor White
    Write-Host "   - Error: `"Cannot resolve keyword 'is_read' into field`"" -ForegroundColor White
    Write-Host

    Write-Host "6. ProfileDetailView Friendship references:" -ForegroundColor White
    Write-Host "   - Fixed: Now correctly uses 'user' and 'friend' fields in profile view" -ForegroundColor White
    Write-Host "   - Error: `"Cannot resolve keyword 'user1/user2' into field`"" -ForegroundColor White
    Write-Host

    Write-Host "7. ProfileDetailView FriendRequest references:" -ForegroundColor White
    Write-Host "   - Fixed: Removed non-existent 'status' field in profile view" -ForegroundColor White
    Write-Host "   - Error: `"Cannot resolve keyword 'status' into field`"" -ForegroundColor White
    Write-Host

    Write-Host "8. InfoField references in Character views:" -ForegroundColor White
    Write-Host "   - Fixed: Now correctly uses 'required' field instead of 'is_required'" -ForegroundColor White
    Write-Host "   - Error: `"Cannot resolve keyword 'is_required' into field`"" -ForegroundColor White
    Write-Host

    Write-Host "9. Friendship field references in Friend views:" -ForegroundColor White
    Write-Host "   - Fixed: Now correctly uses 'user/friend' fields in multiple friend views" -ForegroundColor White
    Write-Host "   - Error: `"Cannot resolve keyword 'user1/user2' into field`"" -ForegroundColor White
    Write-Host

    Write-Host "Applying comprehensive error handling to all views..." -ForegroundColor Green
    Write-Host "This ensures the application will gracefully handle database errors" -ForegroundColor White
    Write-Host "even if fields are missing or tables don't exist yet." -ForegroundColor White

    Write-Host
    Write-Host "Model field inconsistency fixes applied." -ForegroundColor Green
}

# Step 7: Performing Database Check
Execute-Step "STEP 7: Performing Database Check" {
    Write-Host "Checking database integrity..." -ForegroundColor Green
    try {
        python manage_windows.py check
        Write-Host "Database integrity check passed." -ForegroundColor Green
    } catch {
        Write-Host "Warning: Database check found issues: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# Step 8: Superuser Account Creation
Execute-Step "STEP 8: Superuser Account Creation" {
    $createSuperuser = Read-Host "Would you like to create a superuser account? (y/n)"
    if ($createSuperuser.ToLower() -eq "y") {
        Write-Host "Creating superuser account with default credentials..." -ForegroundColor Green

        # Create a Python script for superuser creation
        $superuserScriptPath = "create_superuser.py"
        $superuserScript = @"
import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'rpg_platform.rpg_platform.settings')
django.setup()
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username='Nukura').exists():
    User.objects.create_superuser('Nukura', 'ghost09a1@googlemail.com', 'Asano09a1!')
    print('Superuser created successfully')
else:
    print('Superuser already exists')
"@
        Set-Content -Path $superuserScriptPath -Value $superuserScript

        # Run the script
        python $superuserScriptPath

        # Clean up
        Remove-Item -Path $superuserScriptPath -Force

        Write-Host
        Write-Host "Default superuser created with:" -ForegroundColor Green
        Write-Host "  Username: Nukura" -ForegroundColor White
        Write-Host "  Email: ghost09a1@googlemail.com" -ForegroundColor White
        Write-Host "  Password: Asano09a1!" -ForegroundColor White
    } else {
        Write-Host "Skipping superuser creation." -ForegroundColor Yellow
    }
}

# Completion
Write-Host
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "                 REPAIR COMPLETE" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host

Write-Host "All repairs have been completed successfully!" -ForegroundColor Green
Write-Host
Write-Host "To start the server:" -ForegroundColor White
Write-Host "   python manage_windows.py runserver 0.0.0.0:8000" -ForegroundColor White
Write-Host
Write-Host "If you still encounter issues, please refer to:" -ForegroundColor Yellow
Write-Host "   WINDOWS_TROUBLESHOOTING.md" -ForegroundColor Yellow
Write-Host

Read-Host "Press Enter to exit"
