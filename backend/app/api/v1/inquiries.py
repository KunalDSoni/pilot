from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.core.deps import get_current_user
from app.models.user import User
from app.schemas.inquiry import InquiryCreate, InquiryListResponse, InquiryResponse
from app.services.inquiry_service import InquiryService

router = APIRouter()


@router.post("/", response_model=InquiryResponse, status_code=201)
async def create_inquiry(
    data: InquiryCreate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    service = InquiryService(db)
    return await service.create_inquiry(current_user.id, data)


@router.get("/", response_model=InquiryListResponse)
async def list_inquiries(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    service = InquiryService(db)
    return await service.list_user_inquiries(current_user.id, page, page_size)


@router.get("/{inquiry_id}", response_model=InquiryResponse)
async def get_inquiry(
    inquiry_id: int,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    service = InquiryService(db)
    return await service.get_inquiry(inquiry_id, current_user.id)
