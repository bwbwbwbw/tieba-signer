url = require 'url'
querystring = require 'querystring'

error_map = 

    1101:   '亲，你之前已经签过了'
    1001:   '未知错误，请重新试一下'
    1002:   '服务器开小差了，再签一次试试~'
    1003:   '服务器打盹了，再签一次叫醒它'
    1006:   '未知错误，请重新试一下'
    1007:   '服务器打瞌睡了，再签一次敲醒它'
    1010:   '签到太频繁了点，休息片刻再来吧：）'
    1011:   '未知错误，请重试'
    1023:   '未知错误，请重试'
    1027:   '未知错误，请重试'
    9000:   '未知错误，请重试'
    1012:   '贴吧目录出问题啦，请到贴吧签到吧反馈'
    1100:   '零点时分，赶在一天伊始签到的人好多，亲要不等几分钟再来签吧~'
    1102:   '你签得太快了，先看看贴子再来签吧：）'
    9:      '你在本吧被封禁不能进行当前操作'
    4:      '请您登陆以后再签到哦~'

Iconv = require('iconv').Iconv
gbk_to_utf8_iconv = new Iconv 'GBK', 'UTF-8//TRANSLIT//IGNORE'




request_last = null
_request = (data, callback) ->

    data.headers = [] if not data.headers?
    data.headers['user-agent'] = UA if not data.ua? or data.ua isnt false
    data.headers['referer'] = request_last if request_last?
    data.headers['host'] = url.parse(data.uri).hostname
    data.headers['origin'] = 'http://' + data.headers['host']
    data.headers['accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    data.headers['accept-language'] = 'zh-CN,zh;q=0.8'
    data.headers['cache-control'] = 'max-age=0'

    request_last = data.uri
    request data, callback


getFid = (body) ->

    body.match(/"fid"\s*?:\s*?"(\d+)"/)[1]

getTbs = (body) ->

    body.match(/"tbs"\s*?:\s*?"(\w+)"/)[1]


if (Config.Mail.Enabled)

    nodemailer = require 'nodemailer'

    transport = nodemailer.createTransport 'SMTP',
        secureConnection:   Config.Mail.Secure
        host:               Config.Mail.Server
        port:               Config.Mail.Port
        auth:
            user:           Config.Mail.User
            pass:           Config.Mail.Pass

failedSign = []





Utils = global.Utils =
    
    # Parse and add cookie from REQUEST cookie header
    AddCookie: (cstr) ->

        cookies = cstr.split ';'

        cookies.forEach (cookie) ->

            cookie = cookie.trim() + '; path=/; domain=.baidu.com'
            jar.add request.cookie(cookie)

    RequestHomepage: (callback) ->

        console.log '[Initializing] Request home page'

        _request(

            uri:    'http://wapp.baidu.com'
            ua:     false
            method: 'GET'

        (e, r, body) ->

            if body.indexOf('我的i贴吧') > -1

                # Already logged in?

                callback null, {skip: true}

            else

                loginURI = 'http://wappass.baidu.com/passport/?login'

                $body = $ body
                $body.find('a[href]').each ->

                    if $(this).html() is '登录'
                        loginURI = $(this).attr 'href'
                        false

                callback null, {uri: loginURI, skip: false}

        )

    RequestLoginpage: (data, callback) ->

        if data.skip
            callback null, {skip: true}
            return

        console.log '[Initializing] Request login page: ', data.uri

        _request(

            uri:    data.uri
            ua:     false
            method: 'GET'

        (e, r, body) ->

            data = {}

            $body = $ body
            $body.find('form[action="/passport/login"]').find('input[name]').each ->

                key = $(@).attr 'name'
                data[key] = $(@).attr 'value' if key.length > 0

            [data.username, data.password] = [Config.User, Config.Pass]

            callback null, {form: data, skip: false}

        )

    Login: (data, callback) ->

        if data.skip
            callback null
            return

        console.log '[Loging]'

        _request(

            uri:    'http://wapp.baidu.com/passport/login'
            method: 'POST'
            body:   querystring.stringify data.form
            headers:
                'content-type': 'application/x-www-form-urlencoded'
            followRedirect: false
            followAllRedirects: false

        (e, r, body) ->

            # TODO
            console.log r.request.headers
            console.log r.headers
            console.log body
            # callback null

        )
    
    # Get the signing list
    QueryFavorite: (callback) ->

        console.log '[Initializing] Query favorites'



        _request(

            uri:    'http://tieba.baidu.com/f/like/mylike?pn='
            ua:     false
            method: 'GET'
            encoding: null      # GBK

        (e, r, body) ->

            # Convert to UTF-8 first
            body = gbk_to_utf8_iconv.convert(body).toString()

            tieba_list = []

            $body = $ body
            $body.find('tr').each (index)->

                return if index is 0

                name = $(this).find('td:eq(0) a').attr('href')
                tieba_list.push $(this).find('td:eq(0) a').html()

                #TODO: more pages

            callback null, tieba_list

        )

    SignList: (list) ->

        return if list.length is 0

        jar.add request.cookie('USER_JUMP=2; path=/; domain=.baidu.com')

        curPos = 0

        next = ->

            if curPos < list.length

                setTimeout( ->
                    sign()
                , Math.random() * 3000 + 3000)

            else

                if (Config.Mail.Enabled && failedSign.length > 0)

                    transport.sendMail(
                        {
                            from:       Config.Mail.Nick + ' <' + Config.Mail.User + '>'
                            to:         Config.Mail.Target
                            subject:    '[Tieba Signer] ' + failedSign.length.toString() + ' fails.'
                            text:       JSON.stringify(failedSign, null, 4)
                        },
                        ->
                            transport.close()
                    )

        sign = ->

            current = list[curPos]

            console.log '\r\n正在签到: ' + current + '...'

            curPos++

            #Request tieba page
            _request(

                uri:    'http://wapp.baidu.com/f/?kw=' + encodeURIComponent(current)
                method: 'GET'

            (e, r, body) ->

                # 1. 无需签到？
                if body.match('"sign_is_on"[^:]*:[^"]*"0"')
                    console.log '无需签到'
                    next()
                    return

                # 2. 已签到？
                if body.match('"is_sign"[^:]*:[^"]*"1"')
                    console.log '已签到过'
                    next()
                    return

                # 3. 准备签到

                $body = $ body

                # 参考自：https://github.com/wolforce/me-shumei-open-oks-baidutiebaauto/blob/master/src/me/shumei/open/oks/baidutiebaauto/Signin.java
                baseUrl = $body.find('#top_kit .blue_kit_left a').attr('href').replace('http://tieba.baidu.com/', '').replace(/\/m\?.+/, '')
                fid = getFid body
                tbs = getTbs body

                # Sign
                _request(

                    uri:    signUrl = signUrl = 'http://wapp.baidu.com/' + baseUrl + '/sign?tbs=' + tbs + '&kw=' + encodeURIComponent(current) + '&fid=' + fid
                    method: 'GET'

                (e, r, body) ->

                    obj = JSON.parse body

                    if obj.no is 0

                        console.log '签到成功: 经验+' + obj.data.msg

                    else

                        console.log '签到失败: ' + error_map[obj.no]
                        failedSign.push {name: current, reason: error_map[obj.no]}

                    next()

                )


            )

        sign()