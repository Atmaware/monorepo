## urls.py

"""
urls.py

This module defines URL patterns for routing requests to appropriate views in the Django application.
"""

from django.urls import path
from . import views

urlpatterns = [
    path('register/', views.register, name='register'),
    path('authenticate/', views.authenticate_user, name='authenticate_user'),
    path('dashboard/', views.view_dashboard, name='view_dashboard'),
    path('manage_account_settings/', views.manage_account_settings, name='manage_account_settings'),
    # path('send-test-email/', views.send_test_email, name='send_test_email'),
]
