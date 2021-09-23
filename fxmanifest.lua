fx_version "adamant"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game "rdr3"

ui_page('html/ui.html') 
client_scripts {
    'config.lua',
    'client.lua'
}
server_scripts {
    'config.lua',
    'server.lua'
}
files {
	'html/ui.html', 
    'html/style.css',
    'html/script.js',
    'html/bg.png'
}
