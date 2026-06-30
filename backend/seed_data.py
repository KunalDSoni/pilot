import asyncio

from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker

from app.core.config import settings
from app.core.database import Base
from app.core.security import hash_password
from app.models import Brand, Car, CarColor, CarVariant, Dealer, User

engine = create_async_engine(settings.DATABASE_URL, echo=True)
async_session = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)


async def seed():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    async with async_session() as session:
        admin = User(
            name="Admin",
            email="admin@carai.com",
            password_hash=hash_password("admin123"),
            role="admin",
        )
        session.add(admin)

        brands_data = [
            Brand(name="Maruti Suzuki", country="India", founded_year=1981),
            Brand(name="Hyundai", country="South Korea", founded_year=1967),
            Brand(name="Tata Motors", country="India", founded_year=1945),
            Brand(name="Mahindra", country="India", founded_year=1945),
            Brand(name="Toyota", country="Japan", founded_year=1937),
            Brand(name="Honda", country="Japan", founded_year=1948),
            Brand(name="Kia", country="South Korea", founded_year=1944),
            Brand(name="BMW", country="Germany", founded_year=1916),
            Brand(name="Mercedes-Benz", country="Germany", founded_year=1926),
            Brand(name="Audi", country="Germany", founded_year=1909),
        ]

        for brand in brands_data:
            session.add(brand)

        await session.flush()

        cars_data = [
            Car(
                brand_id=brands_data[0].id,
                name="Swift",
                year=2024,
                body_type="Hatchback",
                fuel_type="petrol",
                transmission_type="manual",
                engine="1.2L Petrol",
                mileage=23.0,
                seating_capacity=5,
                min_price=599000,
                max_price=949000,
            ),
            Car(
                brand_id=brands_data[0].id,
                name="Baleno",
                year=2024,
                body_type="Hatchback",
                fuel_type="petrol",
                transmission_type="manual",
                engine="1.2L Petrol",
                mileage=22.0,
                seating_capacity=5,
                min_price=699000,
                max_price=1049000,
            ),
            Car(
                brand_id=brands_data[1].id,
                name="Creta",
                year=2024,
                body_type="SUV",
                fuel_type="petrol",
                transmission_type="automatic",
                engine="1.5L Petrol",
                mileage=17.0,
                seating_capacity=5,
                min_price=1099000,
                max_price=1999000,
            ),
            Car(
                brand_id=brands_data[2].id,
                name="Nexon",
                year=2024,
                body_type="SUV",
                fuel_type="petrol",
                transmission_type="manual",
                engine="1.2L Turbo Petrol",
                mileage=17.0,
                seating_capacity=5,
                min_price=799000,
                max_price=1549000,
            ),
            Car(
                brand_id=brands_data[2].id,
                name="Harrier",
                year=2024,
                body_type="SUV",
                fuel_type="diesel",
                transmission_type="automatic",
                engine="2.0L Diesel",
                mileage=16.0,
                seating_capacity=5,
                min_price=1599000,
                max_price=2649000,
            ),
            Car(
                brand_id=brands_data[4].id,
                name="Camry",
                year=2024,
                body_type="Sedan",
                fuel_type="hybrid",
                transmission_type="automatic",
                engine="2.5L Hybrid",
                mileage=25.0,
                seating_capacity=5,
                min_price=4699000,
                max_price=4899000,
            ),
        ]

        for car in cars_data:
            session.add(car)

        await session.flush()

        variants_data = [
            CarVariant(
                car_id=cars_data[0].id,
                name="LXi",
                price=599000,
                fuel_type="petrol",
                transmission_type="manual",
                mileage=23.0,
            ),
            CarVariant(
                car_id=cars_data[0].id,
                name="VXi",
                price=719000,
                fuel_type="petrol",
                transmission_type="manual",
                mileage=23.0,
            ),
            CarVariant(
                car_id=cars_data[0].id,
                name="ZXi",
                price=849000,
                fuel_type="petrol",
                transmission_type="manual",
                mileage=22.5,
            ),
            CarVariant(
                car_id=cars_data[0].id,
                name="ZXi+",
                price=949000,
                fuel_type="petrol",
                transmission_type="automatic",
                mileage=20.0,
            ),
        ]

        for variant in variants_data:
            session.add(variant)

        await session.flush()

        colors_data = [
            CarColor(variant_id=variants_data[0].id, name="Pearl Arctic White", hex_code="#F5F5F5"),
            CarColor(variant_id=variants_data[0].id, name="Magma Grey", hex_code="#6B6B6B"),
            CarColor(variant_id=variants_data[0].id, name="Fire Red", hex_code="#CC0000"),
            CarColor(variant_id=variants_data[1].id, name="Pearl Arctic White", hex_code="#F5F5F5"),
            CarColor(variant_id=variants_data[1].id, name="Splash Blue", hex_code="#0044CC"),
            CarColor(variant_id=variants_data[2].id, name="Magma Grey", hex_code="#6B6B6B"),
            CarColor(variant_id=variants_data[2].id, name="Sizzling Red", hex_code="#E60000"),
            CarColor(variant_id=variants_data[3].id, name="Pearl Arctic White", hex_code="#F5F5F5"),
            CarColor(variant_id=variants_data[3].id, name="Midnight Black", hex_code="#1A1A1A"),
        ]

        for color in colors_data:
            session.add(color)

        dealers_data = [
            Dealer(name="Premium Motors", city="Mumbai", phone="+912212345678", rating=4.5),
            Dealer(name="City Auto", city="Delhi", phone="+911198765432", rating=4.2),
            Dealer(name="Royal Cars", city="Bangalore", phone="+918012345678", rating=4.7),
        ]

        for dealer in dealers_data:
            session.add(dealer)

        await session.commit()
        print("Seed data inserted successfully!")


if __name__ == "__main__":
    asyncio.run(seed())
