include("tree.jl")
include("domain.jl")
include("variable.jl")

abstract type AbstractConstraint end

mutable struct Model
    variables       ::Dict{String, Variable}
    constraints     ::Array{AbstractConstraint}
    lastAssigned    ::Union{Variable,Nothing}
    tree            ::Tree

    Model(tree::Tree) = new(Dict{String, Variable}(), AbstractConstraint[], nothing, tree)

    Model() = new(Dict{String, Variable}(), AbstractConstraint[], nothing, Tree())
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


function addConstraint!(model::Model, constraint::AbstractConstraint)
    push!(model.constraints, constraint)
end


function addConstraint!(model::Model, constraints::Vector{AbstractConstraint})
    append!(model.constraints, constraints)
end

function assign!(model::Model, variable::Variable, value::Int)
    model.lastAssigned = variable
    assign!(variable, value)
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
        println(id, " = ", value(variable))
    end
end

function getSolutionVector(model::Model)
    solutions = zeros(Int, length(model.variables))
    count = 0
    for (id,variable) in model.variables
        m = match(r"[0-9]+", id)
        if !isnothing(m)
            idx = parse(Int, m.match)
            solutions[idx] = value(variable)
            count += 1
        end
    end
    return solutions[1:count]
end