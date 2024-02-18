function search!(model::Model, variableSelection::AbstractVariableSelection, valueSelection::AbstractValueSelection)
    toCall = Stack{Function}()

    currentStatus = DepthFirstSearch!(model, toCall, variableSelection, valueSelection)

    while !isempty(toCall)
        # println(currentStatus)

        if currentStatus == :SolutionFound
            break
        end

        currentProcedure = pop!(toCall)

        currentStatus::Union{Nothing, Symbol} = currentProcedure(model, currentStatus)
    end
end

function DepthFirstSearch!(model::Model, toCall::Stack{Function}, variableSelection::AbstractVariableSelection, valueSelection::AbstractValueSelection)
    feasible = AC3(model)
    
    if !feasible 
        return :Infeasible
    end

    if solutionFound(model)
        # return :SolutionFound
        displaySolution(model)
        println(" ")
        return :Infeasible
    end


    x = variableSelection(model)
    v = valueSelection(model, x)

    # println("var = ", x.id)
    # println("val = ", v)

    push!(toCall, (model, currentStatus) -> (restoreNode!(model.tree); :BackTracking))

    push!(toCall, (model, currentStatus) -> (remove!(x.domain, v); DepthFirstSearch!(model, toCall, variableSelection, valueSelection)))

    push!(toCall, (model, currentStatus) -> (saveNode!(model.tree); :SavingState))


    push!(toCall, (model, currentStatus) -> (restoreNode!(model.tree); :BackTracking))

    push!(toCall, (model, currentStatus) -> (assign!(x, v); DepthFirstSearch!(model, toCall, variableSelection, valueSelection)))

    push!(toCall, (model, currentStatus) -> (saveNode!(model.tree); :SavingState))

    return nothing

end

