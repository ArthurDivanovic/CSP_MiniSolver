function parse_graph(file_path::String)::Matrix{Int}
    file = open(file_path, "r")
    adj = Matrix{Int}(undef, 0, 0)

    for line in eachline(file)
        l = line[1]

        if l == 'c'
            continue
        end
        
        list = split(line, " ")
        if l == 'p'
            n = parse(Int, list[3])
            m = parse(Int, list[4])
            adj = zeros(Int, n, n)
        end

        if l == 'e'
            i = parse(Int, list[2])
            j = parse(Int, list[3])
            adj[i,j] = 1
            adj[j,i] = 1
        end
    end

    close(file)
    return adj
end


function graph_coloring(file_path::String, k::Int)
    adj = parse_graph(file_path)
    n = size(adj)[1]

    tree = Tree()
    model = Model(tree)

    C = Variable[]
    for i = 1:n
        if i == 1
            # Fix c[1] = 1 w.l.o.g
            c = Variable("c[$i]", 1, 1, tree)
            addVariable!(model, c)
            push!(C, c)
        else 
            c = Variable("c[$i]", 1, k, tree)
            addVariable!(model, c)
            push!(C, c)
        end
    end

    for i = 1:n
        for j = i+1:n
            if adj[i,j] == 1
                addConstraint!(model, different(C[i], C[j]))
            end
        end
    end

    return model
end