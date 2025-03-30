from app import app
import sys
import psycopg2

db_connection = psycopg2.connect(
        dbname='fleetManagementSystem',
        user='postgres',
        password='1234',
        host='127.0.0.1'
    )

def spcall(qry, param, commit=False):
    try:
        cursor = db_connection.cursor()
        cursor.callproc(qry, param)
        res = cursor.fetchall()
        if commit:
            db_connection.commit()
        return res
    except:       
        res = [("Error: " + str(sys.exc_info()[0]) +
                " " + str(sys.exc_info()[1]),)]
        db_connection.rollback()
        return res

@app.route('/worker_location', methods=['GET'])
def worker_location():
    res = spcall('fetch_worker_location', param=None)
    print(res)
    return res