# Fixed Issues in RoleplayHub Backend

## Path Configuration Issues

We identified and fixed several path-related issues that were causing the "No module named 'rpg_platform.settings'" error:

1. **Updated settings path in manage.py**:
   - Changed `'rpg_platform.settings'` to `'rpg_platform.rpg_platform.settings'`
   - This ensures Django can find the settings module in the correct location

2. **Updated paths in settings.py**:
   - Changed `ROOT_URLCONF` from `'rpg_platform.urls'` to `'rpg_platform.rpg_platform.urls'`
   - Changed `WSGI_APPLICATION` from `'rpg_platform.wsgi.application'` to `'rpg_platform.rpg_platform.wsgi.application'`
   - Changed `ASGI_APPLICATION` from `'rpg_platform.asgi.application'` to `'rpg_platform.rpg_platform.asgi.application'`

3. **Added missing WSGI file**:
   - Created the missing `wsgi.py` file with proper imports and settings path

4. **Updated ASGI configuration**:
   - Updated the settings path in `asgi.py` to match the correct path structure

5. **Enhanced start.bat**:
   - Added additional required dependencies to the installation command

## Messages App Conflict

The "Application labels aren't unique, duplicates: messages" issue was already fixed in the codebase:

- The `messages` app has a custom label `chat_messages` in `apps.py`
- The settings.py file correctly uses `MessagesConfig` to reference the app

## Form Field Issues

The following form and view issues were fixed:

1. **CharacterForm Field Mismatch**:
   - The form was referencing fields like `description_bbc`, `description_css`, `use_css`, and `is_public` that didn't exist in the Character model
   - Updated the form to use the actual fields from the model: `name`, `gender`, `species`, `height`, `body_type`, `age`, `personality`, `background`, `appearance`, `public`, etc.

2. **Multiple File Upload Widget Issue**:
   - Django's built-in widgets (`ClearableFileInput` and `FileInput`) don't support multiple file uploads
   - Created a custom `RawMultipleFileInput` widget extending Django's base `Input` class to handle multiple file uploads
   - Enhanced the widget to better handle files from request data

3. **Character Form Template**:
   - Updated the template to match the actual fields in the Character model
   - Removed references to non-existent fields and added help text for clarity

4. **CharacterSearchForm Issue**:
   - The form was trying to use `Character.GENDER_CHOICES` which doesn't exist in the model
   - Changed the gender field from `MultipleChoiceField` to a simple `CharField` with a text input
   - Updated the character search template to work with the new gender field

5. **View References to incorrect field names**:
   - Fixed views that were referencing `is_public` instead of the correct field name `public`
   - Fixed references to `visibility` which should be `public`

6. **CharacterSearchView Implementation**:
   - Implemented a proper CharacterSearchView class to handle advanced character searches
   - Updated to handle all form fields correctly

## Running the Application

After these fixes, you should now be able to run the application using:

1. Windows: Double-click `start.bat`
2. Unix: Run `./start.sh`

To start the application:

```
cd roleplay-platform
python manage_windows.py runserver 0.0.0.0:8000
```

This should now allow you to create, edit, and search for characters correctly.

## If Issues Persist

If you still encounter issues:
1. Make sure all dependencies are installed properly
2. Check for any error messages in the terminal
3. Try deleting the `db.sqlite3` file and running migrations again
4. Verify that your Python environment is properly configured
