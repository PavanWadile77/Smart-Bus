import os
import sys
import json
import firebase_admin
from firebase_admin import credentials, firestore

def init_firebase():
    if not firebase_admin._apps:
        cred_path = os.path.join(os.path.dirname(__file__), 'serviceAccountKey.json')
        if os.path.exists(cred_path):
            cred = credentials.Certificate(cred_path)
            firebase_admin.initialize_app(cred)
            return firestore.client()
        else:
            print(f"[WARN] No Firebase credentials found. Mocking upload.")
            return None
    return firestore.client()

def clear_collection(db, collection_name):
    docs = db.collection(collection_name).limit(100).stream()
    deleted = 0
    for doc in docs:
        doc.reference.delete()
        deleted += 1
    if deleted >= 100:
        clear_collection(db, collection_name)

def generate_mock_msrtc_data():
    """Generates the multi-collection MSRTC schema"""
    
    # 1. Stops
    stops_data = {
        "stop_swargate": {"stop_id": "stop_swargate", "stopName": "Swargate", "latitude": 18.5018, "longitude": 73.8584, "sequence": 1, "routeId": "route_pune_mumbai"},
        "stop_katraj": {"stop_id": "stop_katraj", "stopName": "Katraj", "latitude": 18.4533, "longitude": 73.8582, "sequence": 2, "routeId": "route_pune_mumbai"},
        "stop_bharati": {"stop_id": "stop_bharati", "stopName": "Bharati Vidyapeeth", "latitude": 18.4575, "longitude": 73.8508, "sequence": 3, "routeId": "route_pune_mumbai"},
        "stop_navale": {"stop_id": "stop_navale", "stopName": "Navale Bridge", "latitude": 18.4497, "longitude": 73.8219, "sequence": 4, "routeId": "route_pune_mumbai"}
    }
    
    # 2. Routes
    routes_data = {
        "route_pune_mumbai": {
            "route_id": "route_pune_mumbai",
            "routeName": "Pune -> Mumbai Express",
            "source": "Swargate",
            "destination": "Mumbai Central",
            "totalStops": 4,
            "totalDistance": 150.5,
            "updatedAt": "TIMESTAMP"
        }
    }
    
    # 3. Buses (Live Status)
    buses_data = {
        "MH12-1234": {
            "busNumber": "MH12-1234",
            "currentStop": "Swargate",
            "nextStop": "Katraj",
            "eta": "3 min",
            "status": "LIVE",
            "speed": 0.0,
            "heading": 0.0,
            "occupancy": "65%",
            "routeId": "route_pune_mumbai",
            "timestamp": "TIMESTAMP"
        }
    }
    
    # 4. Schedules
    schedules_data = {
        "sch_1": {
            "tripId": "trip_101",
            "busNumber": "MH12-1234",
            "departureTime": "08:00",
            "runningDays": ["Mon", "Tue", "Wed", "Thu", "Fri"]
        }
    }
    
    return {
        "routes": routes_data,
        "stops": stops_data,
        "buses": buses_data,
        "schedules": schedules_data
    }

def main(pdf_path=None):
    db = init_firebase()
    
    if pdf_path:
        print(f"Extracting data from {pdf_path} (simulated)...")
    else:
        print("No PDF path provided. Using default mock generator.")
        
    seed_data = generate_mock_msrtc_data()
    
    if db:
        print("Clearing old data...")
        clear_collection(db, "routes")
        clear_collection(db, "stops")
        # We might not clear buses if we want to keep fleet config, 
        # but the prompt said "Delete old route data, Update Bus sequence"
        clear_collection(db, "schedules")
        
        print("Uploading new data to Firestore...")
        for col, docs in seed_data.items():
            for doc_id, data in docs.items():
                if "updatedAt" in data and data["updatedAt"] == "TIMESTAMP":
                    data["updatedAt"] = firestore.SERVER_TIMESTAMP
                if "timestamp" in data and data["timestamp"] == "TIMESTAMP":
                    data["timestamp"] = firestore.SERVER_TIMESTAMP
                    
                db.collection(col).document(doc_id).set(data)
        print("Data refresh complete!")
    else:
        print("Firebase not initialized. Printing seed data:")
        print(json.dumps(seed_data, indent=2))

if __name__ == "__main__":
    pdf = sys.argv[1] if len(sys.argv) > 1 else None
    main(pdf)
