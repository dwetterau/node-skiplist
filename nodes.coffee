class SkipNode
  constructor: () ->
    @right_edge = null
    @left_edge = null
    @down = null
    @element = null

class SkipEdge
  constructor: (distance) ->
    @distance = distance
    @left_node = null
    @right_node = null

module.exports =
  SkipNode: SkipNode
  SkipEdge: SkipEdge