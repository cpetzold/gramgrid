derby = require 'derby'
gg = derby.createApp module

popular = (page, model) ->
  model.fetch 'media.popular', (e, images) ->
    model.ref '_images', images
    page.render()

userFeed = (page, model) ->
  user = model.session.user
  token = user.token.replace /\./g, '_'
  console.log token
  model.fetch "users.self.#{token}", (e, images) ->
    model.ref '_images', images
    page.render()

gg.get '/', (page, model) ->
  if model.session.user
    userFeed page, model
  else
    popular page, model

gg.get '/popular', popular

gg.ready (model) ->
  