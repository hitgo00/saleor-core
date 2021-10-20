# Generated by Django 3.2.5 on 2021-08-27 07:17

from django.db import migrations

NOT_CHARGED = "not-charged"
AUTH = "auth"
AUTHORIZED = "authorized"


def migrate_authorized_transactions(apps, schema_editor):
    Payment = apps.get_model("payment", "Payment")

    Payment.objects.filter(
        charge_status=NOT_CHARGED,
        transactions__is_success=True,
        transactions__action_required=False,
        transactions__kind=AUTH,
    ).update(charge_status=AUTHORIZED)


class Migration(migrations.Migration):

    dependencies = [
        ("payment", "0031_auto_20210826_1636"),
    ]

    operations = [
        migrations.RunPython(migrate_authorized_transactions),
    ]
