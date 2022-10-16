----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

fx_version 'adamant'

game 'gta5'

author 'case#1993'

description 'BOII | Development - Utility; Money Launderer'

version '1.0.0'

lua54 'yes'

server_scripts {
    'server/*'
}
client_scripts {
    'client/*'
}
shared_scripts {
    'shared/*'
}
escrow_ignore {
    'server/*',
    'client/*',
    'shared/*'
}