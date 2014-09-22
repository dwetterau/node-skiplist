class SkipNode
  constructor: () ->
    @right_edge = null
    @down = null
    @element = null

  next: () ->
    return @right_edge and @right_edge.right_node

  set_next: (node, edge, distance) ->
    edge.distance = distance
    edge.left_node = this
    edge.right_node = node
    @right_edge = edge

class SkipEdge
  constructor: (distance) ->
    @distance = distance
    @left_node = null
    @right_node = null

module.exports =
  SkipNode: SkipNode
  SkipEdge: SkipEdge