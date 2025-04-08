from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from django.db.models import Count, Q
from django.db import DatabaseError
import logging

# Import models from other apps
from rpg_platform.apps.characters.models import Character
from rpg_platform.apps.messages.models import ChatRoom
from rpg_platform.apps.accounts.models import Friendship, FriendRequest, UserActivity
from rpg_platform.apps.notifications.models import Notification
from rpg_platform.apps.recommendations.models import CharacterRecommendation

# Set up logger
logger = logging.getLogger(__name__)

@login_required
def home(request):
    """
    Main dashboard/home page view that shows an aggregated view of
    all platform features and user activity.
    """
    user = request.user
    context = {}

    # Use defensive programming with try-except blocks for each section
    # This prevents one failing query from bringing down the entire dashboard

    # Character stats
    try:
        context['character_count'] = Character.objects.filter(user=user).count()
        context['characters'] = Character.objects.filter(user=user).select_related('user').order_by('-updated_at')[:4]
    except DatabaseError as e:
        logger.error(f"Error fetching character data: {str(e)}")
        context['character_count'] = 0
        context['characters'] = []

    # Chat room stats
    try:
        context['chatroom_count'] = ChatRoom.objects.filter(participants=user).count()
        context['chat_rooms'] = ChatRoom.objects.filter(participants=user).prefetch_related('participants').order_by('-updated_at')[:5]
    except DatabaseError as e:
        logger.error(f"Error fetching chat room data: {str(e)}")
        context['chatroom_count'] = 0
        context['chat_rooms'] = []

    # Friend stats
    try:
        context['friend_count'] = Friendship.objects.filter(Q(user1=user) | Q(user2=user)).count()
        context['friend_requests'] = FriendRequest.objects.filter(to_user=user, status='pending').select_related('from_user', 'to_user')[:3]
    except DatabaseError as e:
        logger.error(f"Error fetching friendship data: {str(e)}")
        context['friend_count'] = 0
        context['friend_requests'] = []

    # Notification stats
    try:
        context['notification_count'] = Notification.objects.filter(user=user, read=False).count()
        context['notifications'] = Notification.objects.filter(user=user).select_related('actor', 'category').order_by('-created_at')[:5]
    except DatabaseError as e:
        logger.error(f"Error fetching notification data: {str(e)}")
        context['notification_count'] = 0
        context['notifications'] = []

    # Activity stats
    try:
        context['activities'] = UserActivity.objects.filter(
            # Show activities from the user and their friends
            Q(user=user) |
            Q(user__in=Friendship.objects.filter(Q(user1=user) | Q(user2=user)).values('user1', 'user2'))
        ).select_related('user').order_by('-created_at')[:8]
    except DatabaseError as e:
        logger.error(f"Error fetching activity data: {str(e)}")
        context['activities'] = []

    # Recommendations
    try:
        context['recommendations'] = CharacterRecommendation.objects.filter(
            user=user, is_dismissed=False
        ).select_related('character')[:3]
    except DatabaseError as e:
        logger.error(f"Error fetching recommendation data: {str(e)}")
        context['recommendations'] = []

    return render(request, 'dashboard/home.html', context)
