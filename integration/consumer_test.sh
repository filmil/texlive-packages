#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
#
# A consumer gets each package's files side by side in its own package,
# under their bare names.
set -euo pipefail
dir="${TEST_SRCDIR}/_main"
status=0
for f in IEEEtran.cls tikz.sty listings.sty lstlang1.sty; do
  [[ -s "${dir}/${f}" ]] || { echo "missing or empty: ${f}" >&2; status=1; }
done
exit "${status}"
