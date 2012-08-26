http = require 'http'
path = require 'path'
express = require 'express'
gzippo = require 'gzippo'
derby = require 'derby'
app = require '../app'
serverError = require './serverError'

expressApp = express()
server = module.exports = http.createServer expressApp

derby.use(derby.logPlugin)

store = derby.createStore listen: server
require('./instagram')(store)

ONE_YEAR = 1000 * 60 * 60 * 24 * 365
root = path.dirname path.dirname __dirname
publicPath = path.join root, 'public'

expressApp
  .use(express.favicon())
  .use(gzippo.staticGzip publicPath, maxAge: ONE_YEAR)
  .use(express.compress())
  .use(express.bodyParser())
  .use(express.methodOverride())
  .use(express.cookieParser())
  .use(store.sessionMiddleware
    secret: process.env.SESSION_SECRET || ':o'
    cookie: {maxAge: ONE_YEAR}
  )
  .use(store.modelMiddleware())
  .use(app.router())
  .use(expressApp.router)
  .use(serverError root)

expressApp.all '*', (req) ->
  throw "404: #{req.url}"
