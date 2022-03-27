module TestPkgAPI

using DocumentationOverview: DocumentationOverview, API
using Test

module ExampleModule

"""
    ExampleModule.f(x)

Example docstring.
"""
f(x) = nothing

nodoc(x) = nothing

end  # module ExampleModule

function test_api_from_str()
    api = API("ExampleModule.f", namespace = TestPkgAPI)
    @test api.module === ExampleModule
    @test api.name === :f
    @test api.value === ExampleModule.f
    @test api.maybevalue === Some(ExampleModule.f)

    nonexisting = API("ExampleModule.nonexisting", namespace = TestPkgAPI)
    @test nonexisting.maybevalue === nothing
end

end  # module
