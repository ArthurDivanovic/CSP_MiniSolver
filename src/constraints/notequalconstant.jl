function NotEqualConstant(x::Variable, y::Variable, xConst::Int, yConst::Int, ::Type{ConstraintTuple})
    
    xConstraint = ConstraintTuple(x, y)
    yConstraint = ConstraintTuple(y, x)

    xOffset = x.domain.offset
    yOffset = y.domain.offset

    for xValue in x.domain.values
        for yValue in y.domain.values
            if xValue + xOffset + xConst != yValue + yOffset + yConst
                push!(xConstraint.tuples, (xValue, yValue))
                push!(yConstraint.tuples, (yValue, xValue))
            end
        end
    end

    return AbstractConstraint[xConstraint, yConstraint]
end


function NotEqualConstant(x::Variable, y::Variable, xConst::Int, yConst::Int, ::Type{ConstraintMatrix})

    xConstraint = ConstraintMatrix(x, y)
    yConstraint = ConstraintMatrix(y, x)

    xOffset = x.domain.offset
    yOffset = y.domain.offset

    for xValue in x.domain.values
        for yValue in y.domain.values
            if xValue + xOffset + xConst != yValue + yOffset + yConst
                xConstraint.matrix[xValue, yValue] = 1
                yConstraint.matrix[yValue, xValue] = 1
            end
        end
    end

    return AbstractConstraint[xConstraint, yConstraint]
end