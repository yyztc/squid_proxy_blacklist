import config
import os
import requests

base_url = "https://otx.alienvault.com/api/v1"
indicators = "{0}/indicators/export".format(base_url)

# Cannot seem to get this to work in VS Code. Fine in terminal however
#otx_api_key = os.environ.get("OTX_API_KEY")
otx_api_key = config.api_key

print(otx_api_key)

results = []
temp = []

# open hosts.txt from http://www.malwaredomainlist.com/hostslist/hosts.txt
with open('hosts.txt', 'r') as f:
    for line in f.readlines():
        if line.startswith('127.0.0.1'):
            parts = line.split()
            temp.append(parts[1])

# open domains.txt from https://winhelp2002.mvps.org/hosts.txt
with open('hosts_win.txt', 'r') as f:
    for line in f.readlines():
        if line.startswith('0.0.0.0'):
            parts = line.split()
            temp.append(parts[1])

# open domains.txt from https://winhelp2002.mvps.org/hosts.txt
with open('domains.txt', 'r') as f:
    for line in f.readlines():
        parts = line.split()
        if not parts[0].startswith('#'):
            temp.append(parts[0])

temp_sorted = sorted(set(temp))
for domain in temp_sorted:
    results.append(".{0}".format(domain))

with open("temp_blacklist.txt", mode='wt', encoding='utf-8') as myfile:
    myfile.write('\n'.join(results))

print(len(results))