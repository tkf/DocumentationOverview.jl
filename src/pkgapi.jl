struct API <: DocumentationOverview.API
    var"module"::Module
    name::Symbol
    exported::Bool
    signature::Union{String,Nothing}
end

API(m::Module, name::Symbol; exported::Bool = name in names(m), signature = nothing) =
    API(m, name, exported, signature)

function Base.getproperty(api::API, name::Symbol)
    if name === :hasdoc
        return hasdoc(api)
    elseif name === :doc
        return docof(api)
    elseif name === :signature
        return signatureof(api)
    end
    return getfield(api, name)
end

Base.fullname(api::API) = (fullname(api.module)..., api.name)

Docs.Binding(api::API) = Docs.Binding(api.module, api.name)

hasdoc(m::Module, b::Docs.Binding) =
    foldl_modules_rec(nothing, m) do _, m
        haskey(Docs.meta(m), b) ? Break(nothing) : nothing
    end isa Break

hasdoc(api::API) = hasdoc(api.module, Docs.Binding(api))

function docof(api::API)
    binding = Docs.Binding(api)
    docstrs = foldl_modules_rec(DocStr[], api.module) do docstrs, m
        multidoc = get(Docs.meta(m), binding, nothing)
        if multidoc isa MultiDoc
            for (_, ds) in sort!(collect(multidoc.docs), by = first)
                push!(docstrs, ds)
            end
        end
        docstrs
    end
    return catdoc(mapany(parsedoc, docstrs)...)
end

function signatureof(api)
    s = getfield(api, :signature)
    s === nothing || return s
    return summarize(api).signature
end

fullpath(api::API) = string(api.module, '.', api.name)

function Base.show(io::IO, ::MIME"text/plain", api::API)
    if get(io, :typeinfo, Any) !== API
        print(io, "API: ")
    end
    printstyled(io, api.signature; color = :cyan)
    if api.exported
        print(io, " (exported)")
    else
        print(io, " (not exported)")
    end
end

struct APISummary
    signature::String
    binding::Docs.Binding
    text::Union{String,Nothing}
end

mdlink(io::IO, s::APISummary) = print(io, "[`", s.signature, "`](@ref ", s.binding, ")")

header_code(m::Markdown.MD) =
    if !isempty(m.content)
        header_code(m.content[1])
    end
header_code(c::Markdown.Code) = c
header_code(::Any) = nothing

first_paragraph(m::Markdown.MD) =
    if length(m.content) == 1
        first_paragraph(m.content[1])
    elseif length(m.content) > 1
        first_paragraph(m.content[2])
    end
first_paragraph(p::Markdown.Paragraph) = p
first_paragraph(::Any) = nothing

function summarize(api::API)
    binding = Docs.Binding(api)

    if !hasdoc(api.module, binding)
        return APISummary(fullpath(api), binding, nothing)
    end

    d = Docs.doc(binding)

    signature = getfield(api, :signature)
    if signature === nothing
        h = header_code(d)
        if h === nothing
            signature = fullpath(api)
        else
            signature, = split(h.code, "\n", limit = 2)
        end
    end

    p = first_paragraph(d)
    if p === nothing
        text = ""
    else
        text, = split(sprint(show, "text/markdown", Markdown.MD(p)), "\n", limit = 2)
    end

    return APISummary(signature, binding, text)
end

DocumentationOverview.API(api::API) = api
DocumentationOverview.API(binding::Docs.Binding) = API(binding.mod, binding.var)

DocumentationOverview.API((mod, var)::Union{Pair{Module,Symbol},Tuple{Module,Symbol}}) =
    API(mod, var)

fullname_symbols(@nospecialize(_)) = nothing
fullname_symbols(var::Symbol) = [var]
function fullname_symbols(ex::Expr)
    vars = Symbol[]
    while true
        if ex isa Expr
            if Meta.isexpr(ex, :., 2)
                ex, right = ex.args
                if right isa QuoteNode
                    v = right.value
                    if v isa Symbol
                        push!(vars, v)
                        continue
                    end
                end
            end
        elseif ex isa Symbol
            push!(vars, ex)
            break
        end
        return nothing
    end
    return reverse!(vars)
end

# TODO: support arbitrary signature
function DocumentationOverview.API(
    code::AbstractString;
    namespace = Main,
    setsignature::Bool = false,
)
    ex = Meta.parse(code)
    vars = fullname_symbols(ex)
    vars === nothing && error("unsupported: ", ex)
    vars = vars::Vector{Symbol}
    mod = namespace
    for (i, v) in pairs(vars[begin:end-1])
        obj = try
            getproperty(mod, v)
        catch
            error(
                mod,
                " does not have name ",
                v,
                " (error while resolving name `",
                join(vars, '.'),
                "``)",
            )
        end
        if obj isa Module
            mod = obj
        else
            error(
                join(vars[begin:i], '.'),
                " is resolved to a non-module object of type ",
                typeof(obj),
            )
        end
    end
    return API(mod, vars[end]; signature = setsignature ? code : nothing)
end

signaturesetter(f) = api -> @set api.signature = f(api)

signaturesetter(::Nothing) = identity
signaturesetter(key::Symbol) = (
    # `signature` keyword argument name => function mapping api to api
    name = name_as_signature,
    strip_namespace = strip_signature_namespace,
)[key]

name_as_signature(api::API) = @set api.signature = String(api.name)

strip_signature_namespace(api::API) =
    @set api.signature = strip_signature_namespace(api.signature)

function strip_signature_namespace(signature::AbstractString)
    found = findfirst(r"[(){}@]", signature)
    i = if found === nothing
        lastindex(signature)
    else
        first(found)
    end
    j = findlast('.', SubString(signature, firstindex(signature), i))
    if j === nothing
        return signature
    else
        return signature[nextind(signature, j):end]
    end
end

const PublicAPI_API = typeof(first(PublicAPI.of(PublicAPI)))

DocumentationOverview.API(api::PublicAPI_API) = API(Module(api), nameof(api))
