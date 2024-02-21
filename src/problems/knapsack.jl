function parse_knapsack(file_path::String)::Tuple{Int, Int, Vector{Int}, Vector{Int}}
    file = open(file_path, "r")
    object_weights = []
    object_utilities = []
    n = 0
    wmax = 0

    for (i,line) in enumerate(eachline(file))
        numbers = split(line)

        if parse(Int, numbers[1]) == 0
            return n, wmax, object_utilities, object_weights
        end

        if i == 1
            n = parse(Int, numbers[1])
            wmax = parse(Int, numbers[2])
        else
            push!(object_utilities, parse(Int, numbers[1]))
            push!(object_weights, parse(Int, numbers[2]))
        end

    end

    close(file)
    return n, wmax, object_utilities, object_weights
end


function knapsack(filepath::String, k::Int, T::Type{<:AbstractConstraint})
    n, wmax, object_utilities, object_weights = parse_knapsack(filepath)    

    tree = Tree()
    model = Model(tree)

    X = Variable[]
    for i = 1:n
        x = Variable("x[$i]", 0, 1, tree)
        addVariable!(model, x)
        push!(X, x)
    end

    # Weight constraint 
    weight_constraints, weight_s = sumConstant(X, object_weights, wmax, <=)
    weight_s.id = "sum_weight"
    addVariable!(model, weight_s)
    addConstraint!(model, weight_constraints)

    # Utility constraint
    utility_constraints, utility_s = sumConstant(X, object_utilities, k, >=)
    utility_s.id = "sum_utility"
    addVariable!(model, utility_s)
    addConstraint!(model, utility_constraints)

    return model
end


