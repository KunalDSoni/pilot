from datetime import datetime

from pydantic import BaseModel, Field


class InquiryCreate(BaseModel):
    variant_id: int
    dealer_id: int | None = None
    message: str | None = Field(None, max_length=1000)


class InquiryResponse(BaseModel):
    id: int
    user_id: int
    variant_id: int
    dealer_id: int | None
    status: str
    message: str | None
    created_at: datetime | None
    updated_at: datetime | None

    model_config = {"from_attributes": True}


class InquiryListResponse(BaseModel):
    items: list[InquiryResponse]
    total: int
    page: int
    page_size: int
    total_pages: int
