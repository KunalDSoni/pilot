from pydantic import BaseModel, Field

from app.schemas.brand import BrandResponse


class CarColorResponse(BaseModel):
    id: int
    name: str
    hex_code: str

    model_config = {"from_attributes": True}


class CarVariantResponse(BaseModel):
    id: int
    car_id: int
    name: str
    price: float
    fuel_type: str
    transmission_type: str
    mileage: float | None
    colors: list[CarColorResponse] | None = None

    model_config = {"from_attributes": True}


class CarCreate(BaseModel):
    brand_id: int
    name: str = Field(..., min_length=1, max_length=200)
    year: int = Field(..., ge=2000, le=2030)
    body_type: str = Field(..., min_length=1, max_length=50)
    fuel_type: str = Field(..., pattern=r"^(petrol|diesel|electric|hybrid|cng|lpg)$")
    transmission_type: str = Field(..., pattern=r"^(manual|automatic|cvt|dct)$")
    engine: str | None = None
    mileage: float | None = None
    seating_capacity: int | None = Field(None, ge=1, le=100)
    min_price: float | None = None
    max_price: float | None = None
    image_url: str | None = None


class CarResponse(BaseModel):
    id: int
    brand: BrandResponse
    name: str
    year: int
    body_type: str
    fuel_type: str
    transmission_type: str
    engine: str | None
    mileage: float | None
    seating_capacity: int | None
    min_price: float | None
    max_price: float | None
    image_url: str | None
    variants: list[CarVariantResponse] | None = None

    model_config = {"from_attributes": True}


class CarListResponse(BaseModel):
    items: list[CarResponse]
    total: int
    page: int
    page_size: int
    total_pages: int
