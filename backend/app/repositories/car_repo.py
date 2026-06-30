from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.models.car import Car, CarVariant, CarColor


class CarRepository:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def get_all(
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
    ) -> tuple[list[Car], int]:
        query = (
            select(Car)
            .options(
                selectinload(Car.brand),
                selectinload(Car.variants).selectinload(CarVariant.colors),
            )
        )

        count_query = select(func.count(Car.id))

        if brand_id:
            query = query.where(Car.brand_id == brand_id)
            count_query = count_query.where(Car.brand_id == brand_id)
        if fuel_type:
            query = query.where(Car.fuel_type == fuel_type)
            count_query = count_query.where(Car.fuel_type == fuel_type)
        if transmission_type:
            query = query.where(Car.transmission_type == transmission_type)
            count_query = count_query.where(Car.transmission_type == transmission_type)
        if body_type:
            query = query.where(Car.body_type == body_type)
            count_query = count_query.where(Car.body_type == body_type)
        if min_price is not None:
            query = query.where(Car.min_price >= min_price)
            count_query = count_query.where(Car.min_price >= min_price)
        if max_price is not None:
            query = query.where(Car.max_price <= max_price)
            count_query = count_query.where(Car.max_price <= max_price)
        if search:
            search_pattern = f"%{search}%"
            query = query.where(Car.name.ilike(search_pattern))
            count_query = count_query.where(Car.name.ilike(search_pattern))

        total_result = await self.db.execute(count_query)
        total = total_result.scalar() or 0

        query = query.order_by(Car.name).offset((page - 1) * page_size).limit(page_size)
        result = await self.db.execute(query)

        return list(result.scalars().all()), total

    async def get_by_id(self, car_id: int) -> Car | None:
        result = await self.db.execute(
            select(Car)
            .options(
                selectinload(Car.brand),
                selectinload(Car.variants).selectinload(CarVariant.colors),
            )
            .where(Car.id == car_id)
        )
        return result.scalar_one_or_none()

    async def create(self, car: Car) -> Car:
        self.db.add(car)
        await self.db.flush()
        await self.db.refresh(car)
        return car
