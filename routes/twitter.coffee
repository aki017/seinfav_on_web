Q = require "q"

exports.login = (twitter)->
  twitter().login("/user/login", "/user/complete")

exports.complete = (req, res)->
  res.redirect "/home"

exports.verifyCredentials = (twitter)->
  (req, res)->
    res.contentType 'application/json'
    twitter(req).verifyCredentials (e,o)->
      throw e if e?
      res.send o

showUser = (twitter, ids)->
  deferred = Q.defer()
  twitter.showUser ids, (e, o)->
    if e?
      deferred.reject()
    else
      deferred.resolve(o)
  deferred.promise
  
exports.followers = (twitter)->
  (req, res)->
    res.contentType 'application/json'
    twitter(req).getFriendsIds (e, ids)->
      throw e if e?
      chunked = (ids.slice(i, i+100) for i in [0..ids.length] by 100)
      deferred = Q.defer()
      Q.all( (showUser twitter(req), c for c in chunked))
        .spread ->
          resolved = []
          resolved = resolved.concat arguments[i] for i in [0..arguments.length-1]
          res.send JSON.stringify resolved

exports.user_timeline = (twitter)->
  (req, res)->
    res.contentType 'application/json'
    params =
      screen_name: req.body.screen_name
      count: req.body.page
    twitter(req).getUserTimeline params, (e, o)->
      throw e if e?
      res.send JSON.stringify o

exports.favorite = (twitter)->
  (req, res)->
    res.contentType 'application/json'
    id = req.body.id
    twitter(req).post '/favorites/create.json', id: id, null, (e,o)->
      throw e if e?
      res.send JSON.stringify o

