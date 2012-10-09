instagram = require 'instagram'
keys = require './keys'

client = instagram.createClient keys.instagram.id, keys.instagram.secret

module.exports = (store) ->

  store.route 'get', 'media.popular', (_, done) ->
    client.media.popular (media, e) ->
      done e, media

  store.route 'get', 'users.self.*.*', (token, page, done) ->
    token = token.replace /_/g, '.'
    client.users.self { access_token: token, count: 100 }, (media, e) ->
      done e, media

  store.route 'get', 'media.user.*.*.*', (token, username, page, done) ->
    client.users.search username, (users, e) ->
      user = users[0]
      if user?.username is not username
        return done
      token = token.replace /_/g, '.'
      client.users.media user.id, { access_token: token, count: 100 }, (media, e) ->
        done e, media