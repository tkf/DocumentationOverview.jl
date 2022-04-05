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

function test_fullnames()
    table = DocumentationOverview.table(
        :[table, DocumentationOverview.API, find],
        namespace = DocumentationOverview,
    )
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

function test_nolinks_md()
    table = DocumentationOverview.table_md(DocumentationOverview)
    text = sprint(show, "text/markdown", table)
    @test occursin("DocumentationOverview.table", text)
    @test occursin("DocumentationOverview.find", text)
    @test occursin("DocumentationOverview.API", text)
    num_refs = length(collect(eachmatch(r"@ref", text)))

    table = DocumentationOverview.table_md(DocumentationOverview, links = false)
    text = sprint(show, "text/markdown", table)
    @test occursin("DocumentationOverview.table", text)
    @test occursin("DocumentationOverview.find", text)
    @test occursin("DocumentationOverview.API", text)
    num_refs_nolinks = length(collect(eachmatch(r"@ref", text)))

    # The description might include @ref blocks as well,
    # we thus test that the number of refs is reduced.
    @test num_refs_nolinks < num_refs
end

end  # module
