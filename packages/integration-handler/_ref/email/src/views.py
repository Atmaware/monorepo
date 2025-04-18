## views.py

"""
views.py

This module implements views for user registration, authentication, and dashboard management.
"""

from django.shortcuts import render, redirect
from django.http import JsonResponse, HttpRequest, HttpResponse
from django.contrib.auth import authenticate, login, logout
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.decorators import login_required
from .models import User, ProxyEmail, Email, EmailSummary
import json

@csrf_exempt
def register(request: HttpRequest) -> JsonResponse:
    """
    Handles user registration.

    Args:
        request (HttpRequest): The HTTP request object containing user data.

    Returns:
        JsonResponse: A JSON response indicating success or failure.
    """
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            username = data.get('username')
            email = data.get('email')
            password = data.get('password')

            if not username or not email or not password:
                return JsonResponse({'error': 'Missing fields'}, status=400)

            user = User.objects.create_user(username=username, email=email, password=password)
            return JsonResponse({'message': 'User registered successfully'}, status=200)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Invalid request method'}, status=405)

@csrf_exempt
def authenticate_user(request: HttpRequest) -> JsonResponse:
    """
    Handles user authentication.

    Args:
        request (HttpRequest): The HTTP request object containing user credentials.

    Returns:
        JsonResponse: A JSON response indicating success or failure.
    """
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            username = data.get('username')
            password = data.get('password')

            if not username or not password:
                return JsonResponse({'error': 'Missing fields'}, status=400)

            user = authenticate(request, username=username, password=password)
            if user is not None:
                login(request, user)
                return JsonResponse({'message': 'User authenticated successfully'}, status=200)
            else:
                return JsonResponse({'error': 'Invalid credentials'}, status=401)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Invalid request method'}, status=405)

@login_required
def view_dashboard(request: HttpRequest) -> HttpResponse:
    """
    Renders the user dashboard.

    Args:
        request (HttpRequest): The HTTP request object.

    Returns:
        HttpResponse: The rendered dashboard HTML page.
    """
    user = request.user
    # Fetch user-related data for the dashboard
    proxy_emails = ProxyEmail.objects.filter(user=user)
    emails = Email.objects.filter(proxy_email__in=proxy_emails)
    email_summaries = EmailSummary.objects.filter(email__in=emails)

    context = {
        'user': user,
        'proxy_emails': proxy_emails,
        'emails': emails,
        'email_summaries': email_summaries,
    }
    return render(request, 'dashboard.html', context)

@login_required
def manage_account_settings(request: HttpRequest) -> JsonResponse:
    """
    Handles account settings management.

    Args:
        request (HttpRequest): The HTTP request object.

    Returns:
        JsonResponse: A JSON response indicating success or failure.
    """
    if request.method == 'POST':
        try:
            # Logic for managing account settings
            # This is a placeholder implementation
            return JsonResponse({'message': 'Account settings updated successfully'}, status=200)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Invalid request method'}, status=405)
