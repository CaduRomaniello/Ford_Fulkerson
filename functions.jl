function readVertices(vertices, data)
    for i = 1:length(data["vertices"])
        
        name = data["vertices"][i]["name"]
        x = Array{Edge, 1}()
        aux = Vertex(i, name, Array{Edge, 1}())
        push!(vertices, aux)
        
    end
end

function readEdges(edges, vertices, data)
    for i = 1:length(data["edges"])

        name = data["edges"][i]["name"]
        origin = data["edges"][i]["origin"]
        destiny = data["edges"][i]["destiny"]
        inferiorLimit = data["edges"][i]["inferiorLimit"]
        superiorLimit = data["edges"][i]["superiorLimit"]
        current = data["edges"][i]["viableFlow"]
        
        # Looking for origin and destiny vertices to catch their id
        ori = -1
        dest = -1
        for j = 1:length(vertices)
            if (origin == vertices[j].name)
                ori = vertices[j].id
            end
            
            if (destiny == vertices[j].name)
                dest = vertices[j].id
            end
            
            if (ori != -1 && dest != -1)
                break
            end
        end

        # Creating edges
        aux = Edge(i, name, ori, dest, inferiorLimit, superiorLimit, current)
        push!(edges, aux)

    end
end

function matchVerticesEdges(vertices, edges)

    for i = 1:length(edges)
        findOri = false
        findDest = false
        posOri = -1
        posDest = -1

        for j = 1:length(vertices)
            if (vertices[j].id == edges[i].origin)
                findOri = true
                posOri = j
            end

            if (vertices[j].id == edges[i].destiny)
                findDest = true
                posDest = j
            end

            if (findOri && findDest)
                break
            end
        end

        push!(vertices[posOri].edges, edges[i])
        push!(vertices[posDest].edges, edges[i])
    end

end

function BFS(vertices::Array{Vertex, 1}, edges::Array{Edge, 1}, source::Int64, terminal::Int64)

    queue = [source]
    checkEdge = falses(length(edges))
    checkVertex = falses(length(vertices))
    checkVertex[source] = true
    atualVertex = source

    while (length(queue) != 0)

        atualVertex = queue[1]
        deleteat!(queue, 1)

        for i in vertices[atualVertex].edges
            destinyVertex = -1
            if (i.origin == atualVertex && !(i.direct))
                continue
            elseif (i.destiny == atualVertex && !(i.indirect))
                continue
            elseif (i.origin == atualVertex && i.direct)
                destinyVertex = i.destiny
            elseif (i.destiny == atualVertex && i.indirect)
                destinyVertex = i.origin
            end

            if (!checkVertex[destinyVertex])
                checkEdge[i.id] = true
                checkVertex[destinyVertex] = true
                if (destinyVertex != terminal)
                    push!(queue, destinyVertex)    
                end
            else
                if (!checkEdge[i.id])
                    checkEdge[i.id] = true
                end
            end
        end

    end

    return checkVertex[terminal]
    
end

function printFinalEdgesFlow(vertices, edges)

    local columns = 7
    local rows  = length(edges)

    local data  = Array{Any, 2}(undef, rows, columns)
    local header  = ["Id", "Name", "Origin", "Destiny", "Flux", "InferiorLimit", "SuperiorLimit"]
    local alignments = [:l]

    for i = 2:columns
        push!(alignments, :c)
    end

    for i = 1:rows
        data[i, 1] = edges[i].id
        data[i, 2] = edges[i].name
        data[i, 3] = vertices[edges[i].origin].name
        data[i, 4] = vertices[edges[i].destiny].name
        data[i, 5] = edges[i].currentFlow
        data[i, 6] = edges[i].inferiorLimit
        data[i, 7] = edges[i].superiorLimit
    end
    pretty_table(data; header = header, alignment = alignments)

end

