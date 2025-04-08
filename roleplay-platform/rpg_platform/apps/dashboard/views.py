from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from django.db.models import Count, Q

# Import models from other apps
from rpg_platform.apps.characters.models import Character
from rpg_platform.apps.messages.models import ChatRoom
from rpg_platform.apps.accounts.models import Friendship, FriendRequest, UserActivity
from rpg_platform.apps.notifications.models import Notification
from rpg_platform.apps.recommendations.models import CharacterRecommendation

@login_required
def home(request):
    """
    Main dashboard/home page view that shows an aggregated view of
    all platform features and user activity.
    """
    user = request.user

    # Get stats for quick overview
    context = {
        # Character stats
        'character_count': Character.objects.filter(user=user).count(),
        'characters': Character.objects.filter(user=user).order_by('-updated_at')[:4],

        # Chat stats - updated to use the correct field name
        'chatroom_count': ChatRoom.objects.filter(participants=user).count(),
        'chat_rooms': ChatRoom.objects.filter(participants=user).order_by('-updated_at')[:5],

        # Friend stats
        'friend_count': Friendship.objects.filter(Q(user1=user) | Q(user2=user)).count(),
        'friend_requests': FriendRequest.objects.filter(to_user=user, status='pending')[:3],

        # Notification stats - updated to use 'read' field
        'notification_count': Notification.objects.filter(user=user, read=False).count(),
        'notifications': Notification.objects.filter(user=user).order_by('-created_at')[:5],

        # Activity stats
        'activities': UserActivity.objects.filter(
            # Show activities from the user and their friends
            Q(user=user) |
            Q(user__in=Friendship.objects.filter(Q(user1=user) | Q(user2=user)).values('user1', 'user2'))
        ).order_by('-timestamp')[:8],

        # Recommendations
        'recommendations': CharacterRecommendation.objects.filter(user=user, is_dismissed=False)[:3],
    }

    return render(request, 'dashboard/home.html', context)
