#=

moving 2D windows over a larger matrix

=#


struct RowCol{T<:Integer}
    row::T
    col::T
end

RowCol(rc::Tuple{T,T}) where {T} = RowCol(first(rc), last(rc))

row(rc::RowCol) = rc.row
col(rc::RowCol) = rc.col
rowcol(rc::RowCol) = (rc.row, rc.col)

import Base: ==, !=, <, <=, >=, >

for Cmp in (:(==), :(!=), :(<), :(<=), :(>=), :(>))
    @eval function $Cmp(rcx::RowCol{T}, rcy::RowCol{T}) where {T}
              $Cmp(rcx.row, rcy.row) && $Cmp(rcx.col, rcy.col)
          end
end

function Base:(+)(rcx::RowCol{T}, rcy::RowCol{T}) where {T}
    RowCol(rcx.row + rcy.row, rcx.col + rcy.col)
end

function Base:(-)(rcx::RowCol{T}, rcy::RowCol{T}) where {T}
    RowCol(rcx.row - rcy.row, rcx.col - rcy.col)
end

struct SpecifyWindow2D{T}
    offset::RowCol{T}
    extent::RowCol{T}
end

SpecifyWindow2D(offset::Tuple{T,T}, extent::Tuple{T,T}) =
    SpecifyWindow2D(RowCol(offset), RowCol(extent))

offset(window::SpecifyWindow2D{T}) where {T} = window.offset
extent(window::SpecifyWindow2D{T}) where {T} = window.extent

offset_row(window::SpecifyWindow2D{T}) where {T} = window.offset.row
offset_col(window::SpecifyWindow2D{T}) where {T} = window.offset.col

extent_row(window::SpecifyWindow2D{T}) where {T} = window.extent.row
extent_col(window::SpecifyWindow2D{T}) where {T} = window.extent.col

struct LocateWindow2D{T}               # for 2D window
    upperleft::RowCol{T}               # (1,1) corner 
    lowerright::RowCol{T}             # (nrows, ncols) corner
end

LocateWindow2D(offset::Tuple{T,T}, extent::Tuple{T,T}) =
    LocateWindow2D(RowCol(offset), RowCol(extent))

upperleft(window::LocateWindow2D{T}) where {T} = window.upperleft
lowerright(window::LocateWindow2D{T}) where {T} = window.lowerright

upperleft_row(window::LocateWindow2D{T}) where {T} = window.upperleft.row
upperleft_col(window::LocateWindow2D{T}) where {T} = window.upperleft.col

lowerright_row(window::LocateWindow2D{T}) where {T} = window.lowerright.row
lowerright_col(window::LocateWindow2D{T}) where {T} = window.lowerright.col

struct PositionWindow2D{T}
    const matrixsize::RowCol{T}          # size of data matrix
    const windowspec::SpecifyWindow2D{T} # initial position and size
    windowlocation::LocateWindow2D{T}    # current position over matrix
end

PositionWindow2D(window2d::PositionWindow2D{T}, location::LocateWindow2D) =
    PositionWindow2D(window2d.matrixsize, window2d.windowspec, location)

function reposition_window(window::PositionWindow2D, resolver::F) where {F<:Function}
    location = window.windowlocation + window.windowspec.extent
    if location.lowerright <  window.matrixsize &&
       location.upperleft  >= window.windowspec
       PositionWindow2D(window, location)
    else
       resolver(window, location)
    end
end

matrixsize(window::PositionWindow2D{T}) where {T} = window.matrixsize
windowspec(window::PositionWindow2D{T}) where {T} = window.windowspec
windowlocation(window::PositionWindow2D{T}) where {T} = window.windowlocation

matrixsize_row(window::PositionWindow2D{T}) where {T} = window.matrixsize.row
matrixsize_col(window::PositionWindow2D{T}) where {T} = window.matrixsize.col

windowspec_offset(window::PositionWindow2D{T}) where {T} = window.windowspec.offset
windowspec_extent(window::PositionWindow2D{T}) where {T} = window.windowspec.extent

windowlocation_upperleft(window::PositionWindow2D{T}) where {T} = window.windowlocation.upperleft
windowlocation_lowerright(window::PositionWindow2D{T}) where {T} = window.windowlocation.lowerright

windowspec_offset_row(window::PositionWindow2D{T}) where {T} = window.windowspec.offset.row
windowspec_offset_col(window::PositionWindow2D{T}) where {T} = window.windowspec.offset.col
windowspec_extent_row_(window::PositionWindow2D{T}) where {T} = window.windowspec.extent.row
windowspec_extent_col(window::PositionWindow2D{T}) where {T} = window.windowspec.extent.col

windowlocation_upperleft_row(window::PositionWindow2D{T}) where {T} = window.windowlocation.upperleft.row
windowlocation_upperleft_col(window::PositionWindow2D{T}) where {T} = window.windowlocation.upperleft.col
windowlocation_lowerright_row(window::PositionWindow2D{T}) where {T} = window.windowlocation.lowerright.row
windowlocation_lowerright_col(window::PositionWindow2D{T}) where {T} = window.windowlocation.lowerright.col
