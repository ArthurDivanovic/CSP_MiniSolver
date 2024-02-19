struct Constraint 
    x       ::Variable
    y       ::Variable
    values  ::Vector{Tuple{Int64, Int64}}
end

include("different.jl")
include("alldifferent.jl")