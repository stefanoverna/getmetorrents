$ ->

  opts = {
    lines: 13, length: 13, width: 3, radius: 19, corners: 0, rotate: 0,
    color: '#000', speed: 1, trail: 60, shadow: false, hwaccel: true,
    className: 'spinner', zIndex: 2e9, top: 'auto', left: 'auto'
  }

  new Spinner(opts).spin($(".spinner").get(0))
