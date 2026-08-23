
def validate_coordinates(latitude: float, longitude: float) -> bool:
    if not (-90 <= latitude <= 90):
        return False
    if not (-180 <= longitude <= 180):
        return False
    return True
