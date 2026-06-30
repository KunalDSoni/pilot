from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.repositories.brand_repo import BrandRepository
from app.schemas.brand import BrandCreate, BrandResponse

router = APIRouter()


@router.get("/", response_model=list[BrandResponse])
async def list_brands(db: AsyncSession = Depends(get_db)):
    repo = BrandRepository(db)
    brands = await repo.get_all()
    return [BrandResponse.model_validate(b) for b in brands]


@router.post("/", response_model=BrandResponse, status_code=status.HTTP_201_CREATED)
async def create_brand(data: BrandCreate, db: AsyncSession = Depends(get_db)):
    repo = BrandRepository(db)
    brand = await repo.create(data)
    return BrandResponse.model_validate(brand)
