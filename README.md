Baidu Tieba Signer
==================

This is a tool that could sign in all of your favorited Baidu post bars. It is written in Nodejs and could run on Windows / Linux / Mac.

You can simply deploy it on your server and use `cron` to schedule it automatically, or just add it to your auto-start program list.

The project is inspired from https://github.com/wolforce/me-shumei-open-oks-baidutiebaauto (It is an Android application and you cannot make it automatic. )

## Quick start

```bash
npm install
node signer.js
```

## Notice

Before starting the tool, please modify `config.coffee` to make it work. Currently the tool can only log in using an existing COOKIE. The following instructions show you how to get your Tieba cookie.

1. Login Tieba using Chrome (PLEASE CLICK 'remember me')

2. Open the developer tool (`F12`)

3. [In the dev tool]: switch to 'network' tab

4. [In the dev tool]: Clear all logs

5. Click the Baidu Logo in the webpage (or any other Baidu hyperlinks)

6. [In the dev tool]: Click the first tracked record, copy the value of `Cookie` in 'Headers -> Request Headers' and fill it in the `Config.Cookie` field in `config.coffee'

## TODO

Please feel free to contribute to this project :)

1. Support Username / Password login

2. Fetch more pages in 'my favorite Post bars'

3. Retry when failed

## License

(The BSD License)

Copyright (c) 2010, Breezewish.
All rights reserved.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE 
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.