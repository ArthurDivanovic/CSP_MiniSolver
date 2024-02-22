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


function max_degree_node(adj::Matrix{Int})
    n = size(adj, 1)
    max_degree = 0
    max_degree_node_index = 0
    
    for i in 1:n
        degree = sum(adj[i, :])
        if degree > max_degree
            max_degree = degree
            max_degree_node_index = i
        end
    end
    
    return max_degree_node_index
end


function max_degree_neighbour(adj::Matrix{Int}, node::Int)
    n = size(adj, 1)
    max_degree = 0
    max_degree_node_index = 0

    for i in 1:n
        if adj[i,node] == 1
            degree = sum(adj[i, :])
            if degree > max_degree
                max_degree = degree
                max_degree_node_index = i
            end
        end
    end
    
    return max_degree_node_index

end


function graph_coloring(file_path::String, k::Int, T::Type{<:AbstractConstraint})
    adj = parse_graph(file_path)
    max_degree_node_idx = max_degree_node(adj)
    
    n = size(adj)[1]

    tree = Tree()
    model = Model(tree)

    C = Variable[]
    for i = 1:n
        if i == max_degree_node_idx
            c = Variable("c[$i]", 1, 1, tree)
            addVariable!(model, c)
            push!(C, c)
        elseif adj[i, max_degree_node_idx] == 1
            c = Variable("c[$i]", 2, k, tree)
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
                addConstraint!(model, NotEqual(C[i], C[j], T))
            end
        end
    end

    return model
end


# function graph_coloring(file_path::String, k::Int)
#     adj = parse_graph(file_path)
#     max_degree_node_idx = max_degree_node(adj)
#     max_degree_neighbour_idx = max_degree_neighbour(adj, max_degree_node_idx)
    
#     n = size(adj)[1]

#     tree = Tree()
#     model = Model(tree)

#     C = Variable[]
#     for i = 1:n
#         if i == max_degree_node_idx
#             # Fix c[1] = 1 w.l.o.g
#             c = Variable("c[$i]", 1, 1, tree)
#             addVariable!(model, c)
#             push!(C, c)
#         elseif i == max_degree_neighbour_idx
#             c = Variable("c[$i]", 2, 2, tree)
#             addVariable!(model, c)
#             push!(C, c)
#         else 
#             c = Variable("c[$i]", 1, k, tree)
#             addVariable!(model, c)
#             push!(C, c)
#         end
#     end

#     for i = 1:n

#         if adj[i, max_degree_node_idx] == 1
#             remove!(C[i].domain, 1)
#         end

#         if adj[i, max_degree_neighbour_idx] == 1
#             remove!(C[i].domain, 2)
#         end

#     end

#     for i = 1:n
#         for j = i+1:n
#             if adj[i,j] == 1
#                 addConstraint!(model, different(C[i], C[j]))
#             end
#         end
#     end

#     return model
# end

