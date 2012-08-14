# notgrep.vim #

## Installation ##

You have to install [ack](http://betterthangrep.com/) or [codesearch](https://code.google.com/p/codesearch/), of course.

### Ack

Install on Debian / Ubuntu with:

    sudo apt-get install ack-grep

For Debian / Ubuntu you can add this line into your .vimrc:

    let g:ackprg="ack-grep -H --nocolor --nogroup --column"

Install on Gentoo with:

    sudo emerge ack

Install with Homebrew:

    brew install ack

Install with MacPorts:

    sudo port install p5-app-ack

Install with Gentoo Prefix

    emerge ack

Otherwise, you are on your own.

### Code Search

Grab the binaries and put them in your $PATH.

### The Plugin

Install with [pathogen](https://github.com/tpope/vim-pathogen).


## Usage ##

    :NotGrep [options] {pattern} [{directory}]

Search recursively in {directory} (which defaults to the current directory) for the {pattern}.

Files containing the search term will be listed in the split window, along with
the line number of the occurrence, once for each occurrence.  [Enter] on a line
in this window will open the file, and place the cursor on the matching line.

Just like where you use :grep, :grepadd, :lgrep, and :lgrepadd, you can use
`:NotGrep`, `:NotGrepAdd`, `:LNotGrep`, and `:LNotGrepAdd` respectively. (See
`doc/notgrep.txt`, or install and `:h NotGrep` for more information.)

**From the [ack docs](http://betterthangrep.com/)** (my favorite feature):

    --type=TYPE, --type=noTYPE

        Specify the types of files to include or exclude from a search. TYPE is a filetype, like perl or xml. --type=perl can also be specified as --perl, and --type=noperl can be done as --noperl.

        If a file is of both type "foo" and "bar", specifying --foo and --nobar will exclude the file, because an exclusion takes precedence over an inclusion.

        Type specifications can be repeated and are ORed together.

        See ack --help=types for a list of valid types.

### Keyboard Shortcuts ###

In the quickfix window, you can use:

    o    to open (same as enter)
    go   to preview file (open but maintain focus on notgrep.vim results)
    t    to open in new tab
    T    to open in new tab silently
    v    to open in vertical split
    gv   to open in vertical split silently
    q    to close the quickfix window

## About ##

This Vim plugin is derived (and by derived, I mean copied, essentially) from
[ack.vim](https://github.com/mileszs/ack.vim) which is derived from Antoine
Imbert's blog post [Ack and Vim
Integration](http://blog.ant0ine.com/typepad/2007/03/ack-and-vim-integration.html)
(in particular, the function at the bottom of the post).  I added a help file
that provides just enough reference to get you going.  I also highly recommend
you check out the docs for the Perl script 'ack', for obvious reasons: [ack -
grep-like text finder](http://betterthangrep.com/).
