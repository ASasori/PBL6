# Generated by Django 5.1.2 on 2024-11-17 08:11

from django.db import migrations


class Migration(migrations.Migration):
    dependencies = [
        ("hotel", "0009_cartitem_check_in_date_cartitem_check_out_date_and_more"),
    ]

    operations = [
        migrations.RemoveField(
            model_name="cartitem",
            name="hotel",
        ),
        migrations.RemoveField(
            model_name="cartitem",
            name="room_type",
        ),
    ]