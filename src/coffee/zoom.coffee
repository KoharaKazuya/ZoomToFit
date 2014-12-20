###
横スクロールが発生しない範囲での最大限ズームの倍率を求める

@param id タブの ID
@param estimation 倍率の推定値
@param min 倍率の最小値
@param max 倍率の最大値
@param cb コールバック関数(最小倍率, 最大倍率)
###
expandSearchToFit = (id, estimation, min, max, cb) ->
  searchMax = (smax, step, cb) ->
    smax += step
    if max < smax
      cb max
    else
      chrome.tabs.setZoom id, smax, ->
        chrome.tabs.sendMessage id,
          command: 'CAN_SCROLL_HORIZONTALLY'
        , (response) ->
          if response.enabled
            cb smax
          else
            searchMax smax, step * 2, cb
  searchMin = (smin, step, cb) ->
    smin -= step
    if smin < min
      cb min
    else
      chrome.tabs.setZoom id, smin, ->
        chrome.tabs.sendMessage id,
          command: 'CAN_SCROLL_HORIZONTALLY'
        , (response) ->
          if response.enabled
            searchMin smin, step * 2, cb
          else
            cb smin
  searchMin estimation, 0.01, (smin) ->
    searchMax estimation, 0.01, (smax) ->
      cb smin, smax

###
横スクロールが発生しない範囲での最大限ズームの倍率を求める

@param id タブの ID
@param min 倍率の最小値
@param max 倍率の最大値
@param cb コールバック関数(result)
###
binarySearchToFit = (id, min, max, cb) ->
  if max - min < 0.01
    cb min
  else
    m = (min + max) / 2
    chrome.tabs.setZoom id, m, ->
      chrome.tabs.sendMessage id,
        command: 'CAN_SCROLL_HORIZONTALLY'
      , (response) ->
        if response.enabled
          binarySearchToFit id, min, m, cb
        else
          binarySearchToFit id, m, max, cb
option =
  zoom_min: 0.75
  zoom_max: 1.5

# メッセージを受け取りコマンドを実行する
chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
  switch request.command
    when 'ZOOM_TO_FIT'
      id = if request.hasOwnProperty('tab_id')
        request.tab_id
      else
        sender.tab.id
      chrome.tabs.getZoom id, (zoom) ->
        # 現在の倍率の周辺を探索する
        expandSearchToFit id, zoom,
          option.zoom_min - 0.05,
          option.zoom_max + 0.05, (smin, smax) ->
            # 範囲内での最適解を二分探索で求める
            binarySearchToFit id, smin, smax, (result) ->
              result = option.zoom_min  if result < option.zoom_min
              result = option.zoom_max  if result > option.zoom_max
              chrome.tabs.setZoom id, result
