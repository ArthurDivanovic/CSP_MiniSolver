function search!(model::Model, variableSelection::AbstractVariableSelection, valueSelection::AbstractValueSelection, AC::Union{Nothing,<:AbstractAC}, FC::Union{Nothing, ForwardChecking})
    toCall = Stack{Function}()

    currentStatus = DepthFirstSearch!(model, toCall, variableSelection, valueSelection, AC, FC)

    while !isempty(toCall)
        # println(currentStatus)
        # println(model.treeHeight.value)

        if currentStatus == :SolutionFound
            break
        end

        currentProcedure = pop!(toCall)

        currentStatus::Union{Nothing, Symbol} = currentProcedure(model, currentStatus)
    end

    if currentStatus != :SolutionFound
        return :Infeasible
    end
    return :SolutionFound
end

function DepthFirstSearch!(model::Model, toCall::Stack{Function}, variableSelection::AbstractVariableSelection, valueSelection::AbstractValueSelection, AC::Union{Nothing,<:AbstractAC}, FC::Union{Nothing, ForwardChecking})
    
    if !isnothing(AC)
        feasible = AC(model)
        if !feasible 
            return :Infeasible
        end
    end

    if !isnothing(FC)
        feasible = FC(model)
        if !feasible 
            return :Infeasible
        end
    end

    if solutionFound(model)
        # displaySolution(model)
        return :SolutionFound
    end

    x = variableSelection(model)
    v = valueSelection(model, x)


    push!(toCall, (model, currentStatus) -> (restoreNode!(model.tree); :BackTracking))

    push!(toCall, (model, currentStatus) -> (remove!(x.domain, v); DepthFirstSearch!(model, toCall, variableSelection, valueSelection, AC, FC)))

    push!(toCall, (model, currentStatus) -> (saveNode!(model.tree); :SavingState))


    push!(toCall, (model, currentStatus) -> (restoreNode!(model.tree); :BackTracking))

    push!(toCall, (model, currentStatus) -> (assign!(model, x, v); DepthFirstSearch!(model, toCall, variableSelection, valueSelection, AC, FC)))

    push!(toCall, (model, currentStatus) -> (saveNode!(model.tree); :SavingState))

    return nothing

end

