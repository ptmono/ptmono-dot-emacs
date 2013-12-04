
files
-----

 - init.el	: init file of emacs
 - ChangeLog
 - bookmarks
 - dal-worknote.elc	: init.el requires this file. I lose the original source.


directories
-----------

 - config : configurations and modifications of emacs packages I am using
 - myel : I had written some codes for my own use
 - cvs	: dependent packages from the version control system
 - etc	: dependent packages from the file


Using
-----

I spend no minute for using other people. So it will not work for you. I
think that many emacs user needs only some part he want to know. I am
using this emacs configuration on both Linux and Windows. On Windows it
requires MingGW and cygwin.

The directories cvs, etc contains the dependent emacs packages. To archive
these directories I am using following commands.
 - 'make zip'
 - 'make-unzip'

It will generate *.tar.gz files.
