// Generated by CoffeeScript 1.8.0
(function() {
  var SkipEdge, SkipNode;

  SkipNode = (function() {
    function SkipNode() {
      this.right_edge = null;
      this.down = null;
      this.element = null;
    }

    SkipNode.prototype.next = function() {
      return this.right_edge && this.right_edge.right_node;
    };

    SkipNode.prototype.set_next = function(node, edge, distance) {
      edge.distance = distance;
      edge.right_node = node;
      return this.right_edge = edge;
    };

    return SkipNode;

  })();

  SkipEdge = (function() {
    function SkipEdge(distance) {
      this.distance = distance;
      this.right_node = null;
    }

    return SkipEdge;

  })();

  module.exports = {
    SkipNode: SkipNode,
    SkipEdge: SkipEdge
  };

}).call(this);
