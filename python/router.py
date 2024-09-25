from fastapi import FastAPI
from delete import router as delete_router
from update import router as update_router

app = FastAPI()
app.include_router(delete_router, prefix="/delete", tags=["delete"])
app.include_router(update_router, prefix="/update", tags=["update"])


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host = "127.0.0.1", port = 8000)