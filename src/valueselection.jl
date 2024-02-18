abstract type AbstractValueSelection end

struct MinDomainValueSelection <: AbstractValueSelection end

function(::MinDomainValueSelection)(model::Model, variable::Variable)
    minValue = typemax(Int)
    idx = 1
    while idx <= variable.domain.size.value
        if variable.domain.values[idx] < minValue
            minValue = variable.domain.values[idx]
        end
        idx += 1
    end
    return minValue
end