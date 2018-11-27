#!/bin/env python
from requests import get
from json import dumps, load
import sys

try:
  cfg = load(open(sys.argv[1],"r"))
  ip = cfg["server_ip"]
  user = cfg["user"]
  password = cfg["password"]
except:
  print "usage: {cmd} <config>".format(cmd=sys.argv[0])
  print ""
  print "where config looks like:"
  print ' {"user": "USERNAME", "password": "PASSWORD", "server_ip": "IPADDRESS", "server_port": "8080"}'
  sys.exit(0)

counter = 0
params = {"c": "backup:GetChannels", "encoder": "json"}
response = get("http://{ip}:{port}/sagex/api".format(ip=ip,port=cfg["server_port"]),auth=(user,password),params=params)
for channel in response.json()["Result"]:
  if response.json()["Result"][channel]["Viewable"]:
    counter += 1
    print dumps(response.json()["Result"][channel])
    #print "ch:{counter} station:{station} epg:{epg} logical:{logical} physical:{physical}".format(
          #counter=counter,
          #station=response.json()["Result"][channel]["Name"],
          #epg=response.json()["Result"][channel]["StationID"],
          #logical=response.json()["Result"][channel]["Number"],
          #physical=response.json()["Result"][channel]["Physical"],
          #)
