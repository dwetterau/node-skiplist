{SkipNode, SkipEdge} = require './nodes'

class SkipList
  constructor: () ->
    # TODO: Allow it to be constructed on a sorted list
    @heads = []
    first_head = new SkipNode()
    first_edge = new SkipEdge(0)
    first_edge.left_node = first_head
    first_head.right_edge = first_edge
    @heads.push first_head

  # Inserts an element into the skip list in the proper sorted position. This position is determined
  # by calling the .compare() method on the element and expecting < 0 if it is smaller than the
  # other element, == 0 if it the same or > 0 if it is larger (similar to Java's compareTo).
  insert: (element) ->


module.exports =
  SkipList: SkipList
