from django.contrib import admin
from apps.profiles_api import models

# Register your models here.
admin.site.register(models.UserProfile)