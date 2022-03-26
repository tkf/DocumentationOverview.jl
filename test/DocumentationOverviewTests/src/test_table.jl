module TestTable

using DocumentationOverview
using Test

function test_default()
    table = DocumentationOverview.table(DocumentationOverview)
    text = sprint(show, "text/plain", table)
    @test occursin("DocumentationOverview.table", text)
    @test occursin("DocumentationOverview.find", text)
    @test occursin("DocumentationOverview.API", text)
end

end  # module
