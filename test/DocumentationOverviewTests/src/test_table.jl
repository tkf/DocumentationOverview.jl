module TestTable

import PublicAPI
using DocumentationOverview
using Test

using ..TestPkgAPI: ExampleModule

function test_default()
    table = DocumentationOverview.table(DocumentationOverview)
    text = sprint(show, "text/plain", table)
    @test occursin("DocumentationOverview.table", text)
    @test occursin("DocumentationOverview.find", text)
    @test occursin("DocumentationOverview.API", text)
end

function test_publicapi()
    table = DocumentationOverview.table(PublicAPI.of(DocumentationOverview))
    text = sprint(show, "text/plain", table)
    @test occursin("DocumentationOverview.table", text)
    @test occursin("DocumentationOverview.find", text)
    @test occursin("DocumentationOverview.API", text)
end

function test_nodoc()
    table = DocumentationOverview.table(
        DocumentationOverview.API.(split("""
        f
        nodoc
        """), namespace = ExampleModule),
    )
    text = sprint(show, "text/plain", table)
    @test occursin("f", text)
    @test occursin("nodoc", text)
end

end  # module
