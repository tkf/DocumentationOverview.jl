struct DocList <: Overview
    apis::Vector{API}
    links::Bool
end

function Base.show(io::IO, ::MIME"text/markdown", list::DocList)
    for api in list.apis
        s = summarize(api)
        print(io, "* ")
        list.links ? mdlink(io, s) : print(io, s.signature)
        text = s.text
        if text === nothing || all(isspace, text)
            println(io)
        else
            println(io, ": ", text)
        end
    end
end

function DocumentationOverview.list(apis; links = true, options...)
    apis, options = preprocess(apis; options...)
    isempty(options) || throw(ArgumentError("list does not support keyword arguements $options"))
    return DocList(apis, links)
end

DocumentationOverview.list_md(args...; options...) =
    Markdown.MD(DocumentationOverview.list(args...; options...))
