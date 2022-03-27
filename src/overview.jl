abstract type Overview end

Base.show(io::IO, mime::MIME"text/plain", ov::Overview) = _show(io, mime, ov)
Base.show(io::IO, mime::MIME"text/html", ov::Overview) = _show(io, mime, ov)

_show(io, mime, ov) = show(io, mime, Markdown.MD(ov))

function Markdown.MD(ov::Overview)
    io = IOBuffer()
    show(io, "text/markdown", ov)
    seek(io, 0)
    return Markdown.parse(io)
end

preprocess(m::Module; include = hasdoc, options...) = preprocess(
    DocumentationOverview.find(m; include = include);
    sortby = fullname,
    options...,
)

function preprocess(apis; sortby = nothing, signature = nothing, options...)
    apis = mapfoldl(
        signaturesetter(signature) ∘ DocumentationOverview.API,
        push!,
        apis;
        init = API[],
    )
    if sortby !== nothing
        sort!(apis; by = sortby)
    end
    return apis, options
end

function preprocess(
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
    return apis, options
end
