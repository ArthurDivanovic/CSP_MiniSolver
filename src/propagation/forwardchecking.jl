struct ForwardChecking end


function (::ForwardChecking)(model::Model)

    if isnothing(model.lastAssigned)
        return true
    end

    x = model.lastAssigned
    xVal = x.domain.values[1]
    feasible = true

    println("x = ", x.id)
    println("xVal = ", xVal)
    for constraint in model.constraints
        if x == constraint.x && !isAssigned(constraint.y)
            feasible = propagate!(constraint, xVal)

            if !feasible
                break
            end
        end
    end
    model.lastAssigned = nothing
    return feasible
end

function propagate!(constraint::ConstraintMatrix, xVal::Int)
    y = constraint.y
    println("y = ", y.id)
    for yVal in feasibleValues(y)
        if !constraint.matrix[xVal, yVal]
            println("yVal = ", yVal)
            remove!(y.domain, yVal)
        end
    end

    if y.domain.size.value == 0
        return false
    end
    return true
end

function propagate!(constraint::ConstraintTuple, xVal::Int)
    y = constraint.y
    for yVal in feasibleValues(y)
        if !((xVal, yVal) in constraint.tuples)
            remove!(y.domain, yVal)
        end
    end

    if y.domain.size.value == 0
        return false
    end
    return true
end
