# Generated by Django 5.1 on 2024-11-05 13:57

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('hotel', '0006_room_slug'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='hotel',
            name='image',
        ),
    ]
