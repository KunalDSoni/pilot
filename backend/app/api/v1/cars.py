from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.schemas.car import CarCreate, CarListResponse, CarResponse
from app.services.car_service import CarService

router = APIRouter()


@router.get("/", response_model=CarListResponse)
async def list_cars(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    brand_id: int | None = None,
    fuel_type: str | None = None,
    transmission_type: str | None = None,
    body_type: str | None = None,
    min_price: float | None = None,
    max_price: float | None = None,
    search: str | None = None,
    db: AsyncSession = Depends(get_db),
):
    service = CarService(db)
    return await service.list_cars(
        page=page,
        page_size=page_size,
        brand_id=brand_id,
        fuel_type=fuel_type,
        transmission_type=transmission_type,
        body_type=body_type,
        min_price=min_price,
        max_price=max_price,
        search=search,
    )


@router.get("/{car_id}", response_model=CarResponse)
async def get_car(car_id: int, db: AsyncSession = Depends(get_db)):
    service = CarService(db)
    return await service.get_car(car_id)


@router.post("/", response_model=CarResponse, status_code=201)
async def create_car(data: CarCreate, db: AsyncSession = Depends(get_db)):
    service = CarService(db)
    return await service.create_car(data)
