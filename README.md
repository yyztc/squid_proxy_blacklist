# squid_proxy_blacklist

script to reject malware websites.

マルウェアサイトのドメインを拒否する設定をSquidに入れる。

## Settings

Create blacklist.txt for writable.
```
chmod 666 /etc/squid/blacklist.txt
```

Copy files anywhere with execute permission. example)
```
chmod 755 /opt/proxy_blacklist/eliminate_overlap_name.pl
chmod 755 /opt/proxy_blacklist/update_proxy_blacklist.sh
```

Add acl in squid.conf
```
acl blacklist dstdomain "/etc/squid/blacklist.txt"
http_access deny blacklist
```

Set the script to run on cron.
```
1 2 * * * /opt/proxy_blacklist/update_proxy_blacklist.sh > /dev/null 2>&1
```

Set squid reload to run on cron. (root)
```
11 2 * * * service squid reload
```

