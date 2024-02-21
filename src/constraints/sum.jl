# Définir une fonction pour générer le produit cartésien d'ensembles
function produit_cartesien(ensembles...)
    if isempty(ensembles)
        return []
    end

    # Initialiser le produit cartésien avec le premier ensemble
    resultat = collect(ensembles[1])

    # Parcourir les ensembles restants
    for ensemble in ensembles[2:end]
        # Créer une nouvelle liste pour stocker les tuples du produit cartésien
        nouveau_resultat = Tuple[]

        # Parcourir les éléments de l'ensemble actuel
        for element in ensemble
            # Ajouter chaque tuple du produit cartésien actuel avec l'élément actuel de l'ensemble
            for tuple in resultat
                push!(nouveau_resultat, (tuple..., element))
            end
        end

        # Mettre à jour le résultat avec le nouveau résultat
        resultat = nouveau_resultat
    end

    return resultat
end

function filterTuples(tuples::Vector{Tuple}, weights::Vector{Int}, constant::Int, operator::Function)
    final_tuples = Tuple[]
    for tuple in tuples
        if operator(scalarProduct(weights, tuple), constant)
            push!(final_tuples, tuple)
        end
    end
    return final_tuples
end

function scalarProduct(x::Union{Tuple, Vector{Int}}, y::Union{Tuple, Vector{Int}})
    @assert(length(x) == length(y))
    sp = 0
    for i = 1:length(x)
        sp += x[i]*y[i]
    end
    return sp
end


function sumConstant(X::Vector{Variable}, weights::Union{Nothing,Vector{Int}}, constant::Int, operator::Function)
    domains = Vector{Int}[]

    if isnothing(weights)
        weights = ones(Int, length(X))
    else
        @assert(length(weights) == length(X))
    end

    offsetSum = 0
    for (i,x) in enumerate(X)
        push!(domains, x.domain.values)
        offsetSum += weights[i] * x.domain.offset
    end

    tuples = produit_cartesien(domains...)
    tuples = filterTuples(tuples, weights, constant - offsetSum, operator)
    
    s = Variable("sum("*join([x.id for x in X], ", ")*")", tuples, X[1].tree)

    constraints = AbstractConstraint[]
    for (idx,x) in enumerate(X)
        xConstraint = ConstraintMatrix(x, s)
        sConstraint = ConstraintMatrix(s, x)
        for (i,xVal) in enumerate(x.domain.values)
            for (j,tuple) in enumerate(tuples)
                if tuple[idx] == xVal && operator(scalarProduct(weights, tuple) + offsetSum, constant)
                    xConstraint.matrix[i,j] = 1
                    sConstraint.matrix[j,i] = 1
                end
            end
        end
        push!(constraints, xConstraint)
        push!(constraints, sConstraint)
    end
    return constraints
end