using DocumentationOverview
using Documenter

makedocs(
    sitename = "Try",
    format = Documenter.HTML(),
    modules = [DocumentationOverview],
    strict = [
        :autodocs_block,
        :cross_references,
        :docs_block,
        :doctest,
        :eval_block,
        :example_block,
        :footnote,
        :linkcheck,
        :meta_block,
        # :missing_docs,
        :parse_error,
        :setup_block,
    ],
    # Ref:
    # https://juliadocs.github.io/Documenter.jl/stable/lib/public/#Documenter.makedocs
)

deploydocs(
    repo = "github.com/tkf/DocumentationOverview.jl",
    devbranch = "main",
    push_preview = true,
    # Ref:
    # https://juliadocs.github.io/Documenter.jl/stable/lib/public/#Documenter.deploydocs
)