# Apply Ford Fulkerson Algorithm in order to find max flow. 
function fordFulkerson(vertices::Array{Vertex, 1}, edges::Array{Edge, 1}, source::Int64, target::Int64)

    goOutFromOrigin = true
    vertices[source].stamp = Stamp(typemin(Int64), "0", typemax(Int64))
    atualVertex = source
    nextVertex = -1
    chosenEdge = -1
    edgeDirection = "/"

    while (BFS(vertices, edges, source, target))

        shuffle!(vertices[atualVertex].edges)
        if (!goOutFromOrigin)
            goBackVertex = vertices[atualVertex].stamp.predecessor
            vertices[atualVertex].stamp = nothing
            atualVertex = goBackVertex
        end

        nextVertex = -1
        chosenEdge = -1
        goOutFromOrigin = false
        edgeDirection = "/"
        for i in vertices[atualVertex].edges
            if (i.origin == vertices[atualVertex].stamp.predecessor || i.destiny == vertices[atualVertex].stamp.predecessor)
                continue
            end

            if (i.origin == atualVertex && i.direct)
                nextVertex = i.destiny
                chosenEdge = i.id
                edgeDirection = "+"
                goOutFromOrigin = true
                break
            elseif (i.destiny == atualVertex && i.indirect)
                nextVertex = i.origin
                chosenEdge = i.id
                edgeDirection = "-"
                goOutFromOrigin = true
                break
            else 
            end
        end
        
        if (!goOutFromOrigin)
            continue
        end
        
        if (edgeDirection == "+" && vertices[nextVertex].stamp === nothing && edges[chosenEdge].currentFlow < edges[chosenEdge].superiorLimit)
            diff = edges[chosenEdge].superiorLimit - edges[chosenEdge].currentFlow
            vertices[nextVertex].stamp = Stamp(atualVertex, edgeDirection, min(vertices[atualVertex].stamp.improvement, diff))
        elseif (edgeDirection == "-" && vertices[nextVertex].stamp === nothing && edges[chosenEdge].currentFlow > edges[chosenEdge].inferiorLimit)
            diff = edges[chosenEdge].currentFlow - edges[chosenEdge].inferiorLimit
            vertices[nextVertex].stamp = Stamp(atualVertex, edgeDirection, min(vertices[atualVertex].stamp.improvement, diff))
        else
        end

        atualVertex = nextVertex

        if (vertices[target].stamp !== nothing)
            gain = vertices[target].stamp.improvement
            predecessorVertex = vertices[target].stamp.predecessor
            activeVertex = target
            idEdge = 0

            while (predecessorVertex != typemin(Int64))

                for i in vertices[predecessorVertex].edges
                    if (i.origin == activeVertex || i.destiny == activeVertex)
                        idEdge = i.id
                        break
                    end
                end

                if (vertices[activeVertex].stamp.edgeDirection == "+")
                    edges[idEdge].currentFlow += gain
                elseif (vertices[activeVertex].stamp.edgeDirection == "-")
                    edges[idEdge].currentFlow -= gain
                else
                    println("Error stamp.edgeDirection")
                    exit(1)
                end

                activeVertex = predecessorVertex
                predecessorVertex = vertices[activeVertex].stamp.predecessor

            end

            for i = 1:length(vertices)
                if (vertices[i].id != source)
                    vertices[i].stamp = nothing
                end
            end

            for i in edges
                if (i.currentFlow > i.inferiorLimit)
                    i.indirect = true
                else
                    i.indirect = false
                end

                if (i.currentFlow < i.superiorLimit)
                    i.direct = true
                else
                    i.direct = false
                end
            end

            atualVertex = source
        end
    end

    maxFlow = 0
    for i in vertices[target].edges
        maxFlow += i.currentFlow
    end
    
    println("Max flow: $(maxFlow)")

    printFinalEdgesFlow(vertices, edges)

end

function findVertexByName(vertices::Array{Vertex, 1}, graphName::String)
    retorno = 0
    for i in vertices
        if (i.name == graphName)
            retorno = i.id
            break
        end
    end
    if (retorno == 0)
        println("Couldn't find vertex called $(graphName)")
        exit(1)
    else
        return retorno
    end
end