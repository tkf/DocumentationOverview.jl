module TestFind

using DocumentationOverview
using Test

function test_find()
    apis = DocumentationOverview.find(DocumentationOverview)
    allnames = sort!([api.name for api in apis])
    @test allnames == [:API, :find, :table, :table_md]
end

end  # module
