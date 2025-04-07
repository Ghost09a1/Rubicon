from django.db.models.signals import post_save
from django.dispatch import receiver

from rpg_platform.apps.messages.models import ChatMessage, ChatRoom
from rpg_platform.apps.notifications.models import Notification
from rpg_platform.apps.accounts.models import UserActivity


@receiver(post_save, sender=ChatMessage)
def create_message_notification(sender, instance, created, **kwargs):
    """
    Create a notification when a new chat message is received
    """
    if created and instance.receiver != instance.sender:
        # Don't notify for self-messages
        Notification.objects.create(
            user=instance.receiver,
            notification_type='message',
            actor=instance.sender,
            target_id=instance.chat_room.id,
            verb='sent you a message',
            action_object_id=instance.id
        )


@receiver(post_save, sender=ChatRoom)
def log_chatroom_creation(sender, instance, created, **kwargs):
    """
    Log when a new chat room is created
    """
    if created:
        # Get list of participants (excluding the creator)
        participants = [user.username for user in instance.participants.all()
                        if user != instance.creator]

        # Log activity for the creator
        UserActivity.log_activity(
            user=instance.creator,
            activity_type='message',
            content_type='chatroom',
            object_id=instance.id,
            extra_data={
                'participants': participants,
                'room_name': instance.name or '',
                'room_type': instance.room_type
            }
        )
