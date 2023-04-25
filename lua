#!/bin/sh

LUAROCKS_SYSCONFDIR='/usr/local/etc/luarocks' exec '/usr/bin/lua5.3' -e 'package.path="/home/rfm/.luarocks/share/lua/5.3/?.lua;/home/rfm/.luarocks/share/lua/5.3/?/init.lua;/usr/local/share/lua/5.3/?.lua;/usr/local/share/lua/5.3/?/init.lua;"..package.path;package.cpath="/home/rfm/.luarocks/lib/lua/5.3/?.so;/usr/local/lib/lua/5.3/?.so;"..package.cpath' $([ "$*" ] || echo -i) "$@"
