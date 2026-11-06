#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
#
# Builds the release source archive and prints the release notes to stdout.
#
# bazel-contrib's release_ruleset.yaml runs this as
# `release_prep.sh TAG > release_notes.txt`, requires this exact path, and
# uploads and attests the archive it produces. .bcr/source.template.json
# names the archive.
#
# `git archive`: the archive is exactly the committed tree at the tag, with
# no build output, and the reusable workflow has checked that tag out.
set -o errexit -o nounset -o pipefail

TAG="$1"
VERSION="${TAG#v}"
ARCHIVE="texlive-packages-${TAG}.zip"

git archive --format=zip --output="${ARCHIVE}" "${TAG}"

cat <<NOTES
## Using Bzlmod

\`\`\`starlark
bazel_dep(name = "hdlf_texlive_packages", version = "${VERSION}")
\`\`\`

Then, next to a document:

\`\`\`starlark
load("@hdlf_texlive_packages//:defs.bzl", "tex_package_files")

tex_package_files(
    name = "tex_packages",
    srcs = ["@hdlf_texlive_packages//ieeetran", "@hdlf_texlive_packages//pgf"],
)
\`\`\`

and pass \`:tex_packages\` as the document's \`data\`.
NOTES
