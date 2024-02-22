# CSP_MiniSolver

This repository is a collaborative effort by Arthur Divanovic and Axel Navarro.

The objective of this project is to develop a generic CSP solver capable of handling binary constraints and integer variables. The solver is designed to work with finite domains for the variables. It provides a flexible structure for modeling and solving CSPs, and includes several consistency methods. The solver's performance is evaluated using small-scale problems.

## Table of Contents

1. [Introduction](#1-introduction)
2. [Installation](#2-installation)
3. [Structure and Documentation](#3-structure-and-documentation)
4. [Use](#4-use)

## 1. Introduction

This repository aims to consolidate all the necessary functions for designing a solver for binary CSPs. The solver is capable of addressing three classical decision problems: n-Queens, Graph Coloring, and Knapsack.

The repository is organized into two main directories:

- **src**: Contains essential functions for the solver's construction.
- **data**: Houses instances of graph coloring and knapsack problems.

Additionally, three notebooks are included (one for each of the aforementioned problems), offering practical examples of solving these problems using the provided solver.


## 2. Installation

This repository can be cloned directly from this webpage.

## 3. Structure and Documentation

### 3.1 src folder

This directory encompasses all the files that define the binary CSP solver.

The file `main.jl` This file consolidates all the essential imports utilized throughout the project. The file `search.jl` This file houses a search function. Given:
- a _Model_ representing a problem to solve,
- a variable selection method,
- a value selection method,
- and a propagation function,
it initiates the resolution of a problem and returns a solution if one exists.

The remainder of the directory is subdivided into five subdirectories:

#### 3.1.a constraints

- `constraints.jl`: Defines the Constraints structure, which can be represented as a Boolean matrix or as a list of tuples in the extensive form.
- `alldifferent.jl`: Defines the all-different constraint for a vector of variables X.
- `equal.jl`: Defines the constraint $x = y$ for two variables x and y.
- `notequal.jl`:  Defines the constraint $x \neq y$ for two variables x and y.
- `notequalconstant.jl`: Defines the constraint $x + c_1 \neq y + c_2$ for two variables x and y and two constants $c_1$ and $c_2$.
- `sum.jl`: Defines the weighted sum constraint. Given a vector of variables X, a vector of weights w, a relational operator $\odot$ and a constant k: $w^{\top}X \odot k$.


#### 3.1.b model

- `model.jl`: Defines the _Model_ structure, which contains the attributes variables, constraints, lastAssigned, and tree.
- `domain.jl`: Defines the _Domain_ structure, which contains the attributes values, offset, indexes, size, and tree.
- `tree.jl`: Defines the _Tree_ structure, which represents the search tree.
- `variable.jl`: Defines the _Variable_ structure, which contains the attributes id, domain, assigned, and tree.

#### 3.1.c model

This sub-folder contains the pre-processing and solving algorithms for each of the three problems considered.

- `problems.jl`: Gathers necessary imports.
- `coloring.jl`: Gathers a parser for the instances provided in the data/coloring folder, a symmetry-breaking function, and a solving wrapper for the graph coloring problem.
- `nqueens.jl`: Gathers a solving wrapper for the N-Queens problem.
- `knapsack .jl`: Gathers a parser for the instances provided in the data/knapsack folder and a solving wrapper for the knapsack problem.

#### 3.1.d propagation

This sub-folder contains the propagation methods that can be utilized in the solver: the classical AC3, AC4, and Forward Checking algorithms.

- `propagation.jl`: Gathers necessary imports.
- `ac3.jl`: Implements the AC3 algorithm, which uses arc-consistency to update the domains of the variables of a model.
- `ac4.jl`: Implements the AC4 algorithm, which serves the same purpose as AC3.
- `forwardchecking .jl`: Implements the Forward Checking algorithm, which updates the domains of the variables of a model.

#### 3.1.e strategies

This sub-folder contains the variable selection and value selection methods that can be employed in the solver.

- `valueselection.jl`: Gathers various value selection methods: MinDomainValueSelection (smallest value in the domain), RandomValueSelection (random value), and MaxDomainValueSelection (largest value in the domain).
- `variableselection.jl`: Gathers various variable selection methods: MinDomainVariableSelection (variable with the shortest domain), MostCenteredVariableSelection (variable with the most centered domain), RandomVariableSelection (random variable), SortedVariableSelection (selection given a provided order sorting), and KnapsackVariableSelection (variant of SortedVariableSelection with the order given by the utility / weight ratio in the decreasing order).

### 3.2 data

The data folder contains .txt files for the graph coloring and knapsack problems. These files can be interpreted by the problem-specific parsing algorithms mentioned above. It's important to note that the instance of an N-Queens problem is only an integer, which is why the data folder doesn't contain an nqueens sub-folder.


## 4. Use

Let us consider an example of a small problem. 

The problem has three variables:
- $x \in [1,4]$,
- $y \in [3,5]$,
- $z \in [2,8]$.

The constraints are:
- $x \neq y$,
- $x = z$.

0. Imports

```julia
include("src/main.jl")
```

1. Initialize a _Model_ object

```julia
tree = Tree()
model = Model(tree)
```

2. Add variables

```julia
x = Variable("x", 1, 4, tree)
y = Variable("y", 3, 5, tree)
z = Variable("z", 2, 8, tree)
addVariable!(model, [x,y,z])
```

3. Add constraints

```julia
C1 = NotEqual(x, y, ConstraintMatrix)
C2 = Equal(x, z, ConstraintMatrix)
addConstraint!(model, C1)
addConstraint!(model, C2)
```

4. Choose variable selection, value selection and propagation methods

```julia
variableSelection = MinDomainVariableSelection()
valueSelection = MinDomainValueSelection()
AC = AC3()
FC = ForwardChecking()
```

5.Launch the resolution
```julia
search!(model, variableSelection, valueSelection, AC, FC)
```

6.Display the solution 
```julia
displaySolution(model)
```



