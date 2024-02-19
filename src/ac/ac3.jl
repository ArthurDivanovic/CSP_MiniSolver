struct AC3 <: AbstractAC end


function(::AC3)(model::Model)
    
    to_test = []

    for constraint in model.constraints
        push!(to_test, constraint)
    end

    while !isempty(to_test)

        constraint = pop!(to_test)
        x = constraint.x
        y = constraint.y

        for x_value in x.domain.values[1:x.domain.size.value]

            supported = false
            # Check if the value of x is supported by a value of y
            for y_value in y.domain.values[1:y.domain.size.value]
                if (x_value, y_value) in constraint.values
                    supported = true
                    break
                end
            end

            if !supported
                
                # Remove the non-supported value of x
                remove!(x.domain, x_value)
                # Check if the domain of x is empty
                if x.domain.size.value == 0
                    return false
                end

                # Add the constraints impacted by the removal
                for new_constraint in model.constraints
                    if (x.id == new_constraint.y.id) && (new_constraint.x.id != constraint.y.id) && !(new_constraint in to_test)
                        push!(to_test, new_constraint)
                    end
                end

            end

        end

    end

    return true
end