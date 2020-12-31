require 'system'

systems = [
    [ "S5B", "admin", "cmb9.admin", "CY", "a8:1e:84:73:b9:bd" ],
    [ "S5B", "admin", "cmb9.admin", "CY", "a8:1e:84:a2:29:d2" ],
    [ "S5BQ", "admin", "cmb9.admin", "", "a8:1e:84:96:8a:de" ],
    [ "S5D", "admin", "cmb9.admin", "", "a8:1e:84:7e:2b:f1" ],
    [ "S5S", "admin", "cmb9.admin", "CY", "a8:1e:84:a2:cc:fb" ],
    [ "S5T", "admin", "cmb9.admin", "SFC", "a8:1e:84:fa:a0:47" ],
    [ "S2BP", "admin", "admin", "", "2c:60:0c:52:24:5b" ],
    [ "S2PH", "admin", "admin", "", "2c:60:0c:cd:29:98" ],
    [ "S5P", "admin", "admin", "CY", "2c:60:0c:bc:24:81" ],
    [ "S5HF_Left", "dropbox", "hhnFlaw5", "David's DBX Support", "a8:1e:84:fa:62:14" ],
    [ "S5HF_Right", "dropbox", "hhnFlaw5", "David's DBX Support", "a8:1e:84:fa:63:70" ],
    [ "S5G", "admin", "cmb9.admin", "", "d8:c4:97:17:6e:ef" ],
    [ "S2S", "admin", "admin", "", "a8:1e:84:37:15:c8" ],
    [ "S5BE", "admin", "cmb9.admin", "CY", "d8:c4:97:b5:93:87" ],
    [ "S2B", "admin", "admin", "", "2c:60:0c:98:90:81" ],
    [ "S5KL", "admin", "adminadmin", "KB System", "b4:a9:fc:59:67:0d" ],
    [ "S2S", "admin", "admin", "CY", "a8:1e:84:37:15:7e" ],
    [ "S5P", "admin", "cmb9.admin", "Jesse", "b4:a9:fc:82:26:86" ],
    [ "S5T", "admin", "cmb9.admin", "Joe Customer", "b4:a9:fc:a8:ff:5d" ]
]

systems.each do | model, user, pass, comments, mac | 
    System.create(model: model, username: user, password: pass, comments: comments, bmc_mac: mac)
end