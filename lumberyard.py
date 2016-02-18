#!/usr/bin/env python
import sys
import json
import argparse
import pyodbc
import re
import os

server = os.environ['LUMBERYARD_SERVER']
database = os.environ['LUMBERYARD_DB']
username = os.environ['LUMBERYARD_USER']
password = os.environ['LUMBERYARD_PASSWORD']

connString = 'DRIVER={FreeTDS};SERVER=' +  server + ';PORT=1433;DATABASE=' + database + ';UID=' + username + ';PWD=' + password
conn = pyodbc.connect(connString)

input = file(sys.argv[-1])
for line in input:
    INSERT = "INSERT INTO "
    COLUMNS = []
    VALUES = []

    if '"lumber":' in line:
        print("Chopping Wood...")
        match = re.search('"lumber":{.*:{[^};]*}}', line)
        lumber = (match.group(0)).replace('lumber: ', '')
        lumber = '{' + lumber + '}'
        lumber = json.loads(lumber)
        lumber = lumber["lumber"]
        for tableName, definition in lumber.iteritems():
            INSERT = INSERT + tableName
            for col, val in definition.iteritems():
                COLUMNS.append(col)
                VALUES.append(val)
        INSERT = INSERT + "(" + ','.join(COLUMNS) + ")"
        VALUES = ["'" + str(v) + "'" for v in VALUES]
        INSERT = INSERT + " VALUES (" + ','.join(VALUES) + ");"

        cursor = conn.cursor()
        cursor.execute(INSERT)
        cursor.commit()
        cursor.close()
conn.close()



