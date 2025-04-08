from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('chat_messages', '0002_diceroll'),
    ]

    operations = [
        migrations.AddField(
            model_name='chatroom',
            name='last_message_time',
            field=models.DateTimeField(blank=True, null=True, verbose_name='Last Message Time'),
        ),
    ]
