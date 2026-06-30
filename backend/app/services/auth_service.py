from fastapi import HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.security import (
    create_access_token,
    create_refresh_token,
    hash_password,
    verify_password,
)
from app.models.user import User
from app.repositories.user_repo import UserRepository
from app.schemas.user import UserCreate, UserLogin, UserResponse, TokenResponse


class AuthService:
    def __init__(self, db: AsyncSession):
        self.repo = UserRepository(db)

    async def register(self, data: UserCreate) -> TokenResponse:
        exists = await self.repo.exists_by_email(data.email)
        if exists:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="Email already registered",
            )

        user = User(
            name=data.name,
            email=data.email,
            phone=data.phone,
            password_hash=hash_password(data.password),
        )
        user = await self.repo.create(user)

        tokens = self._generate_tokens(user)
        return TokenResponse(
            **tokens,
            user=UserResponse.model_validate(user),
        )

    async def login(self, data: UserLogin) -> TokenResponse:
        user = await self.repo.get_by_email(data.email)
        if not user or not verify_password(data.password, user.password_hash):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid email or password",
            )

        tokens = self._generate_tokens(user)
        return TokenResponse(
            **tokens,
            user=UserResponse.model_validate(user),
        )

    def _generate_tokens(self, user: User) -> dict:
        return {
            "access_token": create_access_token(
                {"sub": str(user.id), "role": user.role}
            ),
            "refresh_token": create_refresh_token({"sub": str(user.id)}),
        }
