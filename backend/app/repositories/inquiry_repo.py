from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.inquiry import Inquiry


class InquiryRepository:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def get_by_user(
        self, user_id: int, page: int = 1, page_size: int = 20
    ) -> tuple[list[Inquiry], int]:
        count_result = await self.db.execute(
            select(func.count(Inquiry.id)).where(Inquiry.user_id == user_id)
        )
        total = count_result.scalar() or 0

        result = await self.db.execute(
            select(Inquiry)
            .where(Inquiry.user_id == user_id)
            .order_by(Inquiry.created_at.desc())
            .offset((page - 1) * page_size)
            .limit(page_size)
        )
        return list(result.scalars().all()), total

    async def get_by_id(self, inquiry_id: int) -> Inquiry | None:
        return await self.db.get(Inquiry, inquiry_id)

    async def create(self, inquiry: Inquiry) -> Inquiry:
        self.db.add(inquiry)
        await self.db.flush()
        await self.db.refresh(inquiry)
        return inquiry

    async def update_status(self, inquiry_id: int, status: str) -> Inquiry | None:
        inquiry = await self.db.get(Inquiry, inquiry_id)
        if inquiry:
            inquiry.status = status
            await self.db.flush()
            await self.db.refresh(inquiry)
        return inquiry
