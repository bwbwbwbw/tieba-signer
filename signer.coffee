global.UA = 'Mozilla/5.0 (Linux; U; Android 2.3.5; zh-cn; MI-ONE Plus Build/GINGERBREAD) AppleWebKit/533.1 (KHTML, like Gecko) FlyFlow/2.4 Version/4.0 Mobile Safari/533.1 baidubrowser/042_1.8.4.2_diordna_458_084/imoaiX_01_5.3.2_sulP-ENO-IM/100028m'

request = require 'request'
global.jar = request.jar()

global.request = request.defaults jar:jar
global.$ = require 'jquery'

require './config.coffee'
require './utils.coffee'

async = require 'async'

if Config.Cookie?
    Utils.AddCookie Config.Cookie

######################################

async.waterfall [
    Utils.RequestHomepage, 
    Utils.RequestLoginpage, 
    Utils.Login,
    Utils.QueryFavorite,
    Utils.SignList
]