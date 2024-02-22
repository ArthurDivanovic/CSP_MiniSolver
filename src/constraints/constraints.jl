struct ConstraintTuple <: AbstractConstraint
    x           ::Variable
    y           ::Variable
    tuples      ::Vector{Tuple{Int64, Int64}}

    ConstraintTuple(x::Variable, y::Variable) = new(x, y, Tuple{Int64, Int64}[])
end

struct ConstraintMatrix <: AbstractConstraint
    x           ::Variable
    y           ::Variable
    matrix      ::BitMatrix

    ConstraintMatrix(x::Variable, y::Variable) = new(x, y, BitMatrix(zeros(length(x.domain.values), length(y.domain.values))))
end 


include("notequal.jl")
include("notequalconstant.jl")
include("equal.jl")
include("alldifferent.jl")
include("sum.jl")



# struct ConstraintBitArray <: AbstractConstraint
#     x           ::Variable
#     y           ::Variable
#     nbTuples    ::Int
#     xSupports   ::Dict{Int, BitArray}
#     ySupports   ::Dict{Int, BitArray}
# end

# function TupleToBitArray(constraint::ConstraintTuple)
#     m = length(constraint.tuples)
#     x = constraint.x
#     y = constraint.y

#     xSupports = Dict([v => BitArray(undef, m) for v in x.domain.values])
#     ySupports = Dict([v => BitArray(undef, m) for v in y.domain.values])

#     for (i,(xVal, yVal)) in enumerate(constraint.tuples)
#         xSupports[xVal][i] = 1
#         ySupports[yVal][i] = 1
#     end

#     return ConstraintBitArray(x, y, m, xSupports, ySupports)
# end