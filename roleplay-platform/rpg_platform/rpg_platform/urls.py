from django.urls import path
from .views import (
    ChatRoomListView, ChatRoomCreateView, ChatRoomDetailView, ChatRoomDeleteView,
    SceneBoundaryView, SceneBoundaryAgreementView,
    SceneSettingListView, SceneSettingCreateView, SceneSettingUpdateView, SceneSettingDeleteView,
    QuickResponseListView, QuickResponseCreateView, QuickResponseUpdateView, QuickResponseDeleteView,
    PrivateNoteListView, PrivateNoteCreateView, PrivateNoteUpdateView, PrivateNoteDeleteView,
    apply_scene_setting, update_scene_status, use_quick_response,
    chat_messages_api, send_message_api, mark_message_read_api, user_characters_api
)

app_name = 'messages'

urlpatterns = [
    path('', ChatRoomListView.as_view(), name='room_list'),
    path('create/', ChatRoomCreateView.as_view(), name='room_create'),
    path('<int:pk>/', ChatRoomDetailView.as_view(), name='room_detail'),
    path('<int:pk>/delete/', ChatRoomDeleteView.as_view(), name='room_delete'),

    path('<int:room_id>/boundaries/', SceneBoundaryView.as_view(), name='scene_boundary'),
    path('<int:room_id>/boundaries/agree/', SceneBoundaryAgreementView.as_view(), name='scene_boundary_agree'),

    path('scene-settings/', SceneSettingListView.as_view(), name='scene_setting_list'),
    path('scene-settings/create/', SceneSettingCreateView.as_view(), name='scene_setting_create'),
    path('scene-settings/<int:pk>/edit/', SceneSettingUpdateView.as_view(), name='scene_setting_update'),
    path('scene-settings/<int:pk>/delete/', SceneSettingDeleteView.as_view(), name='scene_setting_delete'),

    path('quick-responses/', QuickResponseListView.as_view(), name='quick_response_list'),
    path('quick-responses/create/', QuickResponseCreateView.as_view(), name='quick_response_create'),
    path('quick-responses/<int:pk>/edit/', QuickResponseUpdateView.as_view(), name='quick_response_update'),
    path('quick-responses/<int:pk>/delete/', QuickResponseDeleteView.as_view(), name='quick_response_delete'),

    path('private-notes/', PrivateNoteListView.as_view(), name='private_note_list'),
    path('private-notes/create/', PrivateNoteCreateView.as_view(), name='private_note_create'),
    path('private-notes/<int:pk>/edit/', PrivateNoteUpdateView.as_view(), name='private_note_update'),
    path('private-notes/<int:pk>/delete/', PrivateNoteDeleteView.as_view(), name='private_note_delete'),
    path('private-notes/room/<int:room_id>/', PrivateNoteListView.as_view(), name='private_note_list_room'),
    path('private-notes/room/<int:room_id>/create/', PrivateNoteCreateView.as_view(), name='private_note_create_room'),

    # AJAX / API
    path('<int:room_id>/apply-scene/<int:setting_id>/', apply_scene_setting, name='apply_scene_setting'),
    path('<int:room_id>/update-status/', update_scene_status, name='update_scene_status'),
    path('quick-response/<int:response_id>/', use_quick_response, name='use_quick_response'),

    path('api/<int:room_id>/messages/', chat_messages_api, name='chat_messages_api'),
    path('api/<int:room_id>/send/', send_message_api, name='send_message_api'),
    path('api/message/<int:message_id>/read/', mark_message_read_api, name='mark_message_read_api'),
    path('api/user-characters/', user_characters_api, name='user_characters_api'),
]
