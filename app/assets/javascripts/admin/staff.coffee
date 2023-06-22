window.search_staff = (input)->
  $.get "staffs?format=js",
    {search: input}
  return

