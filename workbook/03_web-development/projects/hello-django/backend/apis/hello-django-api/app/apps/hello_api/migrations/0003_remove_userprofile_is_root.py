# Generated by Django 3.2.25 on 2025-02-22 20:06

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('hello_api', '0002_userprofile_is_root'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='userprofile',
            name='is_root',
        ),
    ]
