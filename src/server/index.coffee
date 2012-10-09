http = require 'http'
path = require 'path'
derby = require 'derby'
express = require 'express'
authom = require 'authom'
gzippo = require 'gzippo'
ms = require 'ms'
gramgrid = require '../gramgrid'
keys = require './keys'
serverError = require './serverError'
log = require('logule').init module

app = express()
server = module.exports = http.createServer app

derby.use derby.logPlugin

store = derby.createStore listen: server
require('./instagram')(store)

root = path.dirname path.dirname __dirname
publicPath = path.join root, 'public'

app
  .use(express.favicon())
  .use(gzippo.staticGzip publicPath, maxAge: ms '365d')
  .use(express.compress())
  .use(express.bodyParser())
  .use(express.methodOverride())
  .use(express.cookieParser())
  .use(store.sessionMiddleware
    secret: process.env.SESSION_SECRET || '53822dc71eee646eb5704137b37215c0'
    cookie: { maxAge: ms '365d' }
  )
  .use(store.modelMiddleware())
  .use(gramgrid.router())
  .use(app.router)
  .use(serverError root)

authom.createServer
  service: 'instagram'
  id: keys.instagram.id
  secret: keys.instagram.secret

authom.on 'auth', (req, res, auth) ->
  req.session.user = auth.data.data
  req.session.user.token = auth.token
  res.redirect 'back'

authom.on 'error', (req, res, data) ->
  res.redirect 'back'

app.get '/auth/:service', authom.app

app.get '/signout', (req, res, next) ->
  req.session.user = null
  res.redirect '/'

app.all '*', (req) ->
  throw "404: #{req.url}"

