module TestList

using DocumentationOverview
using Test

function test_default()
    list = DocumentationOverview.list(DocumentationOverview)
    text = sprint(show, "text/plain", list)
    @test occursin("•  ", text)
    @test occursin("DocumentationOverview.table", text)
    @test occursin("DocumentationOverview.find", text)
    @test occursin("DocumentationOverview.API", text)
end

end  # module
