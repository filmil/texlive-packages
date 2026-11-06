#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
#
# Checks that tex_package_files put each package's entry files side by
# side, in the calling package, under their bare names.
set -euo pipefail
dir="${TEST_SRCDIR}/_main/tests"
status=0
for f in IEEEtran.cls IEEEtrantools.sty tikz.sty pgf.sty pgfcore.code.tex listings.sty lstlang1.sty; do
  if [[ ! -s "${dir}/${f}" ]]; then
    echo "missing or empty: tests/${f}" >&2
    status=1
  fi
done
# The class must be the upstream one, not a stub.
grep -q 'IEEEtran.cls' "${dir}/IEEEtran.cls" || { echo "IEEEtran.cls is not the upstream class" >&2; status=1; }
exit "${status}"
