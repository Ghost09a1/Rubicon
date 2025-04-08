from django.db import migrations


def populate_last_message_time(apps, schema_editor):
    """
    Populate the last_message_time field for existing ChatRoom records
    """
    ChatRoom = apps.get_model('chat_messages', 'ChatRoom')
    ChatMessage = apps.get_model('chat_messages', 'ChatMessage')

    # Get all chat rooms
    for chat_room in ChatRoom.objects.all():
        # Find the latest message for this chat room
        latest_message = ChatMessage.objects.filter(chat_room=chat_room).order_by('-created_at').first()

        if latest_message:
            # Set last_message_time to the created_at time of the latest message
            chat_room.last_message_time = latest_message.created_at
        else:
            # If no messages exist, use the chat room's created_at time
            chat_room.last_message_time = chat_room.created_at

        chat_room.save(update_fields=['last_message_time'])


class Migration(migrations.Migration):

    dependencies = [
        ('chat_messages', '0003_chatroom_last_message_time'),
    ]

    operations = [
        migrations.RunPython(populate_last_message_time, reverse_code=migrations.RunPython.noop),
    ]
