# [Gallery](@id gallery)

```@meta
CurrentModule = DocumentationOverview
```

## Default

Code:

``````md
```@eval
using DocumentationOverview
DocumentationOverview.table_md(DocumentationOverview)
```
``````

Output:

```@eval
using DocumentationOverview
DocumentationOverview.table_md(DocumentationOverview)
```

## `signature = :strip_namespace`

Code:

``````md
```@eval
using DocumentationOverview
DocumentationOverview.table_md(
    DocumentationOverview;
    signature = :strip_namespace,
)
```
``````

Output:

```@eval
using DocumentationOverview
DocumentationOverview.table_md(
    DocumentationOverview;
    signature = :strip_namespace,
)
```

## `signature = :name`

Code:

``````md
```@eval
using DocumentationOverview
DocumentationOverview.table_md(
    DocumentationOverview;
    signature = :name,
)
```
``````

Output:

```@eval
using DocumentationOverview
DocumentationOverview.table_md(
    DocumentationOverview;
    signature = :name,
)
```
