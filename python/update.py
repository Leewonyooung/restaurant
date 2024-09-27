"""
author: 박상범
Description: 
Fixed: 2024.09.26.
Usage: 맛집 Update
"""

from fastapi import APIRouter
import pymysql

router = APIRouter()

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
async def update(
    category_id : str =None,
    name : str =None,
    latitude : str =None,
    longitude : str =None,
    phone : str =None,
    represent : str =None,
    memo : str =None,
    favorite : str =None,
    seq : str = None,
    user_seq : str = None,
    ):
    conn = connect()
    curs = conn.cursor()

    try:
        sql = "update restaurant set category_id=%s, name=%s, latitude=%s, longitude=%s, phone=%s, represent=%s, memo=%s, favorite=%s where seq=%s AND user_seq=%s"
        curs.execute(sql, (category_id, name, latitude, longitude, phone, represent, memo, favorite, seq, user_seq))
        conn.commit()
        conn.close()
        return {"result" : "OK"}
    
    except Exception as e:
        conn.close()
        print("Error :",e)
        return {"result" : "Error"}
    

@router.get("/all")
async def insert( 
    seq: str=None,
   category_id: str=None, 
   user_seq: str=None, 
   name:str=None, 
   latitude:str=None, 
   longitude: str=None, 
   image:str=None, 
   phone:str=None, 
   represent:str=None, 
   memo:str=None, 
   favorite:str=None
):
    conn = connect()
    curs = conn.cursor()
    try:
        sql = "update restaurant set category_id=%s, name=%s, latitude=%s, longitude=%s, image=%s, phone=%s, represent=%s, memo=%s, favorite=%s where seq=%s AND user_seq=%s"
        curs.execute(sql, (category_id, name, latitude, longitude, image, phone, represent, memo, favorite, seq, user_seq))
        conn.commit()
        conn.close()

        return {"result" : "OK"}        
    except Exception as e:
        conn.close()
        print("Error :",e)
        return {"result" : "Error"}