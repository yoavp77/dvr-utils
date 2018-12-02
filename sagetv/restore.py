#!/bin/env python
from requests import get
from json import dumps, loads, load
import sys

try:
  infile = sys.argv[2]
  cfg = load(open(sys.argv[1],"r"))
  ip = cfg["server_ip"]
  user = cfg["user"]
  password = cfg["password"]
except:
  print "usage: {cmd} <config> <backup-file>".format(cmd=sys.argv[0])
  print ""
  print "where config looks like:"
  print ' {"user": "USERNAME", "password": "PASSWORD", "server_ip": "IPADDRESS", "server_port": "8080"}'
  sys.exit(0)

params = {"c": "backup:ClearChannels", "encoder": "json"}
response = get("http://{ip}:{port}/sagex/api".format(ip=ip,port=cfg["server_port"]),auth=(user,password),params=params)

epg = []
with open(infile,"r") as fin:
  for line in fin:
    epg.append(loads(line))

channel = 0
for channel in epg:
  try:
    network = channel["Network"]
  except:
    network = ""
  params = {"c": "backup:RestoreChannels", "encoder": "json"}
  params["1"] = channel["CallSign"]
  params["2"] = channel["Description"]
  params["3"] = network
  params["4"] = int(channel["StationID"])
  params["5"] = channel["Number"]
  params["6"] = channel["Physical"]
  try:
    response = get("http://{ip}:{port}/sagex/api".format(ip=ip,port=cfg["server_port"]),auth=(user,password),params=params)
  except:
    print traceback.format_exc()
  print "status:", response.status_code, dumps(params)
