from fastapi import APIRouter

from app.api.v1.auth import router as auth_router
from app.api.v1.brands import router as brand_router
from app.api.v1.cars import router as car_router
from app.api.v1.inquiries import router as inquiry_router

api_router = APIRouter()
api_router.include_router(auth_router, prefix="/auth", tags=["auth"])
api_router.include_router(brand_router, prefix="/brands", tags=["brands"])
api_router.include_router(car_router, prefix="/cars", tags=["cars"])
api_router.include_router(inquiry_router, prefix="/inquiries", tags=["inquiries"])
