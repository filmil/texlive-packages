# SPDX-License-Identifier: Apache-2.0
"""Puts TeX package files next to a LaTeX document.

pdflatex looks for a class or a style file in its working directory, by
its bare name. A LaTeX rule such as rules_latex_host's latex_document
copies each `data` file there under its path relative to the
document's package, so a file from this module, at
`external/texlive_packages+/pgf/tikz.sty`, would land at a path that
starts with `..` and never be found.

tex_package_files links every file of the packages it is given into the
calling package, under its bare name, so that passing the target as
`data` puts each file where pdflatex looks:

    load("@texlive_packages//:defs.bzl", "tex_package_files")

    tex_package_files(
        name = "tex_packages",
        srcs = [
            "@texlive_packages//ieeetran",
            "@texlive_packages//pgf",
        ],
    )

    latex_document(
        name = "paper",
        main = "paper.tex",
        data = [":tex_packages"],
    )

Two files with one bare name are an error: the build fails rather than
pick one.
"""

def _tex_package_files_impl(ctx):
    outs = []
    for f in ctx.files.srcs:
        out = ctx.actions.declare_file(f.basename)
        ctx.actions.symlink(output = out, target_file = f)
        outs.append(out)
    return [DefaultInfo(files = depset(outs), runfiles = ctx.runfiles(files = outs))]

tex_package_files = rule(
    implementation = _tex_package_files_impl,
    doc = "Links the files of TeX packages into this package, under their bare names.",
    attrs = {
        "srcs": attr.label_list(
            allow_files = True,
            doc = "Packages of this module, such as `@texlive_packages//pgf`, or any other files.",
        ),
    },
)
