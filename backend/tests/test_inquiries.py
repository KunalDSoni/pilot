import pytest
from httpx import AsyncClient


@pytest.mark.asyncio
async def test_create_inquiry_unauthenticated(client: AsyncClient):
    response = await client.post(
        "/api/v1/inquiries/",
        json={
            "variant_id": 1,
            "message": "I am interested in this car",
        },
    )
    assert response.status_code == 403


@pytest.mark.asyncio
async def test_list_inquiries_unauthenticated(client: AsyncClient):
    response = await client.get("/api/v1/inquiries/")
    assert response.status_code == 403
