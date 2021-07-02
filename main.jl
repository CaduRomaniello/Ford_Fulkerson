using Base
using Random
using JSON
using Printf
using PrettyTables

include("structs.jl")
include("functions.jl")

function main(ARGS)
    
    if (length(ARGS) != 3)
        println("Wrong parameters!")
        println("To execute type: ")
        println("julia main.jl file.json sourceName terminalName")
        return
    end

    aux = split(ARGS[1], ".")
    if (!(aux[2] == "JSON" || aux[2] == "json"))
        println("Parameter is not a JSON file")
        return
    end
    graphSource = ARGS[2]
    graphTarget = ARGS[3]
    dir = pwd()
    data = JSON.parse(open("$(dir)/JSON/$(ARGS[1])"))
    
    # Reading vertices
    vertices = Array{Vertex, 1}()
    readVertices(vertices, data)

    # Reading edges
    edges = Array{Edge, 1}()
    readEdges(edges, vertices, data)

    # Matching vertices and edges
    matchVerticesEdges(vertices, edges)

    # Finding the source and target vertices in the graph
    graphSource = findVertexByName(vertices, graphSource)
    graphTarget = findVertexByName(vertices, graphTarget)

    fordFulkerson(vertices, edges, graphSource, graphTarget)

end

main(ARGS)