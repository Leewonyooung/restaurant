"""
author: 한재영, 박상범
Description: 
Fixed: 2024.09.26.
Usage: 서버로 이미지 업로드
"""

from fastapi import APIRouter, File, UploadFile
from fastapi.responses import FileResponse
import pymysql
import os
import shutil

router = APIRouter()

UPLOAD_FOLDER = 'uploads'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)



def connect():
    conn = pymysql.connect(
        host = "192.168.50.147", 
        user = "root",
        password = "qwer1234",
        db = "musteat",
        charset= 'utf8'
    )
    return conn


@router.get("/")
async def delete(seq : str = None, user_seq:str = None):
    conn = connect()
    curs = conn.cursor()

    try:
        sql = "delete from restaurant where seq=%s AND user_seq=%s"
        curs.execute(sql, (seq, user_seq))
        conn.commit()
        conn.close()
        return {"result" : "OK"}
    
    except Exception as e:
        conn.close()
        print("Error :",e)
        return {"result" : "Error"}
    

@router.post("/upload")
async def upload_file(file : UploadFile = File(...)):

    try:
        file_path = os.path.join(UPLOAD_FOLDER, file.filename)
        with open(file_path, "wb") as buffer: ## "wb" : write binarry
            shutil.copyfileobj(file.file, buffer)
        return{'result' : 'OK'}

    except Exception as e:
        print("Error:", e)
        return({"reslut" : "Error"})


@router.get("/view/{file_name}")
async def get_file(file_name: str):
    file_path = os.path.join(UPLOAD_FOLDER, file_name)
    if os.path.exists(file_path):
        return FileResponse(path=file_path, filename=file_name)
    return {'result' : 'Error'}

@router.delete("/deleteFile/{file_name}")
async def delete_file(file_name : str):
    try:
        file_path = os.path.join(UPLOAD_FOLDER, file_name)
        if os.path.exists(file_path):
            os.remove(file_path)
        return {"result" : "OK"}
    except Exception as e:
        print("Error:", e)
        return {"result" : "Error"}




