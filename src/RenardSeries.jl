module RenardSeries

export roundR, Rseries

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

decadeMultipliers = [
    -18 => "a"
    -15 => "f"
    -12 => "p"
  -9 => "n"
  -6 => "μ"
  -3 => "m"
   3 => "k"
   6 => "M"
   9 => "G"
  12 => "T"
  15 => "E"
  18 => "Z"
]

allSeries = [5, 10, 20, 40, 80]

struct Rseries{T} # where T <: Real
    base::Vector{T}
    start::Int64
    finish::Int64
    stride::Int64
    n::Int64
end

function Rseries(v::Vector{T}, pos::Int, finish::Int, stride::Int64) where T <: Real
    Rseries(v, pos, finish, stride, length(v))
end

function Rseries(v::Vector{T}, pos::Int, finish::Int ) where T <: Real
    Rseries(v, pos, finish, 1, length(v))
end

function Rseries(v::Vector{T}) where T <: Real
    Rseries(v, 1, length(v), 1, length(v))
end

function Base.getindex(c::Rseries{T}, idx::Int) where T <: Real 
    effidx = idx * c.stride + c.start - 1
    loops = Int(floor((effidx-1) / c.n))
    pos = effidx - loops * c.n
    c.base[pos] * 10. ^ loops
end

Base.firstindex(c::Rseries) = c[1]

Base.lastindex(c::Rseries) = c[c.finish - c.start]

Base.length(c::Rseries) = c.finish - c.start

Base.iterate(c::Rseries, state=1) = state <= c.finish - c.start ? (c[state], state+1) : nothing
    

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


# """
#     Rseries(vmin, vmax; series=10, resolution=:hi)

# Return the RX series between vmin and vmax
# (X is the series, 5, 10, 20, 40 or 80)

# # Arguments:
# - `series` (5,10,20, 40 or 80) number of log divisions of 1..10
# - `resolution` (:hi, :med, :lo) 

# # Examples
# ```jldoctest
# julia> Rseries(500,1000, series=5)
# 2-element Vector{Float64}:
#   630.0
#  1000.0
# ```
# """
# function Rseries(vmin, vmax; series=10, resolution=:hi)
#     baseSeries = r[resolution]
#     resMinSeries = length(baseSeries)
#     skip = resMinSeries ÷ series
#     pow = floor(log10(vmin))
#     ret = Float64[]
#     idx = 1
#     v = baseSeries[idx]*10^pow
#     while v<=vmax
#         if v >= vmin
#             break
#         else
#             idx += skip
#             v = baseSeries[idx]*10^pow
#         end
#     end
#     while v <= vmax 
#         push!(ret, v)
#         idx += skip
#         if idx > length(baseSeries)
#             pow+=1
#             idx=1
#         end
#         v = baseSeries[idx]*10^pow
#     end
#     ret
# end

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

function strSci(x::Real, significant::Int = 2)
    dec = Int(floor(log10(abs(x))))
    mant = x / 10. ^ (dec-significant+1)
    mants = string(Int(round(abs(mant))))
    u = mants[1:1]
    s = x < 0 ? "-" : ""
    if significant > 1
        d = mants[2:end]
        "$s$u.$(d)x10^$dec"
    else
        "$s$(u)x10^$dec"
    end
end

function strMetricPref(x::Real, significant::Int = 2)
    dec = Int(floor(log10(abs(x))/3))*3
    alldecs = (filter(x->x[1]==dec, RenardSeries.decadeMultipliers))
    decs = isempty(alldecs) ? "" : first(alldecs)[2]
    mant = x / 10. ^ (dec)
    mantr = (round(mant; sigdigits=significant))
    mants = string(mantr % 1 > 0 ? mantr : Int(mantr))
    "$(mants)$decs"
end
end #module