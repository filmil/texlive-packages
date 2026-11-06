# IEEEtran

Upstream: the `ieeetran` package of TeX Live, from the tlnet snapshot at
`https://texlive.info/tlnet-archive/2026/08/01/tlnet/archive/ieeetran.tar.xz`
(sha256 `112b81e841a71978ebf0b98f68d6a20542c66e16aa9f8c0fe7fb073b91f8c529`,
89368 bytes).

Files are byte-for-byte upstream, with their copyright headers intact.
Only the class and its tools are kept: `IEEEtran.cls` and `IEEEtrantools.sty`.
The package's BibTeX styles and example bibliographies are not included.

`IEEEtran.cls` states LPPL version 1.3.
TeX Live's own catalogue records the package as `lppl1`.
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
