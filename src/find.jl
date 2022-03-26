function foreach_api_candidate(f, m::Module)
    exports = Set{Symbol}()
    for name in names(m)
        api = API(m, name; exported = true)
        f(api)
        push!(exports, name)
    end
    for name in names(m; all = true)
        name in exports && continue
        api = API(m, name; exported = false)
        f(api)
    end
end

function DocumentationOverview.find(m::Module; include = hasdoc)
    apis = API[]
    foreach_api_candidate(m) do api
        if include(api)
            push!(apis, api)
        end
        return
    end
    return apis
end
