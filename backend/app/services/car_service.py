from fastapi import HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.car import Car
from app.repositories.car_repo import CarRepository
from app.schemas.car import (
    CarCreate,
    CarListResponse,
    CarResponse,
    CarVariantResponse,
    CarColorResponse,
)


class CarService:
    def __init__(self, db: AsyncSession):
        self.repo = CarRepository(db)

    async def list_cars(
        self,
        page: int = 1,
        page_size: int = 20,
        brand_id: int | None = None,
        fuel_type: str | None = None,
        transmission_type: str | None = None,
        body_type: str | None = None,
        min_price: float | None = None,
        max_price: float | None = None,
        search: str | None = None,
    ) -> CarListResponse:
        cars, total = await self.repo.get_all(
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
        return CarListResponse(
            items=[self._to_response(car) for car in cars],
            total=total,
            page=page,
            page_size=page_size,
            total_pages=max(1, (total + page_size - 1) // page_size),
        )

    async def get_car(self, car_id: int) -> CarResponse:
        car = await self.repo.get_by_id(car_id)
        if not car:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Car not found",
            )
        return self._to_response(car)

    async def create_car(self, data: CarCreate) -> CarResponse:
        car = Car(**data.model_dump())
        car = await self.repo.create(car)
        return self._to_response(car)

    def _to_response(self, car: Car) -> CarResponse:
        variants = None
        if car.variants:
            variants = [
                CarVariantResponse(
                    id=v.id,
                    car_id=v.car_id,
                    name=v.name,
                    price=v.price,
                    fuel_type=v.fuel_type,
                    transmission_type=v.transmission_type,
                    mileage=v.mileage,
                    colors=[
                        CarColorResponse(
                            id=c.id,
                            name=c.name,
                            hex_code=c.hex_code,
                        )
                        for c in (v.colors or [])
                    ] if v.colors else None,
                )
                for v in car.variants
            ]

        return CarResponse(
            id=car.id,
            brand=car.brand,
            name=car.name,
            year=car.year,
            body_type=car.body_type,
            fuel_type=car.fuel_type,
            transmission_type=car.transmission_type,
            engine=car.engine,
            mileage=car.mileage,
            seating_capacity=car.seating_capacity,
            min_price=car.min_price,
            max_price=car.max_price,
            image_url=car.image_url,
            variants=variants,
        )
