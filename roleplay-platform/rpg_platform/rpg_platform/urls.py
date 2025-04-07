from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.views.generic import RedirectView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('accounts/', include('rpg_platform.apps.accounts.urls')),
    path('characters/', include('rpg_platform.apps.characters.urls')),
    path('messages/', include('rpg_platform.apps.messages.urls')),
    path('notifications/', include('rpg_platform.apps.notifications.urls')),
    path('moderation/', include('rpg_platform.apps.moderation.urls')),
    path('recommendations/', include('rpg_platform.apps.recommendations.urls')),
    path('', include('rpg_platform.apps.landing.urls')),  # Updated to include landing app
]

# Serve media files in development
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
