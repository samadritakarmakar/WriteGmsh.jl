function writePhysicalNames(physicalNames::PhysicalNames)
    docCharArray::Array{Char, 1} = collect("\$PhysicalNames\n")
    docCharArray = vcat(docCharArray, collect(string(length(physicalNames.dimTags))), ['\n'])
    for i ∈ 1:length(physicalNames.dimTags)
        docCharArray = vcat(docCharArray, collect(string(physicalNames.dimTags[i][1])), [' '],
        collect(string(physicalNames.dimTags[i][2])), [' ','"'], collect(physicalNames.names[i]),
        ['"', '\n'])
    end
return vcat(docCharArray, collect("\$EndPhysicalNames\n"))
end

function writeNodes(nodes::Array{Float64, 2})
    @assert length(nodes[1, :]) == 3 "Nodes must have 3 columns or 3 dimensions."
    docCharArray::Array{Char, 1} = collect("\$Nodes\n")
    docCharArray = vcat(docCharArray, collect(string(length(nodes[:,1]))),['\n'])
    for nodeNo ∈ 1:length(nodes[:,1])
        docCharArray = vcat(docCharArray, [' '], collect(string(nodeNo)), [' '], collect(string(nodes[nodeNo,1])),
        [' '], collect(string(nodes[nodeNo,2])), [' '], collect(string(nodes[nodeNo,3])), ['\n'])
    end
    return vcat(docCharArray, collect("\$EndNodes\n"))
end

function writeElements(elementArray::Array{Element, 1})
    docCharArray::Array{Char, 1} = vcat(collect("\$Elements\n"), collect(string(length(elementArray))), ['\n'])
    for elementNo ∈ 1:length(elementArray)
        docCharArray = vcat(docCharArray, collect(string(elementNo)), [' '],
        collect(string(elementArray[elementNo].gmshElementType)), [' '],
        collect(string(length(elementArray[elementNo].attributes))), [' '])
        for attribNo ∈ 1:length(elementArray[elementNo].attributes)
            docCharArray = vcat(docCharArray, collect(string(elementArray[elementNo].attributes[attribNo])))
        end
        for nodeNo ∈ 1:length(elementArray[elementNo].nodeTags)
            docCharArray = vcat(docCharArray, [' '], collect(string(elementArray[elementNo].nodeTags[nodeNo])))
        end
        docCharArray = vcat(docCharArray, ['\n'])
    end
    return vcat(docCharArray, collect("\$EndElements\n"))
end
function writeGmshv2(fileName::String, physicalNames::PhysicalNames, nodes::Array{Float64, 2}, elementArray::Array{Element, 1})
    #Mesh File Header
    docCharArray::Array{Char, 1} = collect("\$MeshFormat\n2.2 0 8\n\$EndMeshFormat\n")
    #Mesh Physical Names
    docCharArray = vcat(docCharArray, writePhysicalNames(physicalNames),
    writeNodes(nodes), writeElements(elementArray))
    file = open(fileName, "w")
    write(file, String(docCharArray))
    close(file)
    return String(docCharArray)
end
