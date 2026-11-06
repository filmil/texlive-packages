# hdlf_texlive_packages

[![Test](https://github.com/filmil/texlive-packages/actions/workflows/test.yml/badge.svg)](https://github.com/filmil/texlive-packages/actions/workflows/test.yml)
[![Tag and Release](https://github.com/filmil/texlive-packages/actions/workflows/tag-and-release.yml/badge.svg)](https://github.com/filmil/texlive-packages/actions/workflows/tag-and-release.yml)
[![Publish](https://github.com/filmil/texlive-packages/actions/workflows/publish.yml/badge.svg)](https://github.com/filmil/texlive-packages/actions/workflows/publish.yml)
[![Publish on Bazel Central Registry](https://github.com/filmil/texlive-packages/actions/workflows/publish-bcr.yml/badge.svg)](https://github.com/filmil/texlive-packages/actions/workflows/publish-bcr.yml)

TeX Live packages as a Bazel module, byte for byte from TeX Live, for
LaTeX builds that fetch everything they use.

A small TeX distribution, such as the TinyTeX that the hermetic toolchain of
[`rules_latex_host`](https://github.com/filmil/bazel_rules_latex_host)
pins, lacks packages that most papers load.
Fetching them one by one does not work reliably (see "Why the files are in
this module" below), so each project ended up copying them into its own
`third_party/`.
This module holds them once, so a project writes a `bazel_dep` instead.

## Packages

| Label | Package | Version | License |
|---|---|---|---|
| `@hdlf_texlive_packages//ieeetran` | IEEEtran (`IEEEtran.cls`, `IEEEtrantools.sty`) | TeX Live 2026-08-01 | LPPL 1.3 |
| `@hdlf_texlive_packages//pgf` | pgf and TikZ, 282 files | TeX Live 2026-08-01 | LPPL 1.3c or GPL 2 |
| `@hdlf_texlive_packages//listings` | listings, with the language definitions | 1.11b | LPPL 1.3c |

Each package directory has a `README.md` with its exact source, what was left
out and why, and a `LICENSE`.
The files are unchanged upstream files, with their copyright headers intact.

## Use

In `MODULE.bazel`:

```starlark
bazel_dep(name = "hdlf_texlive_packages", version = "<version>")
```

Next to a document:

```starlark
load("@hdlf_texlive_packages//:defs.bzl", "tex_package_files")
load("@rules_latex_host//latex:defs.bzl", "latex_document")

tex_package_files(
    name = "tex_packages",
    srcs = [
        "@hdlf_texlive_packages//ieeetran",
        "@hdlf_texlive_packages//pgf",
    ],
)

latex_document(
    name = "paper",
    main = "paper.tex",
    data = [":tex_packages"],
)
```

`tex_package_files` links each file into the document's package under its
bare name.
pdflatex looks for classes and styles in its working directory, by bare
name, and a LaTeX rule copies `data` files there under their package
relative paths; a file from another repository would otherwise land outside
the working directory.
Two files with one name fail the build.

The module depends on nothing, so it works with any LaTeX rule that takes
`data` files, not only `rules_latex_host`.

## Why the files are in this module

A content-addressed fetch of a TeX Live package archive fails in two ways.
`texlive.info`, which keeps dated snapshots, answers a client it does not
recognise, such as Bazel's downloader, with a challenge page instead of the
file, so the fetch fails as a checksum mismatch.
A CTAN mirror's `tlnet` serves the live archive, which changes whenever a
package is updated, so a pin breaks on the next update.
The files in this module's release archive do not change, so a `bazel_dep`
pins them.

## Releases

`.github/workflows/tag-and-release.yml` releases on demand (Run workflow)
and once a day.
A day without a new commit releases nothing.
The version is the next semver from the conventional-commit messages since
the last tag: `feat:` bumps the minor version, `fix:` the patch, and a
breaking change the major.
Each release is published to
[filmil/bazel-registry](https://github.com/filmil/bazel-registry) and then
to the Bazel Central Registry, with build provenance.

## Tests

- `bazel test //...`: the packages link side by side.
- `cd integration && bazel test //...`: an outside consumer that resolves
  from the Bazel Central Registry alone; the BCR presubmit runs it.
- `cd integration/latex && bazel build //...`: an IEEEtran paper with a TikZ
  figure and a listing, compiled under the hermetic toolchain with no TeX
  installed.

## License

This repository's own files (Bazel files, scripts, workflows) are under the
Apache License 2.0, in `LICENSE`.
Each TeX package is under its own license, in its directory.
