from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
import schemas
import crud
import utils
from database import get_db

router = APIRouter(prefix="/api", tags=["bus"])

@router.post("/bus/location", response_model=schemas.BusLocationResponse)
def update_location(location: schemas.BusLocationCreate, db: Session = Depends(get_db)):
    if not utils.validate_coordinates(location.latitude, location.longitude):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid GPS coordinates. Latitude must be between -90 and 90, Longitude between -180 and 180."
        )
    try:
        return crud.update_bus_location(db, location)
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

@router.get("/bus/{bus_id}/location", response_model=schemas.BusLocationResponse)
def read_bus_location(bus_id: str, db: Session = Depends(get_db)):
    db_location = crud.get_bus_location(db, bus_id)
    if db_location is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Bus location not found")
    return db_location

@router.get("/buses/live", response_model=List[schemas.BusLocationResponse])
def read_live_buses(db: Session = Depends(get_db)):
    return crud.get_live_buses(db)
