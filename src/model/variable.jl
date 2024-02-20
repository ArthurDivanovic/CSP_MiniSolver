struct Variable 
    id          ::String
    domain      ::Domain
    tree        ::Tree
end

function Variable(id::String, min::Int, max::Int, tree::Tree)
    domain = Domain(min, max, tree)
    return Variable(id, domain, tree)
end

function isAssigned(variable::Variable)
    return variable.domain.size.value == 1
end

function assign!(variable::Variable, value::Int)
    assign!(variable.domain, value)
end

function feasibleValues(variable::Variable)
    return variable.domain.values[1:variable.domain.size.value]
end