# Generated by Django 4.2.20 on 2025-04-08 16:06

from django.conf import settings
import django.contrib.auth.models
import django.contrib.auth.validators
from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone
import rpg_platform.apps.accounts.models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('auth', '0012_alter_user_first_name_max_length'),
    ]

    operations = [
        migrations.CreateModel(
            name='User',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('last_login', models.DateTimeField(blank=True, null=True, verbose_name='last login')),
                ('is_superuser', models.BooleanField(default=False, help_text='Designates that this user has all permissions without explicitly assigning them.', verbose_name='superuser status')),
                ('username', models.CharField(error_messages={'unique': 'A user with that username already exists.'}, help_text='Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only.', max_length=150, unique=True, validators=[django.contrib.auth.validators.UnicodeUsernameValidator()], verbose_name='username')),
                ('first_name', models.CharField(blank=True, max_length=150, verbose_name='first name')),
                ('last_name', models.CharField(blank=True, max_length=150, verbose_name='last name')),
                ('email', models.EmailField(blank=True, max_length=254, verbose_name='email address')),
                ('is_staff', models.BooleanField(default=False, help_text='Designates whether the user can log into this admin site.', verbose_name='staff status')),
                ('is_active', models.BooleanField(default=True, help_text='Designates whether this user should be treated as active. Unselect this instead of deleting accounts.', verbose_name='active')),
                ('date_joined', models.DateTimeField(default=django.utils.timezone.now, verbose_name='date joined')),
                ('bio', models.TextField(blank=True, verbose_name='Bio')),
                ('groups', models.ManyToManyField(blank=True, help_text='The groups this user belongs to. A user will get all permissions granted to each of their groups.', related_name='user_set', related_query_name='user', to='auth.group', verbose_name='groups')),
                ('user_permissions', models.ManyToManyField(blank=True, help_text='Specific permissions for this user.', related_name='user_set', related_query_name='user', to='auth.permission', verbose_name='user permissions')),
            ],
            options={
                'verbose_name': 'user',
                'verbose_name_plural': 'users',
                'abstract': False,
            },
            managers=[
                ('objects', django.contrib.auth.models.UserManager()),
            ],
        ),
        migrations.CreateModel(
            name='Profile',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('display_name', models.CharField(blank=True, max_length=100, verbose_name='Display Name')),
                ('bio', models.TextField(blank=True, verbose_name='Bio')),
                ('location', models.CharField(blank=True, max_length=100, verbose_name='Location')),
                ('avatar', models.ImageField(blank=True, null=True, upload_to=rpg_platform.apps.accounts.models.avatar_upload_path, verbose_name='Avatar')),
                ('theme', models.CharField(choices=[('light', 'Light'), ('dark', 'Dark'), ('auto', 'System Default')], default='light', max_length=10, verbose_name='Theme')),
                ('language', models.CharField(choices=[('en', 'English'), ('es', 'Spanish'), ('de', 'German')], default='en', max_length=10, verbose_name='Language')),
                ('profile_privacy', models.CharField(choices=[('public', 'Public - Anyone can view'), ('registered', 'Registered - Only registered users can view'), ('friends', 'Friends Only - Only friends can view'), ('private', 'Private - Only you can view')], default='public', max_length=10, verbose_name='Profile Privacy')),
                ('activity_privacy', models.CharField(choices=[('public', 'Public - Anyone can view'), ('registered', 'Registered - Only registered users can view'), ('friends', 'Friends Only - Only friends can view'), ('private', 'Private - Only you can view')], default='registered', max_length=10, verbose_name='Activity Privacy')),
                ('online_status', models.BooleanField(default=True, verbose_name='Show Online Status')),
                ('chat_privacy', models.CharField(choices=[('public', 'Public - Anyone can view'), ('registered', 'Registered - Only registered users can view'), ('friends', 'Friends Only - Only friends can view'), ('private', 'Private - Only you can view')], default='friends', max_length=10, verbose_name='Chat Privacy')),
                ('allow_strangers_chat', models.BooleanField(default=False, help_text='Allow users who are not your friends to start conversations with you', verbose_name='Allow Chat from Strangers')),
                ('show_character_status', models.BooleanField(default=True, help_text='Show which character you are currently using in chats', verbose_name='Show Character Status')),
                ('chat_notifications', models.BooleanField(default=True, verbose_name='Chat Notifications')),
                ('show_nsfw_content', models.BooleanField(default=False, verbose_name='Show NSFW Content')),
                ('compact_layout', models.BooleanField(default=False, verbose_name='Use Compact Layout')),
                ('email_notifications', models.BooleanField(default=True, verbose_name='Email Notifications')),
                ('friend_requests', models.BooleanField(default=True, verbose_name='Allow Friend Requests')),
                ('private_messages', models.BooleanField(default=True, verbose_name='Allow Private Messages')),
                ('created_at', models.DateTimeField(auto_now_add=True, verbose_name='Created At')),
                ('updated_at', models.DateTimeField(auto_now=True, verbose_name='Updated At')),
                ('last_active', models.DateTimeField(blank=True, null=True, verbose_name='Last Active')),
                ('user', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='profile', to=settings.AUTH_USER_MODEL, verbose_name='User')),
            ],
            options={
                'verbose_name': 'Profile',
                'verbose_name_plural': 'Profiles',
            },
        ),
        migrations.CreateModel(
            name='SocialLink',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('platform', models.CharField(choices=[('website', 'Website'), ('twitter', 'Twitter'), ('instagram', 'Instagram'), ('deviantart', 'DeviantArt'), ('furaffinity', 'FurAffinity'), ('discord', 'Discord'), ('other', 'Other')], max_length=20, verbose_name='Platform')),
                ('url', models.URLField(blank=True, verbose_name='URL')),
                ('username', models.CharField(blank=True, max_length=100, verbose_name='Username/Handle')),
                ('display_name', models.CharField(blank=True, max_length=100, verbose_name='Display Name')),
                ('profile', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='social_links', to='accounts.profile', verbose_name='Profile')),
            ],
            options={
                'verbose_name': 'Social Link',
                'verbose_name_plural': 'Social Links',
                'ordering': ['platform'],
            },
        ),
        migrations.CreateModel(
            name='DatingProfile',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('headline', models.CharField(blank=True, help_text='A catchy headline for your dating profile', max_length=100, verbose_name='Headline')),
                ('summary', models.TextField(blank=True, help_text='Tell potential matches about yourself', verbose_name='About Me')),
                ('birth_date', models.DateField(blank=True, null=True, verbose_name='Birth Date')),
                ('gender_identity', models.CharField(blank=True, choices=[('male', 'Male'), ('female', 'Female'), ('non_binary', 'Non-Binary'), ('genderfluid', 'Genderfluid'), ('transgender', 'Transgender'), ('other', 'Other'), ('prefer_not_to_say', 'Prefer not to say')], max_length=20, verbose_name='Gender Identity')),
                ('looking_for', models.CharField(choices=[('roleplay_partner', 'Roleplay Partner'), ('friend', 'Friend'), ('chat_buddy', 'Chat Buddy'), ('relationship', 'Relationship'), ('casual', 'Casual Dating'), ('not_looking', 'Not actively looking')], default='roleplay_partner', max_length=20, verbose_name='Looking For')),
                ('roleplay_experience', models.CharField(blank=True, choices=[('beginner', 'Beginner'), ('intermediate', 'Intermediate'), ('experienced', 'Experienced'), ('advanced', 'Advanced'), ('professional', 'Professional/Published')], max_length=20, verbose_name='Roleplay Experience')),
                ('writing_style', models.TextField(blank=True, help_text='Describe your writing style, length preferences, etc.', verbose_name='Writing Style')),
                ('post_frequency', models.CharField(blank=True, help_text='How often do you usually post? E.g., "Daily", "Few times a week"', max_length=100, verbose_name='Post Frequency')),
                ('min_age_preference', models.PositiveSmallIntegerField(default=18, verbose_name='Minimum Age Preference')),
                ('max_age_preference', models.PositiveSmallIntegerField(default=99, verbose_name='Maximum Age Preference')),
                ('gender_preference', models.JSONField(blank=True, default=list, help_text='List of gender identities you are interested in', verbose_name='Gender Preference')),
                ('languages', models.JSONField(blank=True, default=list, help_text='Languages you speak or write in', verbose_name='Languages')),
                ('favorite_genres', models.JSONField(blank=True, default=list, help_text='Your favorite roleplay genres', verbose_name='Favorite Genres')),
                ('is_visible', models.BooleanField(default=True, help_text='Whether your dating profile is visible in search results', verbose_name='Visible in Search')),
                ('show_online_status', models.BooleanField(default=True, verbose_name='Show Online Status')),
                ('verified', models.BooleanField(default=False, verbose_name='Verified Profile')),
                ('created_at', models.DateTimeField(auto_now_add=True, verbose_name='Created At')),
                ('updated_at', models.DateTimeField(auto_now=True, verbose_name='Updated At')),
                ('profile', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='dating_profile', to='accounts.profile', verbose_name='User Profile')),
            ],
            options={
                'verbose_name': 'Dating Profile',
                'verbose_name_plural': 'Dating Profiles',
            },
        ),
        migrations.CreateModel(
            name='DatingLike',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('message', models.TextField(blank=True, help_text='Optional message to send with the like', verbose_name='Message')),
                ('is_super_like', models.BooleanField(default=False, help_text='Super likes are highlighted and prioritized', verbose_name='Super Like')),
                ('created_at', models.DateTimeField(auto_now_add=True, verbose_name='Created At')),
                ('from_profile', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='sent_likes', to='accounts.datingprofile', verbose_name='From Profile')),
                ('to_profile', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='received_likes', to='accounts.datingprofile', verbose_name='To Profile')),
            ],
            options={
                'verbose_name': 'Dating Like',
                'verbose_name_plural': 'Dating Likes',
                'unique_together': {('from_profile', 'to_profile')},
            },
        ),
        migrations.CreateModel(
            name='UserActivity',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('activity_type', models.CharField(choices=[('character_create', 'Created Character'), ('character_update', 'Updated Character'), ('character_delete', 'Deleted Character'), ('comment', 'Commented on Character'), ('rating', 'Rated Character'), ('friendship', 'Friendship'), ('message', 'Chat Message'), ('login', 'Login')], max_length=30, verbose_name='Activity Type')),
                ('content_type', models.CharField(blank=True, max_length=100, verbose_name='Content Type')),
                ('object_id', models.PositiveIntegerField(blank=True, null=True, verbose_name='Object ID')),
                ('extra_data', models.JSONField(blank=True, default=dict, verbose_name='Extra Data')),
                ('public', models.BooleanField(default=True, help_text='Whether this activity is visible to other users', verbose_name='Public')),
                ('created_at', models.DateTimeField(auto_now_add=True, verbose_name='Created At')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='activities', to=settings.AUTH_USER_MODEL, verbose_name='User')),
            ],
            options={
                'verbose_name': 'User Activity',
                'verbose_name_plural': 'User Activities',
                'ordering': ['-created_at'],
                'indexes': [models.Index(fields=['user', 'created_at'], name='accounts_us_user_id_439e53_idx'), models.Index(fields=['activity_type'], name='accounts_us_activit_8a5b92_idx')],
            },
        ),
        migrations.CreateModel(
            name='Match',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('matched_at', models.DateTimeField(auto_now_add=True, verbose_name='Matched At')),
                ('is_active', models.BooleanField(default=True, verbose_name='Active')),
                ('initial_like1', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='+', to='accounts.datinglike', verbose_name='Initial Like from Profile 1')),
                ('initial_like2', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='+', to='accounts.datinglike', verbose_name='Initial Like from Profile 2')),
                ('profile1', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='matches_as_profile1', to='accounts.datingprofile', verbose_name='Profile 1')),
                ('profile2', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='matches_as_profile2', to='accounts.datingprofile', verbose_name='Profile 2')),
            ],
            options={
                'verbose_name': 'Match',
                'verbose_name_plural': 'Matches',
                'unique_together': {('profile1', 'profile2')},
            },
        ),
        migrations.CreateModel(
            name='Interest',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('interest_type', models.CharField(choices=[('fantasy', 'Fantasy'), ('sci_fi', 'Science Fiction'), ('romance', 'Romance'), ('action', 'Action/Adventure'), ('horror', 'Horror'), ('mystery', 'Mystery'), ('slice_of_life', 'Slice of Life'), ('historical', 'Historical'), ('superhero', 'Superhero'), ('anime', 'Anime/Manga'), ('fanfiction', 'Fanfiction'), ('original', 'Original Fiction'), ('tabletop', 'Tabletop RPG'), ('freeform', 'Freeform'), ('paragraph', 'Paragraph Style'), ('multi_para', 'Multi-Paragraph'), ('novella', 'Novella Style'), ('casual', 'Casual'), ('serious', 'Serious'), ('nsfw', 'NSFW/Adult'), ('lgbtq', 'LGBTQ+ Themes'), ('combat', 'Combat Focused'), ('character_dev', 'Character Development'), ('world_building', 'World Building'), ('slice_of_life', 'Slice of Life')], max_length=30, verbose_name='Interest Type')),
                ('level', models.PositiveSmallIntegerField(default=5, help_text='How interested are you in this topic (1-10)', verbose_name='Interest Level')),
                ('dating_profile', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='interests', to='accounts.datingprofile', verbose_name='Dating Profile')),
            ],
            options={
                'verbose_name': 'Interest',
                'verbose_name_plural': 'Interests',
                'unique_together': {('dating_profile', 'interest_type')},
            },
        ),
        migrations.CreateModel(
            name='Friendship',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created_at', models.DateTimeField(auto_now_add=True, verbose_name='Created At')),
                ('friend', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='+', to=settings.AUTH_USER_MODEL, verbose_name='Friend')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='friendships', to=settings.AUTH_USER_MODEL, verbose_name='User')),
            ],
            options={
                'verbose_name': 'Friendship',
                'verbose_name_plural': 'Friendships',
                'unique_together': {('user', 'friend')},
            },
        ),
        migrations.CreateModel(
            name='FriendRequest',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('message', models.TextField(blank=True, verbose_name='Message')),
                ('created_at', models.DateTimeField(auto_now_add=True, verbose_name='Created At')),
                ('from_user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='sent_friend_requests', to=settings.AUTH_USER_MODEL, verbose_name='From User')),
                ('to_user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='received_friend_requests', to=settings.AUTH_USER_MODEL, verbose_name='To User')),
            ],
            options={
                'verbose_name': 'Friend Request',
                'verbose_name_plural': 'Friend Requests',
                'unique_together': {('from_user', 'to_user')},
            },
        ),
        migrations.CreateModel(
            name='BlockedUser',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('reason', models.TextField(blank=True, verbose_name='Reason')),
                ('created_at', models.DateTimeField(auto_now_add=True, verbose_name='Created At')),
                ('blocked_user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='blocked_by', to=settings.AUTH_USER_MODEL, verbose_name='Blocked User')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='blocking', to=settings.AUTH_USER_MODEL, verbose_name='User')),
            ],
            options={
                'verbose_name': 'Blocked User',
                'verbose_name_plural': 'Blocked Users',
                'unique_together': {('user', 'blocked_user')},
            },
        ),
    ]
