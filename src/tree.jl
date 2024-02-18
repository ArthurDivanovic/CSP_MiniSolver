mutable struct Size
    value       ::Int
end

struct NodeValue
    value       ::Int
    size        ::Size
end


mutable struct Node
    values  ::Stack{NodeValue}
    Node() = new(Stack{NodeValue}())
end

mutable struct Tree
    current     ::Node
    queue       ::Stack{Node}
    Tree() = new(Node(), Stack{Node}())
end


function setValue!(tree::Tree, size::Size, value::Int)
    if value != size.value
        push!(tree.current.values, NodeValue(size.value, size))
        size.value = value
    end
end

function saveNode!(tree::Tree)
    push!(tree.queue, tree.current)
    tree.current = Node()
end

function restoreNode!(tree::Tree)
    for nodeValue in tree.current.values
        nodeValue.size.value = nodeValue.value
    end

    if isempty(tree.queue)
        tree.current = Node()
    else
        tree.current = pop!(tree.queue)
    end
end