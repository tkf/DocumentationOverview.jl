baremodule DocumentationOverview

"""
    DocumentationOverview.table(module::Module; [apicolumn], [include]) -> table
    DocumentationOverview.table(apis; [apicolumn]) -> table

Show the list of APIs as a table.

The `table` object returned from this function supports `show` method with `text/plain`,
`text/markdown`, and `text/html` MIME types.

To preprocess the list of APIs, get a vector of [`API`](@ref)s from [`find`](@ref), process
it, and pass it to `DocumentationOverview.table` as an iterable of `API`s.

See the [Gallery](@ref gallery) for example outputs.

# Extended help

# Keyword Arguments
- `apicolumn::AbstractString = "**API**"`: The title for the API column.
- `signature`: following values are supported:
  - `nothing` (default): use the default signature.
  - `:name`: use `api.name`; i.e., `A.B.C.f(x, y)` becomes `f`.
  - `:strip_namespace`: strip the namespace part; i.e., `A.B.C.f(x, y)` becomes `f(x, y)`.
  - a callabel object: it must map an `API` to a `String` which is used as a signature.

## Examples

```JULIA
julia> using DocumentationOverview

julia> DocumentationOverview.table(DocumentationOverview)
... a table of API printed ...
```
"""
function table end

"""
    DocumentationOverview.table_md(args...; options...) -> md::Markdown.MD

A shorthand for `Markdown.MD(DocumentationOverview.table(args...; options...))`.
"""
function table_md end

"""
    DocumentationOverview.find(module::Module; [include]) -> apis::Vector{<:API}

List APIs in `module`.

# Extended help

# Keyword Arguments
- `include`: a callable of form `include(api::API) -> should_include::Bool`.  The `api`s
  evaluated as `true` by this function are not included.

## Examples
```julia
julia> using DocumentationOverview

julia> for api in DocumentationOverview.find(DocumentationOverview)
           @show api.name
       end
api.name = :API
api.name = :find
api.name = :table
```
"""
function find end

"""
    DocumentationOverview.API

An object passed to `include` callback of [`table`](@ref).

`API` has the following properties settable using `Accessors.@set`:

* `module::Module`: the module in which the API is discovered.
* `name::Symbol`: the name of the API.
* `exported::Bool`: `true` iff the API is exported from `api.module`.
* `signature::String`: "signature" of the API; if `api.hasdoc` (see below), it defaults to
  the first line of the docstring; otherwise, it defaults to the fully qualified name of the
  API.

It also has the following derived properties that are not settable with `Accessors.@set`:

* `hasdoc::Bool`: indicate if the API has a docstring.
* `doc::Union{Markdown.MD,Nothing}`: docstring of the API.
"""
abstract type API end

module Internal

import Markdown
using Accessors: @set

using ..DocumentationOverview: DocumentationOverview

include("pkgapi.jl")
include("find.jl")
include("table.jl")

end  # module Internal

end  # baremodule DocumentationOverview
