class @Twitter
  ENDPOINT = "/user/"

  constructor: ()->
  
  login: ()->
    deferred = new $.Deferred();
    @_get("verifyCredentials")
      .done (json)->
        deferred.resolve(json)
      .fail ()->
        deferred.reject()
    deferred.promise()
  _get: (action,options)->
    $.getJSON(ENDPOINT+action,options)
  _post: (action, options, callback, datatype)->
    $.post(ENDPOINT+action, options, callback, datatype)
  user_timeline: (user,page)->
    before = 0 if (!page?)
    @_post("user_timeline",{ "screen_name" : user,"page" : page }, undefined, "json")
  favorite: ( status )->
    @_post("favorite",status)
  followers: ()->
    @_get("followers")
  post: (text)->
    @_get("post",{ "text" : text })

