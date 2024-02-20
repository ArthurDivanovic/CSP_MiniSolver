mutable struct State{T}
    value       ::T
end

abstract type AbstractNodeValue end

struct NodeValue{T} <: AbstractNodeValue
    value       ::T
    state       ::State{T}
end


mutable struct Node
    values  ::Stack{AbstractNodeValue}
    Node() = new(Stack{AbstractNodeValue}())
end

mutable struct Tree
    current     ::Node
    queue       ::Stack{Node}
    Tree() = new(Node(), Stack{Node}())
end


function setValue!(tree::Tree, state::State{T}, value::T) where {T}
    if value != state.value
        push!(tree.current.values, NodeValue(state.value, state))
        state.value = value
    end
end

function saveNode!(tree::Tree)
    push!(tree.queue, tree.current)
    tree.current = Node()
end

function restoreNode!(tree::Tree)
    for nodeValue in tree.current.values
        nodeValue.state.value = nodeValue.value
    end

    if isempty(tree.queue)
        tree.current = Node()
    else
        tree.current = pop!(tree.queue)
    end
end