post = (path, json) ->
  xhr = new XMLHttpRequest
  xhr.open 'POST', path, true
  xhr.setRequestHeader 'Content-Type', 'application/json'
  xhr.send JSON.stringify(json)

postNewUser = (user) ->
  post('/user', id: user.id, name: user.name)

postInput = (user, input) ->
  post('/input', id: user.id, name: user.name, input: input)

module.exports =
  postNewUser: postNewUser
  postInput: postInput
