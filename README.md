# stagit

static git page generator.

It generates static HTML pages for a git repository.

## Changes

This is my personal fork of `stagit`

- Modified styling
- Added `-n` flag to set `sitename` for header button
- Pages are now styled by the `style.css` present at root
- Added [md4c](https://github.com/mity/md4c) to parse Markdown files
- Added [Chroma](https://github.com/alecthomas/chroma) for code syntax highlighting

## Usage

Make files per repository:

    $ mkdir -p htmldir && cd htmldir
    $ stagit path-to-repo

Make index file for repositories:

    $ stagit-index repodir1 repodir2 repodir3 > index.html

## Build and install

    $ make
    # make install

## Dependencies

- C compiler (C99).
- libc (tested with OpenBSD, FreeBSD, NetBSD, Linux: glibc and musl).
- libgit2 (v0.22+).
- POSIX make (optional).

## Documentation

See man pages: stagit(1) and stagit-index(1).

## Features

- Log of all commits from HEAD.
- Log and diffstat per commit.
- Show file tree with linkable line numbers.
- Show references: local branches and tags.
- Detect README and LICENSE file from HEAD and link it as a webpage.
- Detect submodules (.gitmodules file) from HEAD and link it as a webpage.
- Atom feed log (atom.xml).
- Make index page for multiple repositories with stagit-index.
- After generating the pages (relatively slow) serving the files is very fast,
  simple and requires little resources (because the content is static), only
  a HTTP file server is required.
- Usable with text-browsers such as dillo, links, lynx and w3m.

## Cons

- Not suitable for large repositories (2000+ commits), because diffstats are
  an expensive operation, the cache (-c flag) is a workaround for this in
  some cases.
- Not suitable for large repositories with many files, because all files
  are written for each execution of stagit. This is because stagit shows the
  lines of textfiles and there is no "cache" for file metadata
  (this would add more complexity to the code).
- Not suitable for repositories with many branches, a quite linear
  history is assumed (from HEAD).

  In these cases it is better to just use cgit or possibly change stagit to
  run as a CGI program.

- Relatively slow to run the first time (about 3 seconds for sbase,
  1500+ commits), incremental updates are faster.
- Does not support some of the dynamic features cgit has, like:

  - Snapshot tarballs per commit.
  - File tree per commit.
  - History log of branches diverged from HEAD.
  - Stats (git shortlog -s).

  This is by design, just use git locally.
