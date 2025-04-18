## models.py

"""
models.py

This module defines the core data structures for the application, including User, ProxyEmail, Email, and EmailSummary classes.
"""

from datetime import datetime
from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager

class UserManager(BaseUserManager):
    """
    Custom manager for User model.
    """
    def create_user(self, username: str, email: str, password: str = None) -> 'User':
        if not email:
            raise ValueError('Users must have an email address')
        user = self.model(
            username=username,
            email=self.normalize_email(email),
        )
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, username: str, email: str, password: str) -> 'User':
        user = self.create_user(
            username=username,
            email=email,
            password=password,
        )
        user.is_admin = True
        user.save(using=self._db)
        return user

class User(AbstractBaseUser):
    """
    User model for handling user data.
    """
    username = models.CharField(max_length=255, unique=True)
    email = models.EmailField(max_length=255, unique=True)
    is_active = models.BooleanField(default=True)
    is_admin = models.BooleanField(default=False)

    objects = UserManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username']

    def __str__(self) -> str:
        return self.email

    def has_perm(self, perm, obj=None) -> bool:
        return True

    def has_module_perms(self, app_label) -> bool:
        return True

class ProxyEmail(models.Model):
    """
    ProxyEmail model for handling proxy email addresses.
    """
    proxy_address = models.EmailField(max_length=255, unique=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)

    def generate_proxy_email(self, user: User) -> 'ProxyEmail':
        # Logic to generate a unique proxy email address
        proxy_email = f"{user.username}@mail.example.com"
        return ProxyEmail.objects.create(proxy_address=proxy_email, user=user)

class Email(models.Model):
    """
    Email model for handling email data.
    """
    subject = models.CharField(max_length=255)
    body = models.TextField()
    received_at = models.DateTimeField(default=datetime.now)
    proxy_email = models.ForeignKey(ProxyEmail, on_delete=models.CASCADE)

    def parse_email(self, raw_email: str) -> 'Email':
        # Logic to parse raw email string into Email object
        # This is a placeholder implementation
        return Email(subject="Parsed Subject", body="Parsed Body", proxy_email=self.proxy_email)

class EmailSummary(models.Model):
    """
    EmailSummary model for handling email summarization.
    """
    summary = models.TextField()
    email = models.OneToOneField(Email, on_delete=models.CASCADE)

    def summarize_email(self, email: Email) -> 'EmailSummary':
        # Logic to summarize the email content
        # This is a placeholder implementation
        return EmailSummary.objects.create(summary="Summarized Content", email=email)
