struct Variable 
    id          ::String
    domain      ::Domain
    tree        ::Tree
end

function Variable(id::String, min::Int, max::Int, tree::Tree)
    domain = Domain(collect(min:max), tree)
    return Variable(id, domain, tree)
end

function isAssigned(variable::Variable)
    return variable.domain.size.value == 1
end

function assign!(variable::Variable, value::Int)
    assign!(variable.domain, value)
end