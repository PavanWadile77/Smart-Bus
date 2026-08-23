from sqlalchemy.orm import Session
from datetime import datetime
import models
import schemas

def get_bus_location(db: Session, bus_id: str):
    return db.query(models.BusLocation).filter(models.BusLocation.bus_id == bus_id).first()

def get_live_buses(db: Session):
    return db.query(models.BusLocation).all()

def update_bus_location(db: Session, location: schemas.BusLocationCreate):
    db_location = get_bus_location(db, location.bus_id)
    if db_location:
        db_location.latitude = location.latitude
        db_location.longitude = location.longitude
        db_location.speed = location.speed
        db_location.accuracy = location.accuracy
        db_location.timestamp = location.timestamp
        db_location.updated_at = datetime.utcnow()
    else:
        db_location = models.BusLocation(
            bus_id=location.bus_id,
            latitude=location.latitude,
            longitude=location.longitude,
            speed=location.speed,
            accuracy=location.accuracy,
            timestamp=location.timestamp
        )
        db.add(db_location)
    db.commit()
    db.refresh(db_location)
    return db_location
