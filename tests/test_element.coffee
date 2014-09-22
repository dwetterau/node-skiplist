class Element
  constructor: (value) ->
    @value = value

  compare: (other) ->
    if @value == other.value
      return 0
    else if @value < other.value
      return -1
    else if @value > other.value
      return 1
    else
      throw Error("Unable to compare with this object")

module.exports =
  Element: Element