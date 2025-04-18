## app.py

"""
app.py

This module initializes the Django application, configures settings, and handles email sending using Django's built-in email utilities.
"""

import os
from django.core.wsgi import get_wsgi_application
from django.core.mail import send_mail
from django.conf import settings

# Django settings configuration
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'onesub.settings')


def send_email(subject: str, recipient: str, body: str) -> bool:
    """
    Sends an email using Django's email utilities.

    Args:
        subject (str): The subject of the email.
        recipient (str): The recipient's email address.
        body (str): The body of the email.

    Returns:
        bool: True if the email was sent successfully, False otherwise.
    """
    try:
        send_mail(
            subject,
            body,
            settings.EMAIL_HOST_USER,
            [recipient],
            fail_silently=False,
        )
        return True
    except Exception as e:
        print(f"Failed to send email: {e}")
        return False

def main():
    # Initialize Django application
    get_wsgi_application()
    # Test sending an email
    success = send_email("Test Subject", "jamestztsai@gmail.com", "This is a test email.")
    print("Email sent successfully" if success else "Failed to send email")


if __name__ == "__main__":
    main()