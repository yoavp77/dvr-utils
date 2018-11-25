#!/bin/env python
from requests import get
from json import dumps, load
import sys

def cfg(filename):
  with open(filename,"r") as fin:
    cfg = load(fin)
  return cfg

try:
  cfg = cfg(sys.argv[1])
except:
  print "usage: {cmd} <config>".format(cmd=sys.argv[0])
  print ""
  print "where config looks like:"
  print ' {"user": "USERNAME", "password": "PASSWORD", "server_ip": "IPADDRESS", "server_port": "8080"}'
  sys.exit(0)

ip = cfg["server_ip"]
user = cfg["user"]
password = cfg["password"]
counter = 0
response = get("http://{ip}:{port}/sagex/api".format(ip=ip,port=cfg["server_port"]),auth=(user,password),params={"c": "GetAllLineups", "encoder": "json"})
if response.status_code == 200:
  lineup_name = response.json()["Result"][0]
  params = {"c": "GetChannelsOnLineup",
            "encoder": "json",
            "1": lineup_name,
            "size": 9999}
  lineup_response = get("http://{ip}:{port}/sagex/api".format(ip=ip,port=cfg["server_port"]),auth=(user,password),params=params)
  if lineup_response.status_code == 200:
    lineup_channels = lineup_response.json()
    for lineup_channel in lineup_channels["Result"]:
      counter += 1
      if lineup_channel["IsChannelViewable"]:
        print "ch:{counter} station:{station} epg:{epg} logical:{logical} physical:{physical}".format(
               counter=counter,
               station=lineup_channel["ChannelName"],
               epg=lineup_channel["StationID"],
               logical=lineup_channel["ChannelNumber"],
               physical=lineup_channel["StationID"]
               )
