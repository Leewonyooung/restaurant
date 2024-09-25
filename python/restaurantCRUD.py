"""
author: 이원영
Description: 
Date: 2024.09.25.
Usage: 맛집 Create(Insert)
"""
from fastapi import FastAPI, File, UploadFile
from fastapi.responses import FileResponse
import pymysql, os, shutil

app = FastAPI()

UPLOAD_FOLDER = 'uploads'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)


def connect():
    conn = pymysql.connect(
        host="127.0.0.1",
        user="root",
        password="qwer1234",
        db="musteat",
        charset="utf8"
    )
    return conn

@app.get("/insert")
async def insert(categoryId: str=None, userSeq: str=None, name:str=None, latitude:str=None, longitude: str=None, image:str=None, phone:str=None, represent:str=None, memo:str=None, favorite:str=None):
    conn = connect()
    curs = conn.cursor()
    try:
        sql = "insert into restaurant(category_id,user_seq,name,latitude,longitude,image,phone,represent,memo,favorite) values(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"
        curs.execute(sql,(categoryId,userSeq,name,latitude,longitude,image,phone,represent,memo,favorite))
        conn.commit()
        conn.close()
        return {'result':'OK'}
    except Exception as e:
        conn.close()
        print("Error:", e)
        return{"results" : "Error"}


@app.get("/select")
async def select():
    conn = connect()
    curs = conn.cursor()
    try:
        sql = 'select seq, category_id,user_seq,name,latitude,longitude,image,phone,represent,memo,favorite from restaurant'
        curs.execute(sql)
        rows= curs.fetchall()
        conn.close()
        print(rows)
        return{'results': rows}
    except Exception as e:
        conn.close()
        print("Error:", e)
        return{"results" : "Error"}






if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)
