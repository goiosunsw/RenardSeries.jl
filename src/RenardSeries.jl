module RenardSeries

export roundR

r = Dict(:hi => [1 1.03 1.06 1.09 1.12 1.15 1.18 1.22 1.25 1.28 1.32 1.36 #=
=# 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 #=
=# 2 2.06 2.12 2.18 2.24 2.3 2.36 2.43 2.5 2.58 2.65 2.72 #=
=# 2.8 2.9 3 3.07 3.15 3.25 3.35 3.45 3.55 3.65 3.75 3.87 #=
=# 4 4.12 4.25 4.37 4.5 4.62 4.75 4.87 5 5.15 5.3 5.45 #=
=# 5.6 5.8 6 6.15 6.3 6.5 6.7 6.9 7.1 7.3 7.5 7.75 #=
=# 8 8.25 8.5 8.75 9 9.25 9.5 9.75], 

     :med => [1 1.05 1.1 1.2 1.25 1.3 1.4 1.5 1.6 1.7 1.8 1.9  #=
=# 2 2.1 2.2 2.4 2.5 2.6 2.8 3 3.2 3.4 3.6 3.8 4  #=
=# 4.2 4.5 4.8 5 5.3 5.6 6 6.3 6.7 7.1 7.5 8 8.5 9 9.5],

     :lo => [1 1.1 1.2 1.4 1.6 1.8 2 2.2 2.5 2.8 3.0 3.5 4  #=
=# 4.5 5 5.5 6.0 7.0 8 9] )


allSeries = [5, 10, 20, 40, 80]

function findnearest(a, x)
    idx = searchsortedfirst(a, x)
    if (idx==1); return idx; end
    if (idx>length(a)); return length(a); end
    if (a[idx]==x); return idx; end
    if (abs(a[idx]-x) < abs(a[idx-1]-x))
        return idx
    else
       return idx-1
    end
end

exactRvals(n) = 10 .^ ((0:n-1)/n)

"""
    roundR(x; series=10, resolution=:hi)

Return `x` rounded to the nearest Renard number

# Arguments:
- `series` (5,10,20, 40 or 80) number of log divisions of 1..10
- `resolution` (:hi, :med, :lo) 

# Examples
```jldoctest
julia> roundR(237)
250.0
```
"""
function roundR(x; series=10, resolution=:hi)
    baseSeries = r[resolution]
    resMinSeries = length(baseSeries)
    possibleSeries = filter(x -> x<=resMinSeries, allSeries)
    @assert series in possibleSeries
    skip = resMinSeries ÷ series
    useSeries = baseSeries[1:skip:end]
    exactSeries = exactRvals(series)
    pow = floor(log10(x))
    mant = x/(10^pow)
    imin = findnearest(exactSeries, mant) 
    useSeries[imin]*10^pow
end

end #module