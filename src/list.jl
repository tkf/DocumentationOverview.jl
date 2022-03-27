struct DocList <: Overview
    apis::Vector{API}
end

function Base.show(io::IO, ::MIME"text/markdown", list::DocList)
    for api in list.apis
        s = summarize(api)
        print(io, "* ")
        mdlink(io, s)
        text = s.text
        if text === nothing || all(isspace, text)
            println(io)
        else
            println(io, ": ", text)
        end
    end
end

function DocumentationOverview.list(apis; options...)
    apis, options = preprocess(apis; options...)
    return DocList(apis; options...)
end

DocumentationOverview.list_md(args...; options...) =
    Markdown.MD(DocumentationOverview.list(args...; options...))
