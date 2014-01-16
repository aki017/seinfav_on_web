###
Module dependencies.
###
express = require("express")
routes = require("./routes")
user = require("./routes/twitter")
http = require("http")
path = require("path")
ntwitter = require("ntwitter")
app = express()

# all environments
app.set "port", process.env.PORT or 3000
app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"
airbrake = require('airbrake').createClient('d674ab6ec6d5905719c8fcdd73f4f7cd')
app.use express.logger("dev")
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use express.cookieParser("seinfav for iOS")
app.use express.session()
app.use app.router
app.use(airbrake.expressHandler())
app.use require('connect-assets')()
app.locals.css = css
app.locals.js = js
app.use express.static(path.join(__dirname, "public"))

app.set 'consumer_key',    app.get('consumer_key')    || 'BDHktzCHLkoVvbl6ZsBLw'
app.set 'consumer_secret', app.get('consumer_secret') || 'rUlVpxbBPK5ia7xl8tVrwjUUID5asw1iTv2PGwp7MA'

twitter = ()->
  t = new ntwitter
    consumer_key:    app.get('consumer_key')
    consumer_secret: app.get('consumer_secret')
  switch arguments.length
    when 0 then t
    when 1
      cookie = t.cookie(arguments[0])
      t.options.access_token_key = cookie.access_token_key
      t.options.access_token_secret = cookie.access_token_secret
    when 2 
      t.options.access_token_key = arguments[0]
      t.options.access_token_secret = arguments[1]
  t


# development only
app.configure 'development', ()->
  app.use express.errorHandler()
  app.locals.pretty = true;
app.get "/", routes.index
app.get "/home", routes.home
app.get "/user/login", user.login(twitter)
app.get "/user/complete", user.complete
app.get "/user/verifyCredentials", user.verifyCredentials(twitter)
app.get "/user/followers", user.followers(twitter)
app.post "/user/user_timeline", user.user_timeline(twitter)
app.post "/user/favorite", user.favorite(twitter)
http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")

