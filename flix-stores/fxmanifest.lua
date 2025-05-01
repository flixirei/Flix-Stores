fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author '.f_l_i_x.'
description 'Very simple and clean item selling script!'

client_scripts {
    'client/*.lua'
}

server_scripts  {
    'server/*.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua',
    'config/*.lua'
}
