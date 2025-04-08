from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('characters', '0001_initial'),
        ('accounts', '0001_initial'),
        ('chat_messages', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='DiceRoll',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('formula', models.CharField(help_text='Format like "2d6+3" or "d20"', max_length=100, verbose_name='Dice Formula')),
                ('result', models.JSONField(help_text='JSON containing the dice roll results', verbose_name='Result')),
                ('total', models.IntegerField(verbose_name='Total Result')),
                ('created_at', models.DateTimeField(auto_now_add=True, verbose_name='Created At')),
                ('is_private', models.BooleanField(default=False, help_text='If true, only visible to GM and roller', verbose_name='Private Roll')),
                ('character', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='dice_rolls', to='characters.Character', verbose_name='Character')),
                ('chat_room', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='dice_rolls', to='chat_messages.ChatRoom', verbose_name='Chat Room')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='dice_rolls', to='accounts.User', verbose_name='User')),
            ],
            options={
                'verbose_name': 'Dice Roll',
                'verbose_name_plural': 'Dice Rolls',
                'ordering': ['-created_at'],
            },
        ),
    ]
