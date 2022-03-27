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
        println(io, " | ", something(s.text, ""), " |")
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
        sortby = fullname,
        options...,
    )

function DocumentationOverview.table(
    apis;
    sortby = nothing,
    signature = nothing,
    options...,
)
    apis = mapfoldl(
        signaturesetter(signature) ∘ DocumentationOverview.API,
        push!,
        apis;
        init = API[],
    )
    if sortby !== nothing
        sort!(apis; by = sortby)
    end
    return DocTable(apis; options...)
end

function DocumentationOverview.table(
    fullnames::Expr;
    namespace = Main,
    sortby = nothing,
    signature = nothing,
    options...,
)
    if !Meta.isexpr(fullnames, :vect)
        error("expected an expression of form `:[a.b.c, d.e.f, ...]`; got: ", fullnames)
    end
    setter = signaturesetter(signature)
    apis = mapfoldl(push!, fullnames.args; init = API[]) do ex
        vars = fullname_symbols(ex)
        vars === nothing && error("unsupported: ", ex)
        vars = vars::Vector{Symbol}
        setter(resolvein(vars, namespace))
    end
    if sortby !== nothing
        sort!(apis; by = sortby)
    end
    return DocTable(apis; options...)
end

DocumentationOverview.table_md(args...; options...) =
    Markdown.MD(DocumentationOverview.table(args...; options...))
