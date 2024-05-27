using RenardSeries
using Test

@testset "RenardSeries.jl" begin
    @test RenardSeries.exactRvals(10)[1] == 1.0
    @test RenardSeries.findnearest([1,2,3],1) == 1
    @test RenardSeries.findnearest([1,2,3],1.6) == 2
    @test RenardSeries.findnearest([1,2,3],16) == 3
    @test roundR(1) == 1.0
end
