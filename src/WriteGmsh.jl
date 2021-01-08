module WriteGmsh

include("properties.jl")
include("writeGmshv2.jl")

#from properties
export PhysicalNames, push!, createElementDict, getGmshElementType, Element
#from writeGmshv2
export writeGmshv2
end # module
