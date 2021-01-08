"""Gmsh Physical Names. Can be created in the following manner.

    physicalNames = PhysicalNames([(2,1), (2,2), (3,3)], ["Lock", "Force", "Volume"])

where [(2,1), (2,2), (3,3)] is the array of Tuples representing.
"""
mutable struct PhysicalNames
    dimTags::Array{Tuple{Int64, Int64}, 1}
    names::Array{String, 1}
end

"""push new Physical Names onto the struct PhysicalNames.

    push!(physicalName, (2, 1), "Lock")

    2 is the Dimension, 1 is the Attribute. "Lock" is the name of the attribute.
"""
function push!(physicalName::PhysicalNames, dimTag::Tuple{Int64, Int64}, name::String)
    push!(physicalNames.dimTags, dimTag)
    push!(physicalNames.names, name)
    return nothing
end

function createElementDict()
    #number of nodes, dimension
    elementDict = Dict{Tuple{Int64, Int64}, Int64}()
    elementDict[1, 0] = 15 #Point
    elementDict[2, 1] = 1 #Line order 1
    elementDict[3, 1] = 2 #Line order 2
    elementDict[4, 1] = 26 #Line order 3
    elementDict[3, 2] = 2 #Triangle order 1
    elementDict[6, 2] = 9 #Triangle order 2
    elementDict[10, 2] = 21 #Triangle order 3
    elementDict[4, 2] = 3 #Quadrilateral order 1
    elementDict[9, 2] = 10 #Quadrilateral order 2
    elementDict[27, 2] = 36 #Quadrilateral order 3
    elementDict[8, 3] = 5 #Tetrahedral order 1
    elementDict[27, 3] = 12 #Tetrahedral order 2
    elementDict[64, 3] = 92 #Tetrahedral order 3
    elementDict[4, 3] = 4 #Hexahedral order 1
    elementDict[10, 3] = 11 #Hexahedral order 2
    elementDict[20, 3] = 29 #Hexahedral order 3
    return elementDict
end

"""This function returns the Gmsh Element Type.

    gmshElementType(elementDict, numOfNodesPerElement, dim)
"""
function getGmshElementType(elementDict::Dict{Tuple{Int64, Int64}, Int64}, numOfNodesPerElement::Int64, dim::Int64)
    if (numOfNodesPerElement, dim) ∈ keys(elementDict)
        return elementDict[numOfNodesPerElement, dim]
    else
        error("The given element type is not supported yet!")
    end
end

"""This struct stores the Element Data.

    element = Element(dim, gmshElementType, attributes, nodeTags, numOfNodes)
"""
struct Element
    dim::Int64
    gmshElementType::Int64
    attributes::Array{Int64, 1}
    nodeTags::Array{Int64, 1}
    numOfNodes::Int64
end

"""Push Element data into Element Array.

    push!(elementArray, dim, attributes, nodeTags, elementDict)

nodeTags represents the connectivity of a single element.
"""
function push!(elementArray::Array{Element, 1}, dim::Int64, attributes::Array{Int64, 1},
    nodeTags::Array{Int32, 1}, elementDict = createElementDict())
    numOfNodesPerElement = length(nodeTags)
    gmshElementType::Int64 = getGmshElementType(elementDict, numOfNodesPerElement, dim)
    push!(elementArray, Element(dim, gmshElementType, attributes, nodeTags, numOfNodesPerElement))
    return nothing
end

"""Push Element data into Element Array.

    push!(elementArray, dim, attributes, nodeTags, elementDict)

nodeTags represents the connectivity of all the elements. Each row is the connectivity of a
single element.
"""
function push!(elementArray::Array{Element, 1}, dim::Int64, attributes::Array{Int64, 1},
    nodeTags::Array{Int32, 2}, elementDict = createElementDict())
    numOfNodesPerElement = length(nodeTags[1,:])
    gmshElementType::Int64 = getGmshElementType(elementDict, numOfNodesPerElement, dim)
    for i ∈ 1:length(nodeTags[:,1])
        Base.push!(elementArray, Element(dim, gmshElementType, attributes, nodeTags[i,:], numOfNodesPerElement))
    end
    return nothing
end
