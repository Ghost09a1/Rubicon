from django.db import migrations, models 
import django.db.models.deletion 
 
 
class Migration(migrations.Migration): 
 
    initial = True 
 
    dependencies = [ 
        ('characters', '0001_initial'), 
        ('accounts', '0001_initial'), 
    ] 
 
    operations = [ 
        migrations.CreateModel( 
            name='ChatRoom', 
            fields=[ 
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')), 
                ('name', models.CharField(blank=True, max_length=100, verbose_name='Room Name')), 
                ('room_type', models.CharField(choices=[('private', 'Private'), ('group', 'Group')], default='private', max_length=10, verbose_name='Room Type')), 
                ('created_at', models.DateTimeField(auto_now_add=True, verbose_name='Created At')), 
                ('updated_at', models.DateTimeField(auto_now=True, verbose_name='Updated At')), 
                ('is_active', models.BooleanField(default=True, verbose_name='Active')), 
                ('scene_description', models.TextField(blank=True, help_text='Setting and atmosphere for the current scene', verbose_name='Scene Description')), 
                ('participants', models.ManyToManyField(related_name='chat_rooms', to='accounts.User', verbose_name='Participants')), 
            ], 
            options={ 
                'verbose_name': 'Chat Room', 
                'verbose_name_plural': 'Chat Rooms', 
                'ordering': ['-updated_at'], 
            }, 
        ), 
        migrations.CreateModel( 
            name='ChatMessage', 
            fields=[ 
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')), 
                ('message', models.TextField(verbose_name='Message')), 
                ('created_at', models.DateTimeField(auto_now_add=True, verbose_name='Created At')), 
                ('read', models.BooleanField(default=False, verbose_name='Read')), 
                ('character', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='chat_messages', to='characters.Character', verbose_name='Character')), 
                ('chat_room', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='messages', to='chat_messages.ChatRoom', verbose_name='Chat Room')), 
                ('receiver', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='received_messages', to='accounts.User', verbose_name='Receiver')), 
                ('sender', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='sent_messages', to='accounts.User', verbose_name='Sender')), 
            ], 
        ), 
        migrations.CreateModel( 
            name='DiceRoll', 
            fields=[ 
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')), 
                ('formula', models.CharField(help_text='Format like \"2d6+3\" or \"d20\"', max_length=100, verbose_name='Dice Formula')), 
                ('result', models.JSONField(help_text='JSON containing the dice roll results', verbose_name='Result')), 
                ('total', models.IntegerField(verbose_name='Total Result')), 
                ('created_at', models.DateTimeField(auto_now_add=True, verbose_name='Created At')), 
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
