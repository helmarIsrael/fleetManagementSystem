from app import app
import sys
import psycopg2
import requests
from flask import request, jsonify


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

    # for r in res:
    #     coord1 = (r[1], r[2])   
    #     coord2 =    

    #     url = f"http://project-osrm.org/route/v1/driving/{coord1};{coord2}?overview=false"
    #     response = requests.get(url)

    #     if response.status_code == 200:
    #         data = response.json()
    #         if data['routes']:
    #             distance = data['routes'][0]['distance']  # in meters
    #             duration = data['routes'][0]['duration']  # in seconds
    #             print(f"Driving distance: {distance} meters")
    #             print(f"Estimated travel time: {duration/3600:.2f} hours")
    #             r.append(distance)
    #         else:
    #             print("No route found.")
    #     else:
    #         print(response.status_code)

    return res

@app.route('/client_location', methods=['GET'])
def client_location():
    res = spcall('fetch_client_location', param=None)

    # for r in res:
    #     coord1 = (r[1], r[2])   
    #     coord2 =    

    #     url = f"http://project-osrm.org/route/v1/driving/{coord1};{coord2}?overview=false"
    #     response = requests.get(url)

    #     if response.status_code == 200:
    #         data = response.json()
    #         if data['routes']:
    #             distance = data['routes'][0]['distance']  # in meters
    #             duration = data['routes'][0]['duration']  # in seconds
    #             print(f"Driving distance: {distance} meters")
    #             print(f"Estimated travel time: {duration/3600:.2f} hours")
    #             r.append(distance)
    #         else:
    #             print("No route found.")
    #     else:
    #         print(response.status_code)

    return res

@app.route('/client_worker_distance', methods=['POST'])
def client_worker_distance():
    data = request.get_json()
    latitude = data['latitude']
    longitude = data['longitude']
    res = spcall('fetch_worker_location', param=None)

    worker_distances = []

    for r in res:
        coord1 = r[1], r[2]

        url = f"http://router.project-osrm.org/route/v1/driving/{coord1[1]},{coord1[0]};{longitude},{latitude}?overview=false"
        print(url)
        response = requests.get(url)

        if response.status_code == 200:
            data = response.json()
            if data['routes']:
                distance = data['routes'][0]['distance']  # in meters
                duration = data['routes'][0]['duration']  # in seconds
                # print(f"Driving distance: {distance} meters")
                # print(f"Estimated travel time: {duration/3600:.2f} hours")

                worker_distances.append({
                    'worker_id': r[0],
                    'distance': distance
                })
            
            else:
                print("No route found.")
        else:
            print(response.json())

    top_3 = sorted(worker_distances, key=lambda x: x['distance'])[:3]

    return jsonify({"status": "success", "data": top_3})
