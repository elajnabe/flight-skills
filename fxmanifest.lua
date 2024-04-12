fx_version "cerulean"
game "gta5"
lua54 "yes"

client_scripts {
    "client.lua",
}

shared_script '@ox_lib/init.lua'

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "config.lua",
    "server.lua",
}
