#!/usr/bin/env python
r"""
=================
snippet_copier.py
=================

A script which downloads snippets from bundles in the `TextMate`_ `svn repo`_
and attempts to create duplicate `YASnippets`_, written by `Jeff Wheeler`_.

Synopsis
========

TextMate bundles include amazingly wonderful tab-triggered snippets, yet these
have been for a long time restricted to only OS X. Emacs, a cross-platform
editor now has a great snippets package, YASnippet, so now it seems necessary
to make the TextMate snippets available for Emacs. This script does just that.

This script may be used as a command-line utility or integrated into other
scripts without problems.

Description
===========

The snippet copier works with two classes:

- ``Snippet`` which represents a generic tab-triggered snippet
- ``TextMateBundle``, an abstract API tied to TextMate's bundles SVN repo

With access to the snippets in the bundle, generic ``Snippet``\ s are created
which then are saved in a local directory.

It's important to remember that not all snippets can be converted directly from
TextMate to YASnippet: they use different syntax for certain things like
embedded code. YASnippet requires lisp, while TextMate uses shell commands
inside snippets. A few other conversions don't work quite right, so it is
likely that some snippets will require manual editing.

Options
=======

Most often, snippets will be copied through the command-line interface. The
script accepts just a few simple arguments:

``--bundle``
        The case-sensitive name of the bundle on the TextMate SVN repository.

``--path``
        The path of the directory to which the snippets should be saved. This
        may be either a relative or absolute path.

``--help``
        Print brief usage information regarding the command-line interface.

Credits
=======

This script was written by `Jeff Wheeler`_, except for the ``unescape``
function which was found on `this site <http://effbot.org/zone/re-sub.htm>`_.

The TextMate bundles were written by many different people, often available in
the *info.plist* file (with the key ``contactName``).

The YASnippet package was written by Chiyuan Zhang (a.k.a. *pluskid*) for
Emacs.

.. _TextMate: http://macromates.com
.. _svn repo: http://macromates.com/svn/Bundles/trunk/Bundles/
.. _YASnippets: http://code.google.com/p/yasnippet/
.. _Jeff Wheeler: http://nokrev.com
"""

import htmlentitydefs
import optparse
import os
import re
import sys
import urllib

from BeautifulSoup import BeautifulSoup

def unescape(text):
    """Replace HTML entities with original special characters.

    The entities are used in TextMate bundles because they're XML documents;
    placing characters like ``<`` and ``>`` would throw off a parser.

    This snippet was found at http://effbot.org/zone/re-sub.htm; many thanks!
    """
    def fixup(m):
        text = m.group(0)
        if text[:2] == "&#":
            # character reference
            try:
                if text[:3] == "&#x":
                    return unichr(int(text[3:-1], 16))
                else:
                    return unichr(int(text[2:-1]))
            except ValueError:
                pass
        else:
            # named entity
            try:
                text = unichr(htmlentitydefs.name2codepoint[text[1:-1]])
            except KeyError:
                pass
        return text # leave as is
    return re.sub("&#?\w+;", fixup, text)

class Snippet(object):
    """A generic snippet that can be tab-triggered."""
    def __init__(self, trigger, content):
        self.trigger = trigger
        self.content = content

    def __str__(self):
        return self.trigger

    def save_as_yasnippet(self, path):
        # Find empty file name
        filename = "%s/%s" % (os.path.abspath(path), self.trigger)

        if os.path.exists(filename):
            i = 1
            while os.path.exists(filename+"."+str(i)):
                i += 1
            filename += "." + str(i)

        snippet_file = open(filename, 'w')
        snippet_file.write("# This was cloned from a TextMate bundle for "
                           "yasnippet.\n# --\n")
        snippet_file.write(self.content)
        snippet_file.close()

class TextMateBundle(object):
    """Abstraction of TextMate's bundle svn repository."""
    URI_BASE = "http://macromates.com/svn/Bundles/trunk/Bundles" \
        "/%s.tmbundle/Snippets/"

    def __init__(self, bundle):
        self.bundle = bundle.replace(' ', '%20')

    def _create_soup(self, uri):
        sock = urllib.urlopen(uri)
        soup = BeautifulSoup(sock.read())
        sock.close()
        return soup

    def _snippet_uris(self):
        soup = self._create_soup(self.URI_BASE % self.bundle)
        return [self.URI_BASE % self.bundle +
                a.a["href"] for a in soup.findAll('li')[1:]]

    def download_snippets(self):
        snippets = []
        for uri in self._snippet_uris():
            try:
                snippets.append(self.create_snippet(uri))
            except NotImplementedError:
                pass
        return snippets

    def create_snippet(self, uri):
        soup = self._create_soup(uri)

        try:
            return Snippet(
                soup.find("key", text="tabTrigger").findNext("string").string,
                unescape(soup.find("key", text="content").findNext("string")
                         .string)
            )
        except AttributeError:
            # This is probably a keyboard-based snippet. Don't even bother...
            raise NotImplementedError

if __name__ == '__main__':
    p = optparse.OptionParser(description="Clone a TextMate bundle for "
                              "YASnippet")
    p.add_option("--bundle", "-b", help="Case-sensitive name of TextMate "
                 "bundle")
    p.add_option("--path", "-p", help="Path where snippets should be saved")

    options, arguments = p.parse_args()

    # Validate everything is good
    if not options.bundle:
        p.error("bundle option not given")

    if not options.path:
        p.error("path option not given")
    elif not os.path.exists(options.path) or not os.path.isdir(options.path):
        p.error("not a valid path")

    bndl = TextMateBundle(options.bundle)
    for snippet in bndl.download_snippets():
        snippet.save_as_yasnippet(options.path)

