# listings

Upstream: the `listings` package of TeX Live, version 1.11b (TeX Live
revision 77682), from
`https://ftp.fau.de/ctan/systems/texlive/tlnet/archive/listings.tar.xz`,
fetched on 2026-11-06
(sha256 `ba1a9cdb71d04dfbacf5ce3db3769d84849956595ab092e5cfd23082787b57c2`,
151988 bytes).

Files are byte-for-byte upstream, with their copyright headers intact: the
whole `tex/latex/listings` tree, so the language definitions (`lstlang1.sty`
to `lstlang3.sty`) and the `.prf` presets are included.
The documentation is not.

TeX Live's catalogue records the package as `lppl1.3c`.
`LICENSE` holds LPPL 1.3c, from `https://www.latex-project.org/lppl/`,
because neither the package nor the TeX Live archive ships the license text.

## Why these files are copied here, and not fetched

A content-addressed fetch of a TeX Live package archive fails in two ways.
`texlive.info` answers a client it does not recognise, such as Bazel's
downloader, with a challenge page instead of the file, so the fetch fails as a
checksum mismatch.
A CTAN mirror's `tlnet` serves the live archive, which changes whenever the
package is updated upstream, so a pin breaks on the next update.
Keeping the bytes in this module's release archive is what makes them stable.
