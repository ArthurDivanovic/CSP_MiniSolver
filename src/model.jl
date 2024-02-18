mutable struct Model
    variables       ::Dict{String, Variable}
    constraints     ::Array{Constraint}
    tree            ::Tree

    Model(tree::Tree) = new(Dict{String, Variable}(), Constraint[], tree)
end

function addVariable!(model::Model, variable::Variable)
    @assert(!haskey(model.variables, variable.id))
    model.variables[variable.id] = variable
end

function addConstraint!(model::Model, constraint::Constraint)
    push!(model.constraints, constraint)
end

function solutionFound(model::Model)
    for (id,variable) in model.variables
        if !isAssigned(variable)
            return false
        end
    end
    return true
end

function displaySolution(model::Model)
    for (id,variable) in model.variables
        println(id, " = ", variable.domain.values[1])
    end
end