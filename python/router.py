from fastapi import FastAPI

from delete import router as delete_router
from update import router as update_router
from create import createrouter as create_router
from read import readrouter as read_router



app = FastAPI()
app.include_router(delete_router, prefix="/delete", tags=["delete"])
app.include_router(update_router, prefix="/update", tags=["update"])
app.include_router(create_router, prefix="/insert", tags=["insert"])
app.include_router(read_router, prefix="/read", tags=["read"])
app.include_router(read_router, prefix="/image", tags=["image"])


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host = "127.0.0.1", port = 8000)