struct Variable 
    id          ::String
    domain      ::Domain
    assigned    ::State{Bool}
    tree        ::Tree
end

function Variable(id::String, min::Int, max::Int, tree::Tree)
    domain = Domain(min, max, tree)
    return Variable(id, domain, State(false), tree)
end

function isAssigned(variable::Variable)
    return variable.assigned.value
end

function assign!(variable::Variable, value::Int)
    setValue!(variable.tree, variable.assigned, true)
    assign!(variable.domain, value)
end

function remove!(variable::Variable, value::Int)
    remove!(variable.domain, value)
end

function feasibleValues(variable::Variable)
    return variable.domain.values[1:variable.domain.size.value]
end