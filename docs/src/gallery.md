# [Gallery](@id gallery)

```@meta
CurrentModule = DocumentationOverview
```

## Table

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

## Table with `signature = :strip_namespace`

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

## Table with `signature = :name`

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

## List

Code:

``````md
```@eval
using DocumentationOverview
DocumentationOverview.list_md(
    DocumentationOverview;
)
```
``````

Output:

```@eval
using DocumentationOverview
DocumentationOverview.list_md(
    DocumentationOverview;
)
```
