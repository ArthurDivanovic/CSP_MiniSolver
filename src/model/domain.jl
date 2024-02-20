struct Domain
    values      ::Array{Int}
    offset      ::Int
    indexes     ::Array{Int}
    size        ::Size
    tree        ::Tree
end

function Domain(min::Int, max::Int, tree::Tree)
    d = max-min+1
    values = collect(1:d)
    size = Size(d)
    offset = min - 1
    indexes = collect(1:d)
    return Domain(values, offset, indexes, size, tree)
end

function remove!(domain::Domain, value::Int)
    if value in domain
        v1 = value
        v2 = domain.values[domain.size.value]

        exchangeValues!(domain, v1, v2)

        setValue!(domain.tree, domain.size, domain.size.value-1)
    end
end

function exchangeValues!(domain::Domain, v1::Int, v2::Int)
    i1 = domain.indexes[v1]
    i2 = domain.indexes[v2]

    domain.values[i1] = v2
    domain.values[i2] = v1
    domain.indexes[v1] = i2
    domain.indexes[v2] = i1
end

function assign!(domain::Domain, value::Int)
    @assert(value in domain)

    exchangeValues!(domain, value, domain.values[1])

    setValue!(domain.tree, domain.size, 1)
end



function Base.in(value::Int, domain::Domain)
    #Check if value is in domain (constant time)
    value -= domain.offset
    return domain.indexes[value] <= domain.size.value
end

