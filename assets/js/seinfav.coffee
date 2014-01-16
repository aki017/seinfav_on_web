#= require "twitter"

class @Seinfav
  sounds = [ 
    "comeon",
    "dekedeke",
    "denn",
    "fackin",
    "favo",
    "fever",
    "fo",
    "i_feel_alright",
    "it_s_dream",
    "memesikute",
    "ohohoho",
    "ore_ga_tuiterudaro",
    "somebodyscreem",
    "yo",
  ]
  constructor: ()->
    @target = "aki017"
    @targets
    @page = 0
    @queue = []
    @observers = {}
    @requesting = false
    @lv = $.cookie("lv") || 1
    @exp = $.cookie("exp") || 0
    @lv -= 0;
    @exp -= 0;
    createjs.Sound.registerSound("./sounds/"+name+".mp3", name) for name in sounds 
  login: ()->
    @twitter = new Twitter();
    @twitter.login()
  getTargets: ()->
    d = new $.Deferred()
    if(@targets?)
      d.resolve(@targets)
    else
      @twitter.followers()
        .done (t)=>
          @targets = t
          d.resolve @targets
    d
    
  requestQue: ()->
    if !@requesting
      @requesting = true
      @twitter.user_timeline( @target, @page++)
        .done (data)=>
          @requesting = false
          $.each data,(k,v)=>
            if(!v.favorited && !v.retweeted_status?)
              @.addQue v
          @requestQue() if(@queue.length < 15)
        .fail (data)->
          @requesting = false
  addQue: (q)->
    @queue.push q
    @update "addQue",q
  shiftQue: ()->
    q=@queue.shift()
    @update "shiftQue", q
    q
  update: (key,value)->
    for k, v of @observers when key? && k==key
      o(value) for o in v
  fav: ()->
    @requestQue() if @queue.length < 15
    q = @shiftQue()
    createjs.Sound.play sounds[~~(sounds.length*Math.random())]
    @exp += ~~(Math.random()*100)
    @lvup() if @exp >= 100*@lv*Math.log(100*@lv)
    @saveexp()
    @twitter.favorite { "id" : q.id_str }
  lvup: ()->
    @exp -= 100*@lv*Math.log(100*@lv)
    @lv++
    @twitter.post ("新機能追加中 :::  Σ三(┛ε;)┓" + seinfav.lv + "ﾚﾍﾞﾀﾞｧｱｱｱｗｗｗｗｗｗｗｗｗｗｗｗｗｗｗｗｗｗｗｗｗｗ「└(」「┐L」L ゜ω。)┘」  fav???wwwwww http://www.aki017.info/works/iOS/seinfav/ #seinfav");

  saveexp: ()->
    $.cookie("exp",""+@exp)
    $.cookie("lv",""+@lv)
  setObserver: (k, v)->
    @observers[k] = [] if !@observers[k]?
    @observers[k].push v

