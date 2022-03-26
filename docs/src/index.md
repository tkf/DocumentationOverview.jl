# DocumentationOverview.jl

```@meta
CurrentModule = DocumentationOverview
```

## Summary

```@eval
using DocumentationOverview
DocumentationOverview.table_md(
    DocumentationOverview;
    signature = :name,
    apicolumn = "Name",
)
```

!!! note
    The above table is generated using

    ``````md
    ```@eval
    using DocumentationOverview
    DocumentationOverview.table_md(
        DocumentationOverview;
        signature = :name,
        apicolumn = "Name",
    )
    ```
    ``````

    For more examples, see [Gallery](@ref gallery).

## Documentation

```@docs
DocumentationOverview.table
DocumentationOverview.table_md
DocumentationOverview.find
DocumentationOverview.API
```
