derby = require 'derby'
gg = derby.createApp module

gg.get '/', (page, model) ->
  model.fetch 'images.popular.0', (e, images) ->
    model.ref '_images', images
    console.log model.get '_images'
    page.render()

gg.ready (model) ->
  