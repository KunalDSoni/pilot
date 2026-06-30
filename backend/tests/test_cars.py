import pytest
from httpx import AsyncClient


@pytest.mark.asyncio
async def test_list_cars_empty(client: AsyncClient):
    response = await client.get("/api/v1/cars/")
    assert response.status_code == 200
    data = response.json()
    assert data["items"] == []
    assert data["total"] == 0


@pytest.mark.asyncio
async def test_list_cars_with_filters(client: AsyncClient):
    response = await client.get(
        "/api/v1/cars/",
        params={
            "fuel_type": "petrol",
            "page": 1,
            "page_size": 10,
        },
    )
    assert response.status_code == 200


@pytest.mark.asyncio
async def test_get_car_not_found(client: AsyncClient):
    response = await client.get("/api/v1/cars/99999")
    assert response.status_code == 404


@pytest.mark.asyncio
async def test_car_search(client: AsyncClient):
    response = await client.get(
        "/api/v1/cars/",
        params={"search": "nonexistent"},
    )
    assert response.status_code == 200
    assert response.json()["total"] == 0
