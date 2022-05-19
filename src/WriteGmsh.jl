module WriteGmsh

include("properties.jl")
include("writeGmshv2.jl")

#from properties
export PhysicalNames, pushPhysicalName!, createElementDict, getGmshElementType, Element, pushElements!
#from writeGmshv2
export writeGmshv2
end # module
