// Generated by CoffeeScript 1.7.1
(function() {
  var Element, SkipList, assert;

  assert = require('assert');

  SkipList = require('../skip_list').SkipList;

  Element = require('./test_element').Element;

  describe('list_tests', function() {
    var verify_list;
    verify_list = function(skip_list) {
      var current, element_to_index, head, index, last, list, node, previous, _i, _j, _len, _len1, _ref, _results;
      list = skip_list._to_list();
      element_to_index = {};
      for (index = _i = 0, _len = list.length; _i < _len; index = ++_i) {
        node = list[index];
        element_to_index[node.element.value] = index;
      }
      _ref = skip_list._heads;
      _results = [];
      for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
        head = _ref[_j];
        previous = head;
        current = previous.next();
        index = previous.right_edge.distance - 1;
        last = previous.element;
        _results.push((function() {
          var _results1;
          _results1 = [];
          while (current) {
            assert.equal(index, element_to_index[current.element.value]);
            if (last) {
              assert(current.element.compare(last) > 0);
            }
            last = current.element;
            previous = current;
            current = previous.next();
            _results1.push(index += previous.right_edge.distance);
          }
          return _results1;
        })());
      }
      return _results;
    };
    describe('test insert', function() {
      it('should handle inserting a single element', function() {
        var element, list, skip_list;
        element = new Element(1);
        skip_list = new SkipList();
        skip_list.insert(element);
        list = skip_list._to_list();
        assert.equal(list.length, 1);
        assert.equal(list.length, skip_list.size());
        assert.equal(list[0].element.compare(element), 0);
        return verify_list(skip_list);
      });
      it('should handle inserting elements and return them in sorted order', function() {
        var element, elements, i, index, list, skip_list, _i, _j, _len, _results;
        elements = [];
        skip_list = new SkipList();
        for (i = _i = 10; _i >= 1; i = --_i) {
          elements.unshift(new Element(i));
          skip_list.insert(elements[0]);
          verify_list(skip_list);
        }
        list = skip_list._to_list();
        assert.equal(list.length, elements.length);
        assert.equal(skip_list.size(), elements.length);
        _results = [];
        for (index = _j = 0, _len = elements.length; _j < _len; index = ++_j) {
          element = elements[index];
          _results.push(assert.equal(list[index].element.compare(element), 0));
        }
        return _results;
      });
      return it('should handle inserting elements in order as well', function() {
        var element, elements, i, index, list, skip_list, _i, _j, _len, _results;
        elements = [];
        skip_list = new SkipList();
        for (i = _i = 0; _i <= 10; i = ++_i) {
          elements.push(new Element(i));
          skip_list.insert(elements[i]);
          verify_list(skip_list);
        }
        list = skip_list._to_list();
        assert.equal(list.length, elements.length);
        assert.equal(skip_list.size(), elements.length);
        _results = [];
        for (index = _j = 0, _len = elements.length; _j < _len; index = ++_j) {
          element = elements[index];
          _results.push(assert.equal(list[index].element.compare(element), 0));
        }
        return _results;
      });
    });
    describe('test find', function() {
      it('should return -1 for elements not in the list', function() {
        var i, result, skip_list, _i, _j, _results;
        skip_list = new SkipList();
        for (i = _i = 10; _i >= 0; i = --_i) {
          if (i % 2 === 0) {
            skip_list.insert(new Element(i));
          }
        }
        _results = [];
        for (i = _j = 10; _j >= 0; i = --_j) {
          if (i % 2 !== 0) {
            result = skip_list.find(new Element(i));
            _results.push(assert.equal(result, -1));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      });
      return it('should find elements by index correctly', function() {
        var element, elements, i, index, skip_list, _i, _j, _results;
        elements = [];
        skip_list = new SkipList();
        for (i = _i = 10; _i >= 0; i = --_i) {
          elements.unshift(new Element(i));
          skip_list.insert(elements[0]);
        }
        _results = [];
        for (i = _j = 0; _j <= 10; i = ++_j) {
          element = elements[i];
          index = skip_list.find(element);
          _results.push(assert.equal(index, i));
        }
        return _results;
      });
    });
    describe('test rank', function() {
      it('should return null for out of range indices', function() {
        var expected, result, skip_list;
        skip_list = new SkipList();
        expected = null;
        result = skip_list.rank(-1);
        assert.equal(result, expected);
        result = skip_list.rank(0);
        assert.equal(result, expected);
        skip_list.insert(new Element(0));
        result = skip_list.rank(1);
        return assert.equal(result, expected);
      });
      it('should find elements by rank correctly', function() {
        var element, elements, i, index, skip_list, _i, _j, _len, _results;
        skip_list = new SkipList();
        elements = [];
        for (i = _i = 10; _i >= 0; i = --_i) {
          elements.unshift(new Element(i));
          skip_list.insert(elements[0]);
        }
        _results = [];
        for (index = _j = 0, _len = elements.length; _j < _len; index = ++_j) {
          element = elements[index];
          _results.push(assert.equal(skip_list.rank(index).compare(element), 0));
        }
        return _results;
      });
      return it('should return the proper frontier from the helper method', function() {
        var element, elements, frontier, i, skip_list, _i, _j, _ref, _ref1, _results;
        skip_list = new SkipList();
        elements = [];
        for (i = _i = 10; _i >= 0; i = --_i) {
          elements.unshift(new Element(i));
          skip_list.insert(elements[0]);
        }
        _ref = skip_list._rank(-1), element = _ref.element, frontier = _ref.frontier;
        assert.equal(element, null);
        assert.equal(frontier.length, skip_list._heads.length);
        _results = [];
        for (i = _j = 0; _j <= 10; i = ++_j) {
          _ref1 = skip_list._rank(i), element = _ref1.element, frontier = _ref1.frontier;
          assert.equal(element, elements[i]);
          _results.push(assert.equal(frontier[frontier.length - 1].element, elements[i]));
        }
        return _results;
      });
    });
    return describe('test remove', function() {
      it('should fail to remove elements outside of the bounds', function() {
        var elements, i, skip_list, _i;
        skip_list = new SkipList();
        elements = [];
        for (i = _i = 10; _i >= 0; i = --_i) {
          elements.unshift(new Element(i));
          skip_list.insert(elements[0]);
        }
        assert(!skip_list.remove(-1));
        assert.equal(skip_list.size(), elements.length);
        assert(!skip_list.remove(skip_list.size()), elements.length);
        return assert.equal(skip_list.size(), elements.length);
      });
      it('should successfully remove elements at random and decrement the counter', function() {
        var elements, i, remove_index, skip_list, _i, _j, _results;
        skip_list = new SkipList();
        elements = [];
        for (i = _i = 10; _i >= 0; i = --_i) {
          elements.unshift(new Element(i));
          skip_list.insert(elements[0]);
        }
        _results = [];
        for (i = _j = 10; _j >= 0; i = --_j) {
          remove_index = Math.floor(Math.random() * i);
          assert(skip_list.remove(remove_index));
          assert.equal(skip_list.size(), i);
          _results.push(verify_list(skip_list));
        }
        return _results;
      });
      it('should successfully remove the first element and decrement the counter', function() {
        var elements, i, remove_index, skip_list, _i, _j, _results;
        skip_list = new SkipList();
        elements = [];
        for (i = _i = 10; _i >= 0; i = --_i) {
          elements.unshift(new Element(i));
          skip_list.insert(elements[0]);
        }
        _results = [];
        for (i = _j = 10; _j >= 0; i = --_j) {
          remove_index = 0;
          assert(skip_list.remove(remove_index));
          assert.equal(skip_list.size(), i);
          _results.push(verify_list(skip_list));
        }
        return _results;
      });
      it('should successfully remove the last element and decrement the counter', function() {
        var elements, i, remove_index, skip_list, _i, _j, _results;
        skip_list = new SkipList();
        elements = [];
        for (i = _i = 10; _i >= 0; i = --_i) {
          elements.unshift(new Element(i));
          skip_list.insert(elements[0]);
        }
        _results = [];
        for (i = _j = 10; _j >= 0; i = --_j) {
          remove_index = skip_list.size() - 1;
          assert(skip_list.remove(remove_index));
          assert.equal(skip_list.size(), i);
          _results.push(verify_list(skip_list));
        }
        return _results;
      });
      it('should successfully remove the middle element and decrement the counter', function() {
        var elements, i, remove_index, skip_list, _i, _j, _results;
        skip_list = new SkipList();
        elements = [];
        for (i = _i = 10; _i >= 0; i = --_i) {
          elements.unshift(new Element(i));
          skip_list.insert(elements[0]);
        }
        _results = [];
        for (i = _j = 10; _j >= 0; i = --_j) {
          remove_index = Math.floor(i / 2);
          assert(skip_list.remove(remove_index));
          assert.equal(skip_list.size(), i);
          _results.push(verify_list(skip_list));
        }
        return _results;
      });
      return it('should be able to insert after removing elements', function() {
        var elements, i, remove_index, skip_list, _i, _j, _k, _results;
        skip_list = new SkipList();
        elements = [];
        for (i = _i = 10; _i >= 0; i = --_i) {
          elements.unshift(new Element(i));
          skip_list.insert(elements[0]);
        }
        for (i = _j = 10; _j >= 0; i = --_j) {
          remove_index = Math.floor(i / 2);
          assert(skip_list.remove(remove_index));
          assert.equal(skip_list.size(), i);
          verify_list(skip_list);
        }
        _results = [];
        for (i = _k = 0; _k <= 10; i = ++_k) {
          skip_list.insert(elements[i]);
          assert.equal(skip_list.size(), i + 1);
          _results.push(verify_list(skip_list));
        }
        return _results;
      });
    });
  });

}).call(this);

//# sourceMappingURL=list_tests.map
