from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class BusLocationBase(BaseModel):
    latitude: float
    longitude: float
    speed: Optional[float] = None
    accuracy: Optional[float] = None
    timestamp: datetime

class BusLocationCreate(BusLocationBase):
    bus_id: str

class BusLocationResponse(BusLocationBase):
    id: int
    bus_id: str
    updated_at: datetime

    class Config:
        from_attributes = True
