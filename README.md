Baidu Tieba Signer
==================

This is a tool that could sign in all of your favorited Baidu post bars. It is written in Nodejs and could run on Windows / Linux / Mac.

You can simply deploy it on your server and use `cron` to schedule it automatically, or just add it to your auto-start program list.

The project is inspired from https://github.com/wolforce/me-shumei-open-oks-baidutiebaauto . (It is an Android application and you cannot make it automatic)

## Notice

Please modify `config.coffee`. Currently it can only log in using an existed COOKIE.

1. Login in Tieba your browser (PLEASE CLICK 'remember me')

2. Open the developer tool (In Chrome: F12)

3. [In the dev tool]: switch to 'network' tab

4. [In the dev tool]: Clear all logs

5. Click the Baidu Logo in the webpage (or any other Baidu hyperlinks)

6. [In the dev tool]: Click the first tracking record, copy the value of `Cookie` in 'Headers -> Request Headers' and fill it in the `Config.Cookie` field in `config.coffee'

## TODO

1. Support Username / Password login

2. Fetch more pages in 'my favorite Post bars'

3. Retry when failed