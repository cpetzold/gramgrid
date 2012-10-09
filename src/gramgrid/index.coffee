derby = require 'derby'
gg = derby.createApp module

images = (page, model, path) ->
  model.fetch path, (e, images) ->
    return page.redirect '/' if e
    model.ref '_images', images
    imgs = model.get '_images'
    # console.log imgs
    page.render()

gg.get '/', (page, model) ->
  if !model.session.user
    return page.redirect '/auth/instagram'

  user = model.session.user
  token = user.token.replace /\./g, '_'
  images page, model, "users.self.#{token}.0"

gg.get '/popular', (page, model) ->
  images page, model, 'media.popular'

gg.get '/:username', (page, model, params) ->
  if !model.session.user
    return page.redirect '/auth/instagram'

  username = params.username
  user = model.session.user
  token = user.token.replace /\./g, '_'
  images page, model, "media.user.#{token}.#{username}.0"

gg.ready (model) ->
  