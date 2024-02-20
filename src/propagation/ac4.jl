struct AC4 <: AbstractAC end


function init_AC4(model::Model)
    
    Q = []
    S = Dict{Tuple{String,Int}, Vector{Tuple{String,Int}}}()
    Count = Dict{Tuple{String,String,Int},Int}()

    for constraint in model.constraints

        x = constraint.x
        y = constraint.y 

        for x_value in feasibleValues(x)
            total = 0

            for y_value in feasibleValues(y)

                if (x_value, y_value) in constraint.tuples
                    total += 1

                    if haskey(S, (y.id, y_value)) 
                        if !((x.id, x_value) in S[(y.id, y_value)])
                            push!(S[(y.id, y_value)], (x.id, x_value))
                        end
                    else
                        S[(y.id, y_value)] =  [(x.id, x_value)]
                    end

                end

            end
                
            Count[x.id, y.id, x_value] = total

            if total == 0
                remove!(x.domain, x_value)
                if !((x.id, x_value) in Q)
                    push!(Q, (x.id, x_value))
                end
            end

        end

    end 
    
    return Q, S, Count
end




function (::AC4)(model::Model)
    
    Q, S, Count = init_AC4(model)

    while !isempty(Q)

        y_id, y_value = pop!(Q)
        
        y = model.variables[y_id]
        # Check if the domain of y is empty
        if y.domain.size.value <= 0
            return false
        end

        if haskey(S, (y.id, y_value)) 

            for (x_id, x_value) in S[(y_id, y_value)]
                Count[x_id, y_id, x_value] = Count[x_id, y_id, x_value] - 1

                x = model.variables[x_id]
                if (Count[x_id, y_id, x_value] == 0) && (x_value in x.domain.values[1:x.domain.size.value])

                    remove!(x.domain, x_value)
                    # Check if the domain of x is empty
                    if x.domain.size.value <= 0
                        return false
                    end

                    if !((x_id, x_value) in Q)
                        push!(Q, (x_id, x_value))
                    end
                end

            end

        end
    end

    return true
end
