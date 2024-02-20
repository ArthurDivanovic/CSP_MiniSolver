function allDifferent(X::Vector{Variable}, T::Type{<:AbstractConstraint})
    constraints = AbstractConstraint[]
    for i = 1:length(X)
        for j = i+1:length(X)
            append!(constraints, different(X[i], X[j], T))
        end
    end

    return constraints
end