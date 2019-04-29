processInput = (string) ->
  splitChar = '{split}'
  string.replace(/(?:(the|a|an) +)/g, '') # remove articles
        .replace(/^\s+|\s+$/g, '') # remove spaces at start / end
        .replace(/ +(?= )/g,'') # remove multiple spaces
        .replace(/\s+/, splitChar).split(splitChar) #split by first space

findNestedResponse = (words, data) ->
  word = words.shift()
  if !word
    if typeof data == 'string'
      response = @findResponse(data)
      if response.error
        throw "invalid alias: #{data}"
      else
        response.value
    else if data.default
      data
    else
      # TODO
  else if data[word]

    @findNestedResponse(words, data[word])

findResponse = (str) ->
  sentence = processInput(str)

  action = sentence[0]
  if @data.actions[action]
    if sentence.length == 1
      if @data.actions[action].undefined
        return { value: @data.actions[action].undefined }
      else
        return { error: "What do you want to #{action}?" }
    else
      response = @findNestedResponse(sentence[1].split(' '), @data.actions[action])
      if response
        return { value: response }
      else
        return { error: "You can #{action} but not #{sentence[1]}..." }
  else if @itemsList.indexOf(action) != -1
    return { error: "What do you want to do with #{action}?" }

  { error: "Don't know how to #{str}..." }

module.exports =
  findNestedResponse: findNestedResponse
  findResponse: findResponse
