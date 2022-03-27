# DocumentationOverview

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://tkf.github.io/DocumentationOverview.jl/dev)
[![CI](https://github.com/tkf/DocumentationOverview.jl/actions/workflows/test.yml/badge.svg)](https://github.com/tkf/DocumentationOverview.jl/actions/workflows/test.yml)

DocumentationOverview.jl generates a table of API overview using Julia's multimedia I/O
system.

In particular, it can be used in Documenter's
[`@eval` block](https://juliadocs.github.io/Documenter.jl/stable/man/syntax/#@eval-block).

``````md
```@eval
using DocumentationOverview
using MyPackage
DocumentationOverview.table_md(MyPackage)
```
``````

The code above can also be used in the REPL.

See example outputs and more information in the
[Documentation](https://tkf.github.io/DocumentationOverview.jl/dev).

DocumentationOverview.jl works well with
[PublicAPI.jl](https://github.com/JuliaExperiments/PublicAPI.jl).
