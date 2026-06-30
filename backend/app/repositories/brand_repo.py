from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.brand import Brand


class BrandRepository:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def get_all(self) -> list[Brand]:
        result = await self.db.execute(select(Brand).order_by(Brand.name))
        return list(result.scalars().all())

    async def get_by_id(self, brand_id: int) -> Brand | None:
        return await self.db.get(Brand, brand_id)

    async def create(self, brand: Brand) -> Brand:
        self.db.add(brand)
        await self.db.flush()
        await self.db.refresh(brand)
        return brand
