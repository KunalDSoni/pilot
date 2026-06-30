import pytest
from httpx import AsyncClient


@pytest.mark.asyncio
async def test_register_user(client: AsyncClient):
    response = await client.post(
        "/api/v1/auth/register",
        json={
            "name": "Test User",
            "email": "test@example.com",
            "password": "password123",
        },
    )
    assert response.status_code == 201
    data = response.json()
    assert data["token_type"] == "bearer"
    assert data["user"]["email"] == "test@example.com"
    assert "access_token" in data
    assert "refresh_token" in data


@pytest.mark.asyncio
async def test_register_duplicate_email(client: AsyncClient):
    await client.post(
        "/api/v1/auth/register",
        json={
            "name": "User One",
            "email": "dupe@example.com",
            "password": "password123",
        },
    )
    response = await client.post(
        "/api/v1/auth/register",
        json={
            "name": "User Two",
            "email": "dupe@example.com",
            "password": "password123",
        },
    )
    assert response.status_code == 409


@pytest.mark.asyncio
async def test_login_success(client: AsyncClient):
    await client.post(
        "/api/v1/auth/register",
        json={
            "name": "Login User",
            "email": "login@example.com",
            "password": "password123",
        },
    )
    response = await client.post(
        "/api/v1/auth/login",
        json={
            "email": "login@example.com",
            "password": "password123",
        },
    )
    assert response.status_code == 200
    assert "access_token" in response.json()


@pytest.mark.asyncio
async def test_login_invalid_credentials(client: AsyncClient):
    response = await client.post(
        "/api/v1/auth/login",
        json={
            "email": "nonexistent@example.com",
            "password": "wrongpassword",
        },
    )
    assert response.status_code == 401


@pytest.mark.asyncio
async def test_register_invalid_email(client: AsyncClient):
    response = await client.post(
        "/api/v1/auth/register",
        json={
            "name": "Invalid Email",
            "email": "not-an-email",
            "password": "password123",
        },
    )
    assert response.status_code == 422


@pytest.mark.asyncio
async def test_register_weak_password(client: AsyncClient):
    response = await client.post(
        "/api/v1/auth/register",
        json={
            "name": "Weak Password",
            "email": "weak@example.com",
            "password": "short",
        },
    )
    assert response.status_code == 422
