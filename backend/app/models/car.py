from sqlalchemy import Float, ForeignKey, Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base


class Car(Base):
    __tablename__ = "cars"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    brand_id: Mapped[int] = mapped_column(ForeignKey("brands.id"), nullable=False)
    name: Mapped[str] = mapped_column(String(200), nullable=False)
    year: Mapped[int] = mapped_column(Integer, nullable=False)
    body_type: Mapped[str] = mapped_column(String(50), nullable=False)
    fuel_type: Mapped[str] = mapped_column(String(20), nullable=False)
    transmission_type: Mapped[str] = mapped_column(String(20), nullable=False)
    engine: Mapped[str | None] = mapped_column(String(100), nullable=True)
    mileage: Mapped[float | None] = mapped_column(Float, nullable=True)
    seating_capacity: Mapped[int | None] = mapped_column(Integer, nullable=True)
    min_price: Mapped[float | None] = mapped_column(Float, nullable=True)
    max_price: Mapped[float | None] = mapped_column(Float, nullable=True)
    image_url: Mapped[str | None] = mapped_column(String(500), nullable=True)

    brand = relationship("Brand", back_populates="cars")
    variants = relationship("CarVariant", back_populates="car", cascade="all, delete-orphan")


class CarVariant(Base):
    __tablename__ = "car_variants"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    car_id: Mapped[int] = mapped_column(ForeignKey("cars.id"), nullable=False)
    name: Mapped[str] = mapped_column(String(200), nullable=False)
    price: Mapped[float] = mapped_column(Float, nullable=False)
    fuel_type: Mapped[str] = mapped_column(String(20), nullable=False)
    transmission_type: Mapped[str] = mapped_column(String(20), nullable=False)
    mileage: Mapped[float | None] = mapped_column(Float, nullable=True)

    car = relationship("Car", back_populates="variants")
    colors = relationship("CarColor", back_populates="variant", cascade="all, delete-orphan")


class CarColor(Base):
    __tablename__ = "car_colors"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    variant_id: Mapped[int] = mapped_column(ForeignKey("car_variants.id"), nullable=False)
    name: Mapped[str] = mapped_column(String(50), nullable=False)
    hex_code: Mapped[str] = mapped_column(String(7), nullable=False)

    variant = relationship("CarVariant", back_populates="colors")
