{SkipNode, SkipEdge} = require './nodes'

class SkipList
  constructor: () ->
    # TODO: Allow it to be constructed on a sorted list
    @heads = []
    @_new_head()

  _new_head: () ->
    new_head = new SkipNode()
    new_edge = new SkipEdge(0)
    new_edge.left_node = new_head
    new_head.set_next(null, new_edge, 0)
    @heads.push new_head

  # Inserts an element into the skip list in the proper sorted position. This position is determined
  # by calling the .compare() method on the element and expecting < 0 if it is smaller than the
  # other element, == 0 if it the same or > 0 if it is larger (similar to Java's compareTo).
  insert: (element) ->
    find_result = @find element
    left_node = find_result.element
    comparison = element.compare left_node.element
    if comparison == 0
      throw Error("Element already present")

    new_node = new SkipNode()
    new_node.element = element
    # Insert the element on the base level
    right_node = left_node.next()
    left_node.set_next(new_node, left_node.right_edge, 1)
    if right_node
      right_edge = new SkipEdge(1)
      new_node.set_next(right_node, right_edge, 1)

    # Use the magic factor 0.5
    current_head = 0
    while Math.random() < 0.5
      current_head += 1
      if current_head >= @heads.length
        @_new_head()
      previous = @heads[current_head]
      current = previous.next()
      current_index = 0
      while current and current_index < find_result.index
        current_index += previous.right_edge.distance
        previous = current
        current = previous.next()
      # Now we insert a new node between previous and current
      newer_node = new SkipNode()
      newer_node.element = element
      newer_node.down = new_node

      # previous is guaranteed to be nonnull and have a nonnull next edge
      # Calculate all of the new distances
      old_distance = previous.right_edge.distance
      left_index = current_index - old_distance
      new_index = find_result.index + 1
      left_distance = new_index - left_index
      previous.set_next(newer_node, previous.right_edge, left_distance)
      if current
        right_distance = old_distance - left_distance + 1
        right_edge = new SkipEdge(right_distance)
        newer_node.set_next(current, right_edge, right_distance)

      # Set the new node to the one at the last level before adding another
      new_node = newer_node

  # Traverses the skip list to find this element or the place it would be
  find: (element) ->
    previous = @heads[@heads.length - 1]
    current = previous.next()
    index = 0
    while true
      if not current
        # We reached the end of the list, try going down
        if previous.down
          previous = previous.down
          current = previous.next()
          continue
        else
          # We are at the bottom and at the end of the list
          return {'element': previous, 'index': index}
      comparison = current.element.compare(element)
      if comparison == 0
        # We found the element
        return {'element': current, 'index': index}
      else if comparison > 0
        # We are pointing at a larger element, go back.
        if previous.down
          previous = previous.down
          current = previous.next()
          continue
        else
          # We didn't find the element, return previous (right before where it would be)
          return {'element': previous, 'index': index}
      else
        # We are pointing at a smaller element, keep going at this level
        index += previous.right_edge.distance
        previous = current
        current = previous.next()

module.exports =
  SkipList: SkipList
