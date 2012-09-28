instagram = require 'instagram'
log = require 'logule'
keys = require './keys'

client = instagram.createClient keys.instagram.id, keys.instagram.secret

module.exports = (store) ->

  store.route 'get', 'media.popular', (_, done) ->
    client.media.popular (media, e) ->
      # log.line 'media.popular', media
      done e, media

  store.route 'get', 'users.self.*.*', (token, page, done) ->
    token = token.replace /_/g, '.'
    log.line '!!!', token
    client.users.self { access_token: token }, (media, e) ->
      done e, media