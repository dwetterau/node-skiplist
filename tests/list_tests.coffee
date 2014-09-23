assert = require 'assert'
{SkipList} = require '../skip_list'
{Element} = require './test_element'

describe 'list_tests', () ->

  describe 'test find', () ->

  describe 'test insert', () ->
    it 'should handle inserting a single element', () ->
      element = new Element(1)
      skip_list = new SkipList()
      skip_list.insert(element)

      list = skip_list.to_list()
      assert.equal list.length, 1
      assert.equal list.length, skip_list.size()
      assert.equal list[0].element.compare(element), 0

    it 'should handle inserting elements and return them in sorted order', () ->
      elements = []
      skip_list = new SkipList()
      for i in [10..1]
        elements.unshift(new Element(i))
        skip_list.insert(elements[0])

      list = skip_list.to_list()
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
        skip_list.insert(new Element(i))

      for element, index in elements
        assert.equal skip_list.rank(index).compare(element), 0
