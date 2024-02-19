function different(x::Variable, y::Variable)

    xTuples = Tuple{Int,Int}[]
    yTuples = Tuple{Int,Int}[]

    for xValue in x.domain.values
        for yValue in y.domain.values
            if xValue != yValue
                push!(xTuples, (xValue, yValue))
                push!(yTuples, (yValue, xValue))
            end
        end
    end

    xConstraint = Constraint(x, y, xTuples)
    yConstraint = Constraint(y, x, yTuples)

    return [xConstraint, yConstraint]
end


function differentConstant(x::Variable, xConst::Int, y::Variable, yConst::Int)
    xTuples = Tuple{Int,Int}[]
    yTuples = Tuple{Int,Int}[]

    for xValue in x.domain.values
        for yValue in y.domain.values
            if xValue + xConst != yValue + yConst
                push!(xTuples, (xValue, yValue))
                push!(yTuples, (yValue, xValue))
            end
        end
    end

    xConstraint = Constraint(x, y, xTuples)
    yConstraint = Constraint(y, x, yTuples)

    return [xConstraint, yConstraint]
end