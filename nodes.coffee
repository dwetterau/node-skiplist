class SkipNode
  constructor: () ->
    @right_edge = null
    @down = null
    @element = null

  next: () ->
    return @right_edge and @right_edge.right_node

  set_next: (node, edge, distance) ->
    edge.distance = distance
    edge.right_node = node
    @right_edge = edge

class SkipEdge
  constructor: (distance) ->
    @distance = distance
    @right_node = null

module.exports =
  SkipNode: SkipNode
  SkipEdge: SkipEdge