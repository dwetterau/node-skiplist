// Generated by CoffeeScript 1.8.0
(function() {
  var SkipEdge, SkipList, SkipNode, _ref;

  _ref = require('./nodes'), SkipNode = _ref.SkipNode, SkipEdge = _ref.SkipEdge;

  SkipList = (function() {
    function SkipList() {
      this.heads = [];
      this._new_head();
    }

    SkipList.prototype._new_head = function() {
      var new_edge, new_head;
      new_head = new SkipNode();
      new_edge = new SkipEdge(0);
      new_edge.left_node = new_head;
      new_head.set_next(null, new_edge, 0);
      return this.heads.push(new_head);
    };

    SkipList.prototype.insert = function(element) {
      var comparison, current, current_head, current_index, find_result, left_distance, left_index, left_node, new_index, new_node, newer_node, old_distance, previous, right_distance, right_edge, right_node, _results;
      find_result = this._find(element);
      left_node = find_result.node;
      if (left_node.element) {
        comparison = element.compare(left_node.element);
        if (comparison === 0) {
          throw Error("Element already present");
        }
      }
      new_node = new SkipNode();
      new_node.element = element;
      right_node = left_node.next();
      left_node.set_next(new_node, left_node.right_edge, 1);
      if (right_node) {
        right_edge = new SkipEdge(1);
        new_node.set_next(right_node, right_edge, 1);
      }
      current_head = 0;
      _results = [];
      while (Math.random() < 0.5) {
        current_head += 1;
        if (current_head >= this.heads.length) {
          this._new_head();
        }
        previous = this.heads[current_head];
        current = previous.next();
        current_index = 0;
        while (current && current_index < find_result.index) {
          current_index += previous.right_edge.distance;
          previous = current;
          current = previous.next();
        }
        newer_node = new SkipNode();
        newer_node.element = element;
        newer_node.down = new_node;
        old_distance = previous.right_edge.distance;
        left_index = current_index - old_distance;
        new_index = find_result.index + 1;
        left_distance = new_index - left_index;
        previous.set_next(newer_node, previous.right_edge, left_distance);
        if (current) {
          right_distance = old_distance - left_distance + 1;
          right_edge = new SkipEdge(right_distance);
          newer_node.set_next(current, right_edge, right_distance);
        }
        _results.push(new_node = newer_node);
      }
      return _results;
    };

    SkipList.prototype._find = function(element) {
      var comparison, current, index, previous;
      previous = this.heads[this.heads.length - 1];
      current = previous.next();
      index = 0;
      while (true) {
        if (!current) {
          if (previous.down) {
            previous = previous.down;
            current = previous.next();
            continue;
          } else {
            return {
              'node': previous,
              'index': index
            };
          }
        }
        comparison = current.element.compare(element);
        if (comparison === 0) {
          return {
            'node': current,
            'index': index
          };
        } else if (comparison > 0) {
          if (previous.down) {
            previous = previous.down;
            current = previous.next();
            continue;
          } else {
            return {
              'node': previous,
              'index': index
            };
          }
        } else {
          index += previous.right_edge.distance;
          previous = current;
          current = previous.next();
        }
      }
    };

    SkipList.prototype.to_list = function() {
      var current, element_list;
      element_list = [];
      current = this.heads[0].next();
      while (current) {
        element_list.push(current);
        current = current.next();
      }
      return element_list;
    };

    SkipList.prototype.visualize = function() {
      var current, head, index, row, _i, _len, _ref1;
      console.log("################~BEGIN~##############");
      _ref1 = this.heads;
      for (index = _i = 0, _len = _ref1.length; _i < _len; index = ++_i) {
        head = _ref1[index];
        current = head.next();
        row = index + '=';
        while (current) {
          row += '(' + current.element.value + ')';
          if (current.down) {
            row += 'd';
          }
          if (current.right_edge) {
            row += '-' + current.right_edge.distance + '-';
          }
          current = current.next();
        }
        console.log(row);
      }
      return console.log("################~END~##############");
    };

    return SkipList;

  })();

  module.exports = {
    SkipList: SkipList
  };

}).call(this);
