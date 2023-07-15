module RollingWindows

export sliding, hopping,
       rolling, running, tiling

include("support/typeconsts.jl")

include("windows/vector.jl")

#=
include("windowing/sequence.jl")
include("windowing/multisequence.jl")
include("windowing/column.jl")
include("windowing/mulitcolumn.jl")
include("windowing/matrix.jl")
include("windowing/mulitmatrix.jl")
=#


end  # RollingWindows

