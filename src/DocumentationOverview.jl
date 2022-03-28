baremodule DocumentationOverview

import PublicAPI
PublicAPI.@public table table_md find API

"""
    DocumentationOverview.table(module::Module; ...) -> table
    DocumentationOverview.table(fullnames::Expr; ...) -> table
    DocumentationOverview.table(apis; ...) -> table

Show the table of APIs.

The `table` object returned from this function supports `show` method with `text/plain`,
`text/markdown`, and `text/html` MIME types.

To preprocess the list of APIs, get a vector of [`API`](@ref)s from [`find`](@ref), process
it, and pass it to `DocumentationOverview.table` as an iterable of `API`s.  See also
[`list`](@ref).

See the [Gallery](@ref gallery) for example outputs.

# Extended help

# Arguments

The first argument specifies the list of APIs to be shown:

* `module::Module`: APIs discovered with `find(module::Module; ...)`
* `fullnames::Expr`: APIs are specified by the list of expression of form
  `:[a.b.c, d.e.f, ...]`
* `apis`: an iterable that produces [`API`](@ref)s

# Keyword Arguments
- `apicolumn::AbstractString = "**API**"`: The title for the API column.
- `signature`: following values are supported:
  - `nothing` (default): use the default signature.
  - `:name`: use `api.name`; i.e., `A.B.C.f(x, y)` becomes `f`.
  - `:strip_namespace`: strip the namespace part; i.e., `A.B.C.f(x, y)` becomes `f(x, y)`.
  - a callabel object: it must map an `API` to a `String` which is used as a signature.

Keyword arguments for [`find`](@ref) can also be passed with the method that takes
`module::Module` .

## Examples

```JULIA
julia> using DocumentationOverview

julia> DocumentationOverview.table(DocumentationOverview)
... a table of API printed ...
```

`DocumentationOverview.table` also takes an expression (notice `:` before `[`) to manually
list the APIs:

```julia
julia> using DocumentationOverview

julia> table = DocumentationOverview.table(:[  # ⇐ notice the `:` here
           DocumentationOverview.table,
           DocumentationOverview.API,
       ]);
```

The list of APIs retrieved using
[PublicAPI.jl](https://github.com/JuliaExperiments/PublicAPI.jl) API can also be used with
`DocumentationOverview.table`:

```julia
julia> using PublicAPI

julia> table = DocumentationOverview.table(PublicAPI.of(DocumentationOverview));
```
"""
function table end

"""
    DocumentationOverview.list(module::Module; ...) -> list
    DocumentationOverview.list(fullnames::Expr; ...) -> list
    DocumentationOverview.list(apis; ...) -> list

Show the list of APIs.

The `list` object returned from this function supports `show` method with `text/plain`,
`text/markdown`, and `text/html` MIME types.

To preprocess the list of APIs, get a vector of [`API`](@ref)s from [`find`](@ref), process
it, and pass it to `DocumentationOverview.list` as an iterable of `API`s.  See also
[`table`](@ref).

See the [Gallery](@ref gallery) for example outputs.

# Extended help

# Arguments

The first argument specifies the list of APIs to be shown:

* `module::Module`: APIs discovered with `find(module::Module; ...)`
* `fullnames::Expr`: APIs are specified by the list of expression of form
  `:[a.b.c, d.e.f, ...]`
* `apis`: an iterable that produces [`API`](@ref)s

# Keyword Arguments
- `signature`: following values are supported:
  - `nothing` (default): use the default signature.
  - `:name`: use `api.name`; i.e., `A.B.C.f(x, y)` becomes `f`.
  - `:strip_namespace`: strip the namespace part; i.e., `A.B.C.f(x, y)` becomes `f(x, y)`.
  - a callabel object: it must map an `API` to a `String` which is used as a signature.

Keyword arguments for [`find`](@ref) can also be passed with the method that takes
`module::Module` .

## Examples

```JULIA
julia> using DocumentationOverview

julia> DocumentationOverview.list(DocumentationOverview)
... a list of API printed ...
```

`DocumentationOverview.list` also takes an expression (notice `:` before `[`) to manually
list the APIs:

```julia
julia> using DocumentationOverview

julia> list = DocumentationOverview.list(:[  # ⇐ notice the `:` here
           DocumentationOverview.list,
           DocumentationOverview.API,
       ]);
```

The list of APIs retrieved using
[PublicAPI.jl](https://github.com/JuliaExperiments/PublicAPI.jl) API can also be used with
`DocumentationOverview.list`:

```julia
julia> using PublicAPI

julia> list = DocumentationOverview.list(PublicAPI.of(DocumentationOverview));
```
"""
function list end

"""
    DocumentationOverview.table_md(args...; options...) -> md::Markdown.MD

A shorthand for `Markdown.MD(DocumentationOverview.table(args...; options...))`.
"""
function table_md end

"""
    DocumentationOverview.list_md(args...; options...) -> md::Markdown.MD

A shorthand for `Markdown.MD(DocumentationOverview.list(args...; options...))`.
"""
function list_md end

"""
    DocumentationOverview.find(module::Module; [include]) -> apis::Vector{<:API}

List APIs in `module`.

# Extended help

# Keyword Arguments
- `include`: a callable of form `include(api::API) -> should_include::Bool`.  The `api`s
  are included in the output if and only if this function returns `true`.  The default
  function is equivalent to `api -> api.hasdoc`.

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
* `api.value`: equivalent to `getproperty(api.module, api.value)`; may throw.
* `api.maybevalue`: evaluates to `Some(api.value)` if it does not throw or `nothing`
  otherwise
"""
abstract type API end

module Internal

using Base.Docs: DocStr, MultiDoc, catdoc, mapany, parsedoc

import Markdown
import PublicAPI
using Accessors: @set

using ..DocumentationOverview: DocumentationOverview

include("foldl.jl")
include("pkgapi.jl")
include("find.jl")
include("overview.jl")
include("table.jl")
include("list.jl")

end  # module Internal

end  # baremodule DocumentationOverview
