abstract type AbstractVariableSelection end

struct MinDomainVariableSelection <: AbstractVariableSelection end

function(::MinDomainVariableSelection)(model::Model)
    minSize = typemax(Int)
    selectedVariable = nothing
    for (id,variable) in model.variables
        if !isAssigned(variable) && variable.domain.size.value < minSize
            selectedVariable = variable
            minSize = variable.domain.size.value
        end
    end
    return selectedVariable
end

struct MostCenteredVariableSelection <: AbstractVariableSelection end

function (::MostCenteredVariableSelection)(model::Model)
    selectedId = nothing
    n = length(model.variables)

    bestScore = typemax(Int)

    for (id,variable) in model.variables
        if !isAssigned(variable) 
            idCol = parse(Int, match(r"[0-9]+", id).match)
            if abs(n/2 - idCol) < bestScore
                bestScore = abs(n/2 - idCol)
                selectedId = id
            end
        end 
    end
    return model.variables[selectedId]
end

struct RandomVariableSelection <: AbstractVariableSelection end

function (::RandomVariableSelection)(model::Model)
    notAssignedVariables = String[]
    for (id,variable) in model.variables
        if !isAssigned(variable) 
            push!(notAssignedVariables, id)
        end 
    end

    selectedId = notAssignedVariables[rand(1:length(notAssignedVariables))]
    return model.variables[selectedId]
end


struct SortedVariableSelection <: AbstractVariableSelection 
    sorting       ::Vector{String}

    function SortedVariableSelection(sorting::Vector{Int}, model::Model)

        variableName = ""
        bool = true
        tupleIds = String[]
        for (id,variable) in model.variables
            if isa(variable.domain, TupleDomain)
                push!(tupleIds, variable.id)
            end
            if bool && isa(variable.domain, Domain)
                variableName = split(id, "[")[1]
                bool = false
            end
        end

        sortingIds = String[]
        
        for idx in sorting
            push!(sortingIds, variableName*"[$idx]")
        end
        append!(sortingIds, tupleIds)

        return new(sortingIds)
    end
end

function (VS::SortedVariableSelection)(model::Model)
    id = VS.sorting[model.treeHeight.value]
    return model.variables[id]
end

function KnapsackVariableSelection(weights::Vector{Int}, utilities::Vector{Int}, model::Model)
    sorting = sortperm(utilities ./ weights, rev=true)
    return SortedVariableSelection(sorting, model)
end
