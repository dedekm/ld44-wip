module.exports = ->
  @linesCount = 0

  @addChatLine = (text) ->
    @add.text(0, @linesCount * 16, text, fontSize: '12px')
    @linesCount++

  input = (e) ->
    sentence = @value.split(' ').filter((v) ->
      ['a', 'the'].indexOf(v) == -1
    )

    data = @scene.data()
    if sentence.length > 1
      action = sentence[0]
      item = sentence[1]
      if data.items[item]
        if data.items[item].actions[action]
          response = data.items[item].actions[action].response
        else
          response = "I have #{item}, but I can't #{action} it"
    else
      word = sentence[0]
      if data.actions[word]
        response = data.actions[word].response
      else if data.items[word]
        response = "What do you want to do with #{word}"

    response ||= "Don't know how to #{@value}..."

    @scene.addChatLine(">> #{@value}")
    @scene.addChatLine(response)

    @value = ''

  inputElement = document.getElementById('text-input')
  inputElement.scene = @
  document.getElementById('text-input').addEventListener 'change', input
