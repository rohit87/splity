@log = (message, options) ->
  return unless @console and @console.log
  console.dir message if typeof message is 'object' or typeof message is 'array'
  console.log message if typeof message isnt 'object'