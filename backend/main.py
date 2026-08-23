from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import models
from database import engine
from routes import router

# Create DB tables
models.Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="SmartBus Live Tracking API",
    description="API for Hackathon Prototype: Automatic ETIM-Based Live Bus Tracking",
    version="1.0.0"
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routes
app.include_router(router)

@app.get("/health", tags=["Health"])
def health_check():
    return {"status": "healthy"}
