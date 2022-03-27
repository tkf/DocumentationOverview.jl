struct DocTable <: Overview
    apis::Vector{API}
    apicolumn::String
end

DocTable(apis; apicolumn = "**API**") = DocTable(apis, apicolumn)

function Base.show(io::IO, ::MIME"text/markdown", table::DocTable)
    println(io, "| ", table.apicolumn, " | **Summary** |")
    println(io, "|:-- |:-- |")
    for api in table.apis
        s = summarize(api)
        print(io, "| ")
        mdlink(io, s)
        println(io, " | ", something(s.text, ""), " |")
    end
end

function DocumentationOverview.table(apis; options...)
    apis, options = preprocess(apis; options...)
    return DocTable(apis; options...)
end

DocumentationOverview.table_md(args...; options...) =
    Markdown.MD(DocumentationOverview.table(args...; options...))
