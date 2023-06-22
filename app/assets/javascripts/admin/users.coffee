window.search_user = (input) ->
  $.get "users?format=js",
    {search: input}

userlist = []

$(document).on 'turbolinks:load', ->
  document.addEventListener 'userform:load', ->
    $('#username').on 'input', ->
      if this.value.length < 3
        $('#users').empty()
      else
        search_ldapDebounced this

addDropDownUser = (user)->
  elem = $("<p class='dropdown-item'>#{user.displayname}</p>")
  elem.on 'click', ->
    fillForm(user)

fillForm = (user)->
  $('#username').val(user.samaccountname)
  $('#email').val(user.mail)
  $('#displayName').val(user.displayname)

search_ldap = (context)->
  selected = $(context).attr 'user-selected'
  username = $(context).val();
  if username.length > 3 && selected == 'false'
    $.get "/admin/ldap",
      {
        format: "json",
        search: username,
      },
      (data)->
        $("#users").empty()
        userlist.length = 0
        data.map (user)->
          userlist.push(user.myhash)
          $('#users').append addDropDownUser(user.myhash)

search_ldapDebounced = _.debounce search_ldap, 300
