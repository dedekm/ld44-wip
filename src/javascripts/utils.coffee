postInput = (input) -> 
  xhr = new XMLHttpRequest
  xhr.open 'POST', '/input', true
  xhr.setRequestHeader 'Content-Type', 'application/json'
  xhr.send JSON.stringify(input: input)

module.exports =
  postInput: postInput
