mutable struct Model
    variables       ::Dict{String, Variable}
    constraints     ::Array{Constraint}
    tree            ::Tree

    Model(tree::Tree) = new(Dict{String, Variable}(), Constraint[], tree)

    Model() = new(Dict{String, Variable}(), Constraint[], Tree())
end


function addVariable!(model::Model, variable::Variable)
    @assert(!haskey(model.variables, variable.id))
    model.variables[variable.id] = variable
end


function addVariable!(model::Model, variables::Vector{Variable})
    for variable in variables
        addVariable!(model, variable)
    end
end


function addConstraint!(model::Model, constraint::Constraint)
    push!(model.constraints, constraint)
end


function addConstraint!(model::Model, constraints::Vector{Constraint})
    append!(model.constraints, constraints)
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