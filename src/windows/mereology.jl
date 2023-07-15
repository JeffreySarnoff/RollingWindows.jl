struct SeqIndices{T<:Integer}
    totalidxs::T
    firstidx::T
    finalidx::T
end


function assay(seqlength, firstidx, finalidx)