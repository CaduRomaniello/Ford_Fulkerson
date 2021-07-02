using Random

mutable struct Stamp
    predecessor::Int64
    edgeDirection::String
    improvement::Int64

    Stamp() = new()
    Stamp(predecessor, edgeDirection, improvement) = new(predecessor, edgeDirection, improvement)
end

stampOrNothing = Union{Stamp, Nothing}

mutable struct Edge
    id::Int64
    name::String
    origin::Int64
    destiny::Int64
    inferiorLimit::Int64
    superiorLimit::Int64
    currentFlow::Int64

    direct::Bool
    indirect::Bool

    Edge() = new()
    Edge(id, name, origin, destiny, inferiorLimit, superiorLimit, current) = new(id, name, origin, destiny, inferiorLimit, superiorLimit, current, true, false)
end

mutable struct Vertex
    id::Int64
    name::String
    edges::Array{Edge, 1}
    stamp::stampOrNothing

    Vertex() = new()
    Vertex(id, name, edges) = new(id, name, edges, nothing)
end