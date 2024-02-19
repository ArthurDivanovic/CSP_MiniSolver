function nQueens(n::Int)
    tree = Tree()
    model = Model(tree)

    X = Variable[]
    for i = 1:n
        x = Variable("x[$i]", 1, n, tree)
        addVariable!(model, x)
        push!(X, x)
    end

    addConstraint!(model, allDifferent(X))

    for i = 1:n
        for j = i+1:n
            addConstraint!(model, differentConstant(X[i], i, X[j], j))
            addConstraint!(model, differentConstant(X[i], j, X[j], i))
        end
    end

    return model
end