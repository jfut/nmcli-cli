set dotenv-load := true
set export := true
set positional-arguments := true

NAME := "nmcli-cli"

# Show available tasks.
default:
    @just --list

#
# clean
#

# Recreate the release artifact directory.
clean:
    rm -rf dist
    mkdir -p dist

#
# lint
#

# Run ShellCheck for the main Bash CLI script.
lint:
    shellcheck {{NAME}}*

#
# release
#

# Build a local snapshot release without publishing.
snapshot:
    goreleaser release --skip=publish --clean --snapshot

# Build release artifacts without publishing.
release:
    goreleaser release --skip=publish --clean --skip=validate
