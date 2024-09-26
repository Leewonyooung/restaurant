from fastapi import APIRouter
import uuid

loginrouter = APIRouter()

import pymysql

def connect():
    conn = pymysql.connect(
        host = "192.168.50.147", 
        user = "root",
        password = "qwer1234",
        db = "musteat",
        charset= 'utf8'
    )
    return conn


@loginrouter.get("/")
async def update():
    id = uuid.uuid1()
    conn = connect()
    curs = conn.cursor()
    try:
        sql = "insert into user(id) values(%s)"
        curs.execute(sql,(id))
        conn.commit()
        conn.close()
        return {'result':id}
    except Exception as e:
        conn.close()
        print("Error:", e)
        return{"results" : "Error"}
    
@loginrouter.get("/seq")
async def update(id : str):
    conn = connect()
    curs = conn.cursor()
    try:
        sql = "select seq from user where id =%s"
        curs.execute(sql,(id))
        rows= curs.fetchall()
        conn.commit()
        conn.close()
        print(rows)
        return {'result':rows}
    except Exception as e:
        conn.close()
        print("Error:", e)
        return{"results" : "Error"}