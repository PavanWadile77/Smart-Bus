import os
import time
import math
import random
from datetime import datetime
import firebase_admin
from firebase_admin import credentials, firestore

def init_firebase():
    if not firebase_admin._apps:
        cred_path = os.path.join(os.path.dirname(__file__), 'serviceAccountKey.json')
        if os.path.exists(cred_path):
            cred = credentials.Certificate(cred_path)
            firebase_admin.initialize_app(cred)
            return firestore.client()
        return None
    return firestore.client()

def haversine_distance(lat1, lon1, lat2, lon2):
    R = 6371  # Earth radius in km
    dlat = math.radians(lat2 - lat1)
    dlon = math.radians(lon2 - lon1)
    a = (math.sin(dlat / 2) * math.sin(dlat / 2) +
         math.cos(math.radians(lat1)) * math.cos(math.radians(lat2)) *
         math.sin(dlon / 2) * math.sin(dlon / 2))
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    return R * c

def simulate():
    db = init_firebase()
    if not db:
        print("Simulator cannot run without Firestore access.")
        return

    print("Starting Phase 4 Simulator (Dynamic ETA Engine)...")
    
    # Pre-cache stops to avoid excessive reads
    stops_cache = {}
    stops_docs = db.collection("stops").get()
    for stop in stops_docs:
        stops_cache[stop.id] = stop.to_dict()

    while True:
        try:
            buses = db.collection("buses").get()
            
            for bus_doc in buses:
                bus = bus_doc.to_dict()
                route_id = bus.get("routeId")
                current_stop_name = bus.get("currentStop")
                
                if not route_id: continue
                
                # Fetch route stops (ordered by sequence)
                route_stops = [s for s in stops_cache.values() if s.get("routeId") == route_id]
                route_stops.sort(key=lambda x: x.get("sequence", 0))
                
                if not route_stops: continue
                
                # Find current index
                current_idx = 0
                for i, s in enumerate(route_stops):
                    if s["stopName"] == current_stop_name:
                        current_idx = i
                        break
                        
                # Move forward
                next_idx = current_idx + 1
                if next_idx >= len(route_stops):
                    # End of route reached, restart for simulation purposes
                    current_idx = 0
                    next_idx = 1 if len(route_stops) > 1 else 0
                    
                cur_stop = route_stops[current_idx]
                nxt_stop = route_stops[next_idx]
                
                # GPS Interpolation (mocking progress 50% between stops for dynamic feel)
                fraction = 0.5
                lat1, lng1 = cur_stop["latitude"], cur_stop["longitude"]
                lat2, lng2 = nxt_stop["latitude"], nxt_stop["longitude"]
                
                current_lat = lat1 + (lat2 - lat1) * fraction
                current_lng = lng1 + (lng2 - lng1) * fraction
                
                # Dynamic ETA calculation (Remaining distance / Average speed)
                distance_km = haversine_distance(current_lat, current_lng, lat2, lng2)
                avg_speed = random.uniform(35, 45) # 35-45 km/h
                traffic_multiplier = random.uniform(1.0, 1.3)
                stop_delay = 1.0 # minute
                
                time_hours = distance_km / avg_speed
                eta_minutes = int(math.ceil(time_hours * 60 * traffic_multiplier + stop_delay))
                
                update_data = {
                    "currentStop": cur_stop["stopName"],
                    "nextStop": nxt_stop["stopName"],
                    "latitude": current_lat,
                    "longitude": current_lng,
                    "speed": round(avg_speed, 1),
                    "status": "Moving",
                    "eta": f"{eta_minutes} min",
                    "timestamp": firestore.SERVER_TIMESTAMP
                }
                
                db.collection("buses").document(bus_doc.id).update(update_data)
                print(f"[{datetime.now().strftime('%H:%M:%S')}] {bus_doc.id}: {cur_stop['stopName']} -> {nxt_stop['stopName']} ETA: {eta_minutes}m")
                
        except Exception as e:
            print(f"Error in simulator loop: {e}")
            
        time.sleep(15)

if __name__ == "__main__":
    simulate()
