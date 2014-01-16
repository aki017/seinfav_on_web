#= require "seinfav"
#= require "jquery.cookie"

colors = [
  [ "turquoise"   , "green-sea"     ]
  [ "emerald"     , "nephritis"     ]
  [ "peter-river" , "belize-hole"   ]
  [ "amethyst"    , "wisteria"      ]
  [ "wet-asphalt" , "midnight-blue" ]
  [ "sun-flower"  , "orange"        ]
  [ "carrot"      , "pumpkin"       ]
  [ "alizarin"    , "pomegranate"   ]
  [ "clouds"      , "silver"        ]
  [ "concrete"    , "asbestos"      ]
]
  
thema = [0,0]
scr = true
handl = "click"
$ ->
  window.seinfav = new Seinfav()
  seinfav.setObserver "addQue", (v)->
    $("#loading").fadeOut()
    $("#tweets")
      .append $("<div>")
        .addClass("palette")
        .addClass("palette-"+colors[thema[0]][(thema[1]=1-thema[1])])
        .attr("id","tweet"+v.id_str)
        .text v.text
  seinfav.setObserver "shiftQue", (v)->
    $("#tweet"+v.id_str)
      .animate(
        width: 0
        "margin-left": 300
        opacity: 0
      ,300)
      .animate {
        height: 0,
        padding: 0
      },400,()->
        $(this).hide 0, ()->
          $(this)
            .remove()
  seinfav.login()
    .done ()->
      selectTarget()
  $("#favbtn").on handl,()->
    seinfav.fav()
      .done ->
        updateexp()
  $(document)
    .bind 'touchmove',(e)->
      e.preventDefault() if !scr;
  $("#headertitle").on handl,()->
    thema[0] = (thema[0] + 1) % colors.length
    console.log("color")
  updateexp= ()->
    next = 100 * seinfav.lv * Math.log(100*seinfav.lv)
    p = seinfav.exp / next
    $("#expbar_bar")
      .width(($("#expbar").width()-$("#expbar_text").width())*p)
    $("#expbar_text")
      .text("lv:"+seinfav.lv+" ("+ (~~seinfav.exp)+" / " + (~~next))
    thema[0] = (~~seinfav.lv) % colors.length
  updateexp()
  return
showLoading= ()->
  $("#loading").show()
selectTarget= ()->
  scr=true
  $("#targets").show()
  $("#favbtn").hide()
  $("#tweets").hide()
  $("#targets").empty()
  showLoading()
  seinfav.getTargets()
    .done (data)->
      $("#loading").fadeOut()
      data.sort (a,b)->
        if a.screen_name < b.screen_name then -1 else 1
      $.each data,()->
        $("#targets")
          .append $("<div>")
          .addClass("palette")
          .addClass("palette-"+colors[thema[0]][(thema[1]=1-thema[1])])
          .text(@name+"("+@screen_name+")")
          .on "click",()=>
            seinfav.target = @screen_name
            $("#targets").empty()
            seinfav.queue = []
            showLoading()
            showTweets()
    .fail (data)->
      console.log data
  $("#headertitle").text( "Plese select targets")
  $("#backbtn")
    .off(handl)
    .on handl,()->
      location.back()
showTweets= ()->
  scr=false
  $("#targets").hide()
  $("#favbtn").show()
  $("#tweets").show()
  seinfav.requestQue()
  $("#headertitle").text( "Targets : "+seinfav.target)
  $("#backbtn")
    .off(handl)
    .on handl,()->
      selectTarget()
