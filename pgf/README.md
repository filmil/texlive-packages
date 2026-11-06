# pgf and TikZ

Upstream: the `pgf` package of TeX Live, from the tlnet snapshot at
`https://texlive.info/tlnet-archive/2026/08/01/tlnet/archive/pgf.tar.xz`
(718196 bytes).

## The tree is flattened, and that is deliberate

Upstream ships four trees: `tex/latex`, `tex/generic`, `tex/plain` and
`tex/context`.
The files here are those trees flattened into one directory.

`rules_latex_host` copies a `data` file into the build directory under its
package relative path, and pdflatex searches the build directory rather than
a tree beneath it.
A nested layout would therefore never be found.
Flattening is safe for this package, and that was checked rather than
assumed: no file in pgf reads another by a path, only by a bare name, so
every `\input` still resolves.

The four files that collide across trees are all `.lua`, and all belong to
the graph drawing libraries, which only LuaTeX loads.
They are dropped.
That leaves 282 files.

Also dropped: the ConTeXt tree, and the documentation.

## License

pgf is distributed under the GNU Public License and the LaTeX Project Public
License, at the user's choice.
`LICENSE` holds LPPL 1.3c, from `https://www.latex-project.org/lppl/`, which
is the choice this project takes.
The per-file copyright headers are intact and state both.

## Why these files are copied here, and not fetched

A content-addressed fetch of a TeX Live package archive fails in two ways.
`texlive.info` answers a client it does not recognise, such as Bazel's
downloader, with a challenge page instead of the file, so the fetch fails as a
checksum mismatch.
A CTAN mirror's `tlnet` serves the live archive, which changes whenever the
package is updated upstream, so a pin breaks on the next update.
Keeping the bytes in this module's release archive is what makes them stable.
