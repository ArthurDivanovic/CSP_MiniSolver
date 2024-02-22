function Equal(x::Variable, y::Variable , ::Type{ConstraintTuple})
    
    xConstraint = ConstraintTuple(x, y)
    yConstraint = ConstraintTuple(y, x)

    xOffset = x.domain.offset
    yOffset = y.domain.offset

    for xValue in x.domain.values
        for yValue in y.domain.values
            if xValue + xOffset == yValue + yOffset
                push!(xConstraint.tuples, (xValue, yValue))
                push!(yConstraint.tuples, (yValue, xValue))
            end
        end
    end

    return AbstractConstraint[xConstraint, yConstraint]
end

function Equal(x::Variable, y::Variable , ::Type{ConstraintMatrix})

    xConstraint = ConstraintMatrix(x, y)
    yConstraint = ConstraintMatrix(y, x)

    xOffset = x.domain.offset
    yOffset = y.domain.offset

    for xValue in x.domain.values
        for yValue in y.domain.values
            if xValue + xOffset == yValue + yOffset
                xConstraint.matrix[xValue, yValue] = 1
                yConstraint.matrix[yValue, xValue] = 1
            end
        end
    end

    return AbstractConstraint[xConstraint, yConstraint]
end
