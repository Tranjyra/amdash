window.search_store = (input)->
  debounceSearch input
  return
search = (value) ->
  $.get "stores",
    format: "js"
    name: value
  return

debounceSearch = _.debounce search, 300
