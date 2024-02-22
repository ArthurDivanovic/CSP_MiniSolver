# CSP_MiniSolver

This repository presents a collaborative work by Arthur Divanovic and Axel Navarro.

The aim of the project is to implement a generic CSP solver with binary constraints and integer variables. The domains of the variables will be finite. The structure allows to model and solve such a CSP. Several consistency methods are also implemented. The performances of the solver are assessed on small problems.

## Table of Contents

1. [Introduction](#1-introduction)
2. [Installation](#2-installation)
3. [Structure and Documentation](#3-structure-and-documentation)
4. [Use](#4-use)

## 1. Introduction

The goal of this repository is to gather all the functions required to design a solver for binary CSP. The solver can be used to solve three classical decision problems: n-Queens, Graph Coloring and Knapsack.

This repository can be divided into two main folders:

- **src**: functions used for the design of the solver.
- **data**: instances of graph coloring and knapsack problems.

In addition to these folders, three notebooks are provided (one for each one of the problems evoked above). The notebooks provide examples of resolutions of the three problems studied.


## 2. Installation

This repository can be cloned directly from this webpage.

## 3. Structure and Documentation



### 3.1 src folder

This folder contains all the files defining the binary CSP solver.

The file `main.jl` gathers all the necessary imports used throughout the project. The file `search.jl` contains a search function, that given:
- a _Model_ that represents a problem to solve,  
- a variable selection method,
- a value selection method,
- and a propagation function,
launches the resolution of a problem and returns a solution if there exists one.

The rest of the folder is divided into five sub-folders:

#### 3.1.a constraints

- `constraints.jl`: defines the _Constraints_ structure that can be represented as a Boolean matrix or as a list of tuples in the extensive form.
- `alldifferent.jl`: defines the all-different constraint for a vector of variables X.
- `equal.jl`: defines the constraint $x = y$ for two variables x and y.
- `notequal.jl`:  defines the constraint $x \neq y$ for two variables x and y.
- `notequalconstant.jl`: defines the constraint $$x + c_1 \neq y + c_2$ for two variables x and y and two constants $c_1$ and $c_2$.
- `sum.jl`: defines the sum constraint. Given a vector of variables X, a vector of weights w, a relational operator $\odot$ and a constant k: $w^{\top}X \odot k$.


#### 3.1.b model

- `model.jl`: defines the _Model_ structure that contains the attributes variables, constraints, lastAssigned and tree.
- `domain.jl`: defines the _Domain_ structure that contains the attributes values, offset, indexes, size and tree.
- `tree.jl`: defines the _Tree_ structure that represents the search tree.
- `variable.jl`: defines the _Variable_ structure that contains the attributes id domain, assigned and tree.

#### 3.1.c model

This sub-folder gathers the pre-processing and solving algorithms for each one of the three problems considered.

- `problems.jl`: gathers necessary imports.
- `coloring.jl`: gathers a parser for the instances provided in the data/coloring folder, a symmetry-breaking function and solving wrapper for the graph coloring problem.
- `nqueens.jl`: gathers a solving wrapper for the N-Queens problem.
- `knapsack .jl`: gathers a parser for the instances provided in the data/knapsack folder and solving wrapper for the knapsack problem.

#### 3.1.d propagation

This sub-folder gathers the propagation methods that can be used in the solver: the classical AC3, AC4 and ForwardChecking algorithms.

- `propagation.jl`: gathers necessary imports.
- `ac3.jl`: implementation of the AC3 algorithm, that uses arc-consistency to update the domains of the variables of a model.
- `ac4.jl`: implementation of the AC4 algorithm, which has the same purpose as AC3.
- `forwardchecking .jl`: implementation of the Forward Checking algorithm, to update the domains of the variables of a model.

#### 3.1.e strategies

This sub-folder gathers the variable selection and value selection methods that can be used in the solver.

- `valueselection.jl`: gathers various value selection methods: MinDomainValueSelection (smallest value in the domain), RandomValueSelection (random value) and MaxDomainValueSelection (largest value in the domain).
- `variableselection.jl`: gathers various variable selection methods: MinDomainVariableSelection (variable with the shortest domain), MostCenteredVariableSelection (variable with the most centered domain), RandomVariableSelection (random variable), SortedVariableSelection (selection given a provided order _sorting_) and KnapsackVariableSelection (variant of SortedVariableSelection withthe order given by the utility / weight ratio in the decreasing order).

### 3.2 data

The data folder contains `.txt` files for the graph coloring and knapsack problems. Such files can be interpreteed by the problem-specific parsing algorithms evoked above. Please remark that the instanc eof an N-Queens problem is only an integer, that why the data folder doesn't contain a nqueens sub-folder.


## 4. Use

Here is an example for the N-Queens problem. 

1. Initialize a Model object

```julia
n = 10
ConstraintType = ConstraintMatrix # Constraints are represented as a boolean matrix associating the values of the two variables
model = nQueens(n, ConstraintType) # construction of the model
variableSelection = MinDomainVariableSelection() # the variable with the shortest domain will be selected first
valueSelection = MinDomainValueSelection() # the smallest value of the selected variable's domain will be selected first
AC = nothing # No arc-consistency algorithm is used
FC = ForwardChecking() # The Forward Checking Algorithm is used
```

2.Launch the resolution
```julia
search!(model, variableSelection, valueSelection, AC, FC)
```

3.Recover the solution vector
```julia
v = getSolutionVector(model)
```



