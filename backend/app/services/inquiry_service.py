from fastapi import HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.inquiry import Inquiry
from app.repositories.inquiry_repo import InquiryRepository
from app.schemas.inquiry import (
    InquiryCreate,
    InquiryListResponse,
    InquiryResponse,
)


class InquiryService:
    def __init__(self, db: AsyncSession):
        self.repo = InquiryRepository(db)

    async def create_inquiry(
        self, user_id: int, data: InquiryCreate
    ) -> InquiryResponse:
        inquiry = Inquiry(
            user_id=user_id,
            variant_id=data.variant_id,
            dealer_id=data.dealer_id,
            message=data.message,
        )
        inquiry = await self.repo.create(inquiry)
        return InquiryResponse.model_validate(inquiry)

    async def list_user_inquiries(
        self, user_id: int, page: int = 1, page_size: int = 20
    ) -> InquiryListResponse:
        inquiries, total = await self.repo.get_by_user(
            user_id=user_id, page=page, page_size=page_size
        )
        return InquiryListResponse(
            items=[InquiryResponse.model_validate(i) for i in inquiries],
            total=total,
            page=page,
            page_size=page_size,
            total_pages=max(1, (total + page_size - 1) // page_size),
        )

    async def get_inquiry(self, inquiry_id: int, user_id: int) -> InquiryResponse:
        inquiry = await self.repo.get_by_id(inquiry_id)
        if not inquiry:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Inquiry not found",
            )
        if inquiry.user_id != user_id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not authorized to view this inquiry",
            )
        return InquiryResponse.model_validate(inquiry)
