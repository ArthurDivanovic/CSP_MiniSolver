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