struct DocTable
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
        println(io, " | ", something(s.text, nothing), " |")
    end
end

Base.show(io::IO, mime::MIME"text/plain", tbl::DocTable) = _show(io, mime, tbl)
Base.show(io::IO, mime::MIME"text/html", tbl::DocTable) = _show(io, mime, tbl)

_show(io, mime, tbl) = show(io, mime, Markdown.MD(tbl))

function Markdown.MD(tbl::DocTable)
    io = IOBuffer()
    show(io, "text/markdown", tbl)
    seek(io, 0)
    return Markdown.parse(io)
end

DocumentationOverview.table(m::Module; include = hasdoc, options...) =
    DocumentationOverview.table(
        DocumentationOverview.find(m; include = include);
        options...,
    )

function DocumentationOverview.table(
    apis;
    sortby = string ∘ fullname,
    signature = nothing,
    options...,
)
    apis = mapfoldl(
        signaturesetter(signature) ∘ DocumentationOverview.API,
        push!,
        apis;
        init = API[],
    )
    sort!(apis; by = sortby)
    return DocTable(apis; options...)
end

DocumentationOverview.table_md(args...; options...) =
    Markdown.MD(DocumentationOverview.table(args...; options...))
