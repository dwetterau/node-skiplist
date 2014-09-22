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
      assert.equal list[0].element.compare(element), 0

    it 'should handle inserting elements and return them in sorted order', () ->
      elements = []
      skip_list = new SkipList()
      for i in [10..1]
        elements.unshift(new Element(i))
        skip_list.insert(elements[0])
        skip_list.visualize()

      list = skip_list.to_list()
      assert.equal list.length, elements.length
      for element, index in elements
        assert.equal list[index].element.compare(element), 0

