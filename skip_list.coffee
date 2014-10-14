{SkipNode, SkipEdge} = require './nodes'

class SkipList
  constructor: () ->
    # TODO: Allow it to be constructed on a sorted list
    @_heads = []
    @_new_head()
    @_size = 0

  _new_head: () ->
    new_head = new SkipNode()
    new_edge = new SkipEdge(0)
    new_head.set_next(null, new_edge, 1)
    if @_heads.length
      new_head.down = @_heads[@_heads.length - 1]
    @_heads.push new_head

  # Return the current size of the list
  size: () ->
    return @_size

  # Inserts an element into the skip list in the proper sorted position. This position is determined
  # by calling the .compare() method on the element and expecting < 0 if it is smaller than the
  # other element, == 0 if it the same or > 0 if it is larger (similar to Java's compareTo).
  insert: (element) ->
    find_result = @_find element
    left_node = find_result.node
    if left_node.element
      comparison = element.compare left_node.element
      if comparison == 0
        throw Error("Element already present")

    # We are going to insert an element, increment the size
    @_size += 1
    new_node = new SkipNode()
    new_node.element = element

    # Insert the element on the base level
    right_node = left_node.next()
    left_node.set_next(new_node, left_node.right_edge, 1)
    right_edge = new SkipEdge(1)
    if right_node
      new_node.set_next(right_node, right_edge, 1)
    else
      new_node.set_next(null, right_edge, 1)

    # Use the magic factor 0.5
    current_head = 1
    while Math.random() < 0.5
      if current_head == @_heads.length
        @_new_head()
      previous = @_heads[current_head]
      current = previous.next()
      current_index = previous.right_edge.distance - 1
      while current and current.element.compare(element) < 0
        previous = current
        current = previous.next()
        current_index += previous.right_edge.distance
      # Now we insert a new node between previous and current
      newer_node = new SkipNode()
      newer_node.element = element
      newer_node.down = new_node

      # previous is guaranteed to be nonnull and have a nonnull next edge
      # Calculate all of the new distances
      old_distance = previous.right_edge.distance
      left_index = current_index - previous.right_edge.distance
      new_index = find_result.index
      left_distance = new_index - left_index + 1
      previous.set_next(newer_node, previous.right_edge, left_distance)
      if current
        right_distance = old_distance - left_distance + 1
        right_edge = new SkipEdge(right_distance)
        newer_node.set_next(current, right_edge, right_distance)
      else
        right_edge = new SkipEdge(1)
        newer_node.set_next(null, right_edge, 1)

      # Set the new node to the one at the last level before adding another
      new_node = newer_node
      current_head += 1

    # Increment the distance of all the higher level edges
    while current_head < @_heads.length
      previous = @_heads[current_head]
      current = previous.next()
      while current and current.element.compare(element) < 0
        previous = current
        current = previous.next()
      if previous.right_edge.right_node
        previous.set_next(current, previous.right_edge, previous.right_edge.distance + 1)
      current_head += 1

  # Return the index of the given element or -1 if it isn't present
  find: (element) ->
    result = @_find element
    if result.node.element.compare(element) != 0
      return -1
    return result.index

  # Return the element at the given index or null if it is out of range
  rank: (index) ->
    # Check if the index is out of range
    if index < 0 or index >= @_size
      return null

    result = @_rank(index)
    return result.element;

  # Remove the element at the specified index
  remove: (index) ->
    if index < 0 or index >= @_size
      return false

    # Get the frontier of nodes to the left of the target to remove
    {element, frontier} = @_rank(index - 1)
    target_element = frontier[frontier.length - 1].next().element

    for node in frontier
      # If the next node is null, we are at the end of the list, nothing to do here.
      if not node.next()
        continue

      # Determine if the next node is the node we are deleting
      if index == 0
        next_past_target = node.right_edge.distance > 1
      else if target_element
        next_past_target = node.next().element.compare(target_element) > 0
      else
        next_past_target = false
      # If the next node from this one is past the target, just subtract from distance
      if next_past_target
        node.right_edge.distance -= 1
      else
        # If we are removing the node to the right, set this right pointer across and subtract one from the
        # total distance.
        far_edge = node.next().right_edge
        if not node.element and not far_edge.right_node
          # We are removing the first node after a head, if it doesn't have a next, remove the head
          @_heads.pop()
        else
          distance = if not far_edge.right_node then 1 else far_edge.distance + node.right_edge.distance - 1
          node.set_next(far_edge.right_node, node.right_edge, distance)

    # We have removed a node, subtract from the size
    @_size -= 1

    # If removing this element caused the size of the list to be zero, push on a new head.
    if @_size == 0
      @_new_head()
    return true

  # Look for the element at this index, keep track of the nodes on each level that are on the frontier
  _rank: (index) ->
    frontier = []

    search = (node, num_left) ->
      if num_left == 0
        frontier.push(node)
        if node.down
          return search(node.down, 0)
        else
          return node.element
      if node.right_edge.distance <= num_left and node.next()
        return search(node.next(), num_left - node.right_edge.distance)
      else
        frontier.push(node)
        return search(node.down, num_left)

    num_left = index + 1
    first = @_heads[@_heads.length - 1]
    element = search(first, num_left)
    return {element, frontier}

  # Traverses the skip list to find this element or the place it would be
  _find: (element) ->
    previous = @_heads[@_heads.length - 1]
    current = previous.next()
    index = -1
    while true
      if not current
        # We reached the end of the list, try going down
        if previous.down
          previous = previous.down
          current = previous.next()
          continue
        else
          # We are at the bottom and at the end of the list
          return {'node': previous, 'index': index}
      comparison = current.element.compare(element)
      if comparison == 0
        index += previous.right_edge.distance
        # We found the element, go all the way down first
        while current.down
          current = current.down
        return {'node': current, 'index': index}
      else if comparison > 0
        # We are pointing at a larger element, go back.
        if previous.down
          previous = previous.down
          current = previous.next()
          continue
        else
          # We didn't find the element, return previous (right before where it would be)
          return {'node': previous, 'index': index}
      else
        # We are pointing at a smaller element, keep going at this level
        index += previous.right_edge.distance
        previous = current
        current = previous.next()

  _to_list: () ->
    element_list = []
    current = @_heads[0].next()
    while current
      element_list.push current
      current = current.next()
    return element_list

  to_list: () ->
    return node.element for node in @_to_list()

  visualize: () ->
    console.log "################~BEGIN~##############"
    for head, index in @_heads
      current = head.next()
      row = index + '=' + head.right_edge.distance + '='
      while current
        row += '(' + current.element.value + ')'
        if current.down
          row += 'd'
        if current.right_edge
          row += '-' + current.right_edge.distance + '-'
        current = current.next()
      console.log row
    console.log "################~END~##############"

module.exports =
  SkipList: SkipList
