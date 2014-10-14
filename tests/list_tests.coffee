assert = require 'assert'
{SkipList} = require '../skip_list'
{Element} = require './test_element'

describe 'list_tests', () ->

  # Go through each row, make sure they are in order and the distances add up.
  verify_list = (skip_list) ->
    # Start by calling to_list to build a mapping of element to index
    list = skip_list._to_list()
    element_to_index = {}
    for node, index in list
      element_to_index[node.element.value] = index

    for head in skip_list._heads
      previous = head
      current = previous.next()
      index = previous.right_edge.distance - 1
      last = previous.element
      while current
        # Make sure the index is right
        assert.equal index, element_to_index[current.element.value]

        # Make sure this is sorted
        if last
          assert current.element.compare(last) > 0
        last = current.element
        previous = current
        current = previous.next()
        index += previous.right_edge.distance

  describe 'test insert', () ->
    it 'should handle inserting a single element', () ->
      element = new Element(1)
      skip_list = new SkipList()
      skip_list.insert(element)

      list = skip_list._to_list()
      assert.equal list.length, 1
      assert.equal list.length, skip_list.size()
      assert.equal list[0].element.compare(element), 0
      verify_list(skip_list)

    it 'should handle inserting elements and return them in sorted order', () ->
      elements = []
      skip_list = new SkipList()
      for i in [10..1]
        elements.unshift(new Element(i))
        skip_list.insert(elements[0])
        verify_list(skip_list)

      list = skip_list._to_list()
      assert.equal list.length, elements.length
      assert.equal skip_list.size(), elements.length
      for element, index in elements
        assert.equal list[index].element.compare(element), 0

    it 'should handle inserting elements in order as well', () ->
      elements = []
      skip_list = new SkipList()
      for i in [0..10]
        elements.push(new Element(i))
        skip_list.insert(elements[i])
        verify_list(skip_list)

      list = skip_list._to_list()
      assert.equal list.length, elements.length
      assert.equal skip_list.size(), elements.length
      for element, index in elements
        assert.equal list[index].element.compare(element), 0

  describe 'test find', () ->
    it 'should return -1 for elements not in the list', () ->
      skip_list = new SkipList()
      for i in [10..0]
        if i % 2 == 0
          skip_list.insert(new Element(i))

      for i in [10..0]
        if i % 2 != 0
          result = skip_list.find(new Element(i))
          assert.equal result, -1

    it 'should find elements by index correctly', () ->
      elements = []
      skip_list = new SkipList()
      for i in [10..0]
        elements.unshift(new Element(i))
        skip_list.insert(elements[0])

      for i in [0..10]
        element = elements[i]
        index = skip_list.find element
        assert.equal index, i

  describe 'test rank', () ->
    it 'should return null for out of range indices', () ->
      skip_list = new SkipList()
      expected = null

      # List has nothing in it, -1 and 0 should error
      result = skip_list.rank -1
      assert.equal result, expected

      result = skip_list.rank 0
      assert.equal result, expected

      # After we insert something, 1 should still error
      skip_list.insert(new Element(0))
      result = skip_list.rank 1
      assert.equal result, expected

    it 'should find elements by rank correctly', () ->
      skip_list = new SkipList()
      elements = []
      for i in [10..0]
        elements.unshift(new Element(i))
        skip_list.insert(elements[0])

      for element, index in elements
        assert.equal skip_list.rank(index).compare(element), 0

    it 'should return the proper frontier from the helper method', () ->
      skip_list = new SkipList()
      elements = []
      for i in [10..0]
        elements.unshift(new Element(i))
        skip_list.insert(elements[0])

      # Rank of -1 should return the stack of heads
      {element, frontier} = skip_list._rank(-1)
      assert.equal element, null
      assert.equal frontier.length, skip_list._heads.length

      # The last element of the frontier should point to the right index node
      for i in [0..10]
        {element, frontier} = skip_list._rank(i)
        assert.equal element, elements[i]
        assert.equal frontier[frontier.length - 1].element, elements[i]

  describe 'test remove', () ->
    it 'should fail to remove elements outside of the bounds', () ->
      skip_list = new SkipList()
      elements = []
      for i in [10..0]
        elements.unshift(new Element(i))
        skip_list.insert(elements[0])

      assert not skip_list.remove(-1)
      assert.equal skip_list.size(), elements.length

      assert not skip_list.remove(skip_list.size()), elements.length
      assert.equal skip_list.size(), elements.length

    it 'should successfully remove elements at random and decrement the counter', () ->
      skip_list = new SkipList()
      elements = []
      for i in [10..0]
        elements.unshift(new Element(i))
        skip_list.insert(elements[0])

      for i in [10..0]
        remove_index = Math.floor(Math.random() * i)

        assert skip_list.remove(remove_index)
        assert.equal skip_list.size(), i
        verify_list(skip_list)

    it 'should successfully remove the first element and decrement the counter', () ->
      skip_list = new SkipList()
      elements = []
      for i in [10..0]
        elements.unshift(new Element(i))
        skip_list.insert(elements[0])

      for i in [10..0]
        remove_index = 0

        assert skip_list.remove(remove_index)
        assert.equal skip_list.size(), i
        verify_list(skip_list)

    it 'should successfully remove the last element and decrement the counter', () ->
      skip_list = new SkipList()
      elements = []
      for i in [10..0]
        elements.unshift(new Element(i))
        skip_list.insert(elements[0])

      for i in [10..0]
        remove_index = skip_list.size() - 1

        assert skip_list.remove(remove_index)
        assert.equal skip_list.size(), i
        verify_list(skip_list)

    it 'should successfully remove the middle element and decrement the counter', () ->
      skip_list = new SkipList()
      elements = []
      for i in [10..0]
        elements.unshift(new Element(i))
        skip_list.insert(elements[0])

      for i in [10..0]
        remove_index = Math.floor(i / 2)

        assert skip_list.remove(remove_index)
        assert.equal skip_list.size(), i
        verify_list(skip_list)

    it 'should be able to insert after removing elements', () ->
      skip_list = new SkipList()
      elements = []
      for i in [10..0]
        elements.unshift(new Element(i))
        skip_list.insert(elements[0])

      for i in [10..0]
        remove_index = Math.floor(i / 2)

        assert skip_list.remove(remove_index)
        assert.equal skip_list.size(), i
        verify_list(skip_list)

      for i in [0..10]
        skip_list.insert(elements[i])
        assert.equal skip_list.size(), i + 1
        verify_list(skip_list)
