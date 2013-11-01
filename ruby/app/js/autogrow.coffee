$.fn.autogrow = (o) ->
  o = $.extend(
    maxWidth: 1000
    minWidth: 230
    comfortZone: 40
  , o)

  @filter("input:text").each ->
    minWidth = o.minWidth or $(this).width()
    val = ""
    input = $(this)
    testSubject = $("<tester/>").css(
      position: "absolute"
      top: -9999
      left: -9999
      width: "auto"
      fontSize: input.css("fontSize")
      fontFamily: input.css("fontFamily")
      fontWeight: input.css("fontWeight")
      letterSpacing: input.css("letterSpacing")
      whiteSpace: "nowrap"
    )
    check = ->
      return  if val is (val = input.val())
      escaped = val.replace(/&/g, "&amp;").replace(/\s/g, "&nbsp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
      testSubject.html escaped
      testerWidth = testSubject.width()
      newWidth = (if (testerWidth + o.comfortZone) >= minWidth then testerWidth + o.comfortZone else minWidth)
      currentWidth = input.width()
      isValidWidthChange = (newWidth < currentWidth and newWidth >= minWidth) or (newWidth > minWidth and newWidth < o.maxWidth)
      input.width newWidth  if isValidWidthChange

    testSubject.insertAfter input
    $(this).bind "change keyup keydown blur update", check
    check()

  this
