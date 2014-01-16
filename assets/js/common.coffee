$.extend
  # Not support array syntax
  # Ex: a[]=foo&a[]=bar
  #  => {
  #       "a[]": bar
  #     }
  query: (name) ->
    decode = (str) ->
      try
        return decodeURIComponent(str.replace(/\+/g, " "))
      catch err
        return str
    parse = ->
      result = {}
      for pair in window.location.search.substring(1).split('&')
        [key, value] = pair.split("=")
        console.warn "Not supported syntax" if result[key]?
        result[decode key] = decode value
      return result
    if (!this.queryStringParams)
      this.queryStringParams = parse()

    this.queryStringParams[name]
