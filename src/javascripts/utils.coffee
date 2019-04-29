post = (path, json) ->
  xhr = new XMLHttpRequest
  xhr.open 'POST', path, true
  xhr.setRequestHeader 'Content-Type', 'application/json'
  xhr.send JSON.stringify(json)

postNewUser = (name) ->
  post('/user', user: 'test_name')

postInput = (input) ->
  post('/input', user: 'test_name', input: input)

module.exports =
  postNewUser: postNewUser
  postInput: postInput
