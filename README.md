emacs-elfeed-cache
=================

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](./LICENSE)

`emacs-elfeed-cache` is an Emacs package for caching the enclosures of an Elfeed RSS feed entry.

Prerequisites
-------------

- GNU Emacs
- [elfeed](https://github.com/skeeto/elfeed)

Installation and configuration
------------------------------

### Installation

1. Clone or download this repository or the `elfeed-cache.el` file.
2. Place `elfeed-cache.el` in your Emacs load path.

### Configuration with `use-package`

An example configuration of `emacs-elfeed-cache` with `use-package` is as follows:

```emacs-lisp
(use-package elfeed-cache
  :bind (:elfeed-show-mode-map
         ("C-c P" . elfeed-show-play-enclosure-cache)
         ("C-c A" . elfeed-show-add-enclosure-cache-to-playlist)))
```

This configuration binds the `C-c P` key to `elfeed-show-play-enclosure-cache` and the `C-c A` key to `elfeed-show-add-enclosure-cache-to-playlist` in the Elfeed search mode.

License
-------

Licensed under the GNU General Public License v3.0. See [LICENSE](LICENSE) for more details.
