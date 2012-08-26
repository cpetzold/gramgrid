instagram = require 'instagram'
log = require 'logule'

client = instagram.createClient '5a959c13800340acaa2db39b43b87849', '3ca11ab5fa204e5f936ad963682004d4'

module.exports = (store) ->

  store.route 'get', 'images.popular.*', (page, done) ->
    client.media.popular (images, e) ->
      log.line images
      done e, images