chrome.browserAction.onClicked.addListener (tab) ->
  chrome.tabs.create url: chrome.extension.getURL('app.html'), active: true
