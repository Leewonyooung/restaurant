"""
author: 박상범
Description: 
Fixed: 2024.09.26.
Usage: 맛집 Delete
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
