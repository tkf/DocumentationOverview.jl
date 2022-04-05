module TestList

using DocumentationOverview
using Test

function test_default()
    list = DocumentationOverview.list(DocumentationOverview)
    text = sprint(show, "text/plain", list)
    @test occursin("DocumentationOverview.table", text)
    @test occursin("DocumentationOverview.find", text)
    @test occursin("DocumentationOverview.API", text)
end

function test_nolinks_md()
    table = DocumentationOverview.list_md(DocumentationOverview)
    text = sprint(show, "text/markdown", table)
    @test occursin("DocumentationOverview.table", text)
    @test occursin("DocumentationOverview.find", text)
    @test occursin("DocumentationOverview.API", text)
    num_refs = length(collect(eachmatch(r"@ref", text)))

    table = DocumentationOverview.list_md(DocumentationOverview, links = false)
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
