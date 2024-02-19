function allDifferent(X::Vector{Variable})
    constraints = Constraint[]
    for i = 1:length(X)
        for j = i+1:length(X)
            append!(constraints, different(X[i], X[j]))
        end
    end
    return constraints
end