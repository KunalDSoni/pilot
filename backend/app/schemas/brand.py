from pydantic import BaseModel, Field


class BrandCreate(BaseModel):
    name: str = Field(..., min_length=1, max_length=100)
    logo_url: str | None = None
    country: str | None = None
    founded_year: int | None = Field(None, ge=1800, le=2030)


class BrandResponse(BaseModel):
    id: int
    name: str
    logo_url: str | None
    country: str | None
    founded_year: int | None

    model_config = {"from_attributes": True}
