function nQueens(n::Int, T::Type{<:AbstractConstraint})
    tree = Tree()
    model = Model(tree)

    X = Variable[]
    for i = 1:n
        x = Variable("x[$i]", 1, n, tree)
        addVariable!(model, x)
        push!(X, x)
    end

    addConstraint!(model, AllDifferent(X, T))

    for i = 1:n
        for j = i+1:n
            addConstraint!(model, NotEqualConstant(X[i], X[j], i, j, T))
            addConstraint!(model, NotEqualConstant(X[i], X[j], j, i, T))
        end
    end

    return model
end