# Copyright 1999-2011 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

# inherit eutils

DESCRIPTION="Emacs Configuration Framework meta package"
HOMEPAGE="https://github.com/yamadharma/ecf"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"

IUSE="${IUSE} lisp"

PDEPEND="app-emacs/ecf
	media-fonts/fira-code
	sys-apps/ripgrep
	sys-apps/fd
	media-gfx/ditaa
	dev-tex/LaTeXML
	app-editors/emacs-lsp-booster
	lisp? (
	      app-emacs/auctex
	      app-emacs/auto-complete
	      app-emacs/autoconf-mode
	      app-emacs/ebuild-mode
	      app-emacs/ebuild-run-mode
	)
"

# app-emacs/a
# app-emacs/ace-window
# app-emacs/actionscript-mode
# app-emacs/adaptive-wrap
# app-emacs/all-the-icons
# app-emacs/all-the-icons-dired
# app-emacs/all-the-icons-ibuffer
# app-emacs/all-the-icons-ivy-rich
# app-emacs/amx
# app-emacs/analog
# app-emacs/anaphora
# app-emacs/ansi
# app-emacs/apache-mode
# app-emacs/apel
# app-emacs/apheleia
# app-emacs/assess
# app-emacs/async
# app-emacs/atomic-chrome
# app-emacs/autothemer
# app-emacs/avy
# app-emacs/avy-embark-collect
# app-emacs/bbdb
# app-emacs/biblio
# app-emacs/binclock
# app-emacs/bind-chord
# app-emacs/bind-key
# app-emacs/bison-mode
# app-emacs/blogmax
# app-emacs/bm
# app-emacs/bnf-mode
# app-emacs/bongo
# app-emacs/boogie-friends
# app-emacs/boxquote
# app-emacs/browse-kill-ring
# app-emacs/bubblet
# app-emacs/bui
# app-emacs/burly
# app-emacs/buttercup
# app-emacs/calfw
# app-emacs/cape
# app-emacs/cask
# app-emacs/cask-mode
# app-emacs/centaur-tabs
# app-emacs/cfrs
# app-emacs/chess
# app-emacs/cider
# app-emacs/circe
# app-emacs/citar
# app-emacs/citeproc-el
# app-emacs/cldoc
# app-emacs/clojure-mode
# app-emacs/cmake-font-lock
# app-emacs/cmake-mode
# app-emacs/color-browser
# app-emacs/color-moccur
# app-emacs/color-theme
# app-emacs/commander
# app-emacs/commenter
# app-emacs/company-coq
# app-emacs/company-ebuild
# app-emacs/company-math
# app-emacs/company-mode
# app-emacs/company-quickhelp
# app-emacs/compat
# app-emacs/consult
# app-emacs/consult-flycheck
# app-emacs/corfu
# app-emacs/counsel
# app-emacs/crontab-mode
# app-emacs/crux
# app-emacs/csharp-mode
# app-emacs/css-mode
# app-emacs/css-sort-buffer
# app-emacs/csv-mode
# app-emacs/ctable
# app-emacs/cycle-buffer
# app-emacs/dap-mode
# app-emacs/dash
# app-emacs/dashboard
# app-emacs/ddskk
# app-emacs/deferred
# app-emacs/deft
# app-emacs/demap
# app-emacs/denote
# app-emacs/desktop+
# app-emacs/desktop-entry-mode
# app-emacs/develock
# app-emacs/devil
# app-emacs/df-mode
# app-emacs/dictionary
# app-emacs/diff-hl
# app-emacs/diminish
# app-emacs/dircolors
# app-emacs/dired-hacks
# app-emacs/dired-sort-menu
# app-emacs/distel
# app-emacs/d-mode
# app-emacs/docker
# app-emacs/dockerfile-mode
# app-emacs/docker-tramp
# app-emacs/doctest-mode
# app-emacs/doom-modeline
# app-emacs/doom-themes
# app-emacs/doxymacs
# app-emacs/dropdown-list
# app-emacs/dts-mode
# app-emacs/dune-format
# app-emacs/dwarf-mode
# app-emacs/earthfile-mode
# app-emacs/ebib
# app-emacs/ecb
# app-emacs/ecukes
# app-emacs/edb
# app-emacs/edit-indirect
# app-emacs/edit-list
# app-emacs/editorconfig-emacs
# app-emacs/edit-server
# app-emacs/ef-themes
# app-emacs/eglot
# app-emacs/eimp
# app-emacs/eldev
# app-emacs/eldoc-box
# app-emacs/elfeed
# app-emacs/elfeed-protocol
# app-emacs/elixir-mode
# app-emacs/el-mock
# app-emacs/elpa-mirror
# app-emacs/elpher
# app-emacs/elpy
# app-emacs/elscreen
# app-emacs/emacs-aio
# app-emacs/emacs-ansilove
# app-emacs/emacs-bazel-mode
# app-emacs/emacs-ccls
# app-emacs/emacs-common
# app-emacs/emacs-crystal-mode
# app-emacs/emacs-daemon
# app-emacs/emacs-eat
# app-emacs/emacs-ebuild-snippets
# app-emacs/emacs-eix
# app-emacs/emacs-el-fetch
# app-emacs/emacs-ipython-notebook
# app-emacs/emacs-jabber
# app-emacs/emacs-openrc
# app-emacs/emacsql
# app-emacs/emacs-w3m
# app-emacs/emacs-websearch
# app-emacs/emacs-wget
# app-emacs/embark
# app-emacs/embark-consult
# app-emacs/emhacks
# app-emacs/emms
# app-emacs/emojify
# app-emacs/engrave-faces
# app-emacs/epc
# app-emacs/epl
# app-emacs/erefactor
# app-emacs/erobot
# app-emacs/ert-async
# app-emacs/ert-runner
# app-emacs/eselect-mode
# app-emacs/espuds
# app-emacs/ess
# app-emacs/esup
# app-emacs/evil
# app-emacs/exec-path-from-shell
# app-emacs/exheres-mode
# app-emacs/expand-region
# app-emacs/external-completion
# app-emacs/exwm
# app-emacs/f
# app-emacs/fennel-mode
# app-emacs/fff
# app-emacs/filladapt
# app-emacs/flashcard
# app-emacs/flim
# app-emacs/flycheck
# app-emacs/flycheck-clang-tidy
# app-emacs/flycheck-guile
# app-emacs/flycheck-inline
# app-emacs/flycheck-nimsuggest
# app-emacs/flycheck-package
# app-emacs/folding
# app-emacs/fsharp-mode
# app-emacs/gap-mode
# app-emacs/geiser
# app-emacs/geiser-chez
# app-emacs/geiser-chicken
# app-emacs/geiser-gambit
# app-emacs/geiser-guile
# app-emacs/geiser-mit
# app-emacs/ghub
# app-emacs/git-modes
# app-emacs/git-timemachine
# app-emacs/gnuplot-mode
# app-emacs/gnuserv
# app-emacs/god-mode
# app-emacs/go-mode
# app-emacs/google-c-style
# app-emacs/graphql
# app-emacs/graphviz-dot-mode
# app-emacs/groovy-emacs-modes
# app-emacs/gruvbox-theme
# app-emacs/h4x0r
# app-emacs/haskell-mode
# app-emacs/haxe-mode
# app-emacs/helm
# app-emacs/helm-system-packages
# app-emacs/hexrgb
# app-emacs/highlight-indentation
# app-emacs/highline
# app-emacs/hl-todo
# app-emacs/howm
# app-emacs/ht
# app-emacs/htmlize
# app-emacs/httpd
# app-emacs/hydra
# app-emacs/icicles
# app-emacs/igrep
# app-emacs/indent-bars
# app-emacs/inf-clojure
# app-emacs/inform-mode
# app-emacs/initsplit
# app-emacs/ivy
# app-emacs/ivy-rich
# app-emacs/jam-mode
# app-emacs/jasmin
# app-emacs/jinx
# app-emacs/jq-mode
# app-emacs/js2-mode
# app-emacs/js-comint
# app-emacs/julia-mode
# app-emacs/julia-repl
# app-emacs/kaolin-themes
# app-emacs/key-chord
# app-emacs/keywiz
# app-emacs/kind-icon
# app-emacs/lean-mode
# app-emacs/ledger-mode
# app-emacs/libegit2
# app-emacs/lice-el
# app-emacs/load-relative
# app-emacs/lookup
# app-emacs/lsp-docker
# app-emacs/lsp-java
# app-emacs/lsp-mode
# app-emacs/lsp-treemacs
# app-emacs/lsp-ui
# app-emacs/lua-mode
# app-emacs/lv
# app-emacs/lyskom-elisp-client
# app-emacs/macrostep
# app-emacs/macrostep-geiser
# app-emacs/magit
# app-emacs/magit-popup
# app-emacs/mailcrypt
# app-emacs/marginalia
# app-emacs/markdown-mode
# app-emacs/mastodon
# app-emacs/math-symbol-lists
# app-emacs/matlab
# app-emacs/m-buffer
# app-emacs/mediawiki
# app-emacs/meson-mode
# app-emacs/metadata.xml
# app-emacs/metamath-mode
# app-emacs/mew
# app-emacs/mic-paren
# app-emacs/mldonkey
# app-emacs/mmm-mode
# app-emacs/moccur-edit
# app-emacs/mocker
# app-emacs/modus-themes
# app-emacs/mpg123-el
# app-emacs/mu-cite
# app-emacs/multiple-cursors
# app-emacs/multi-term
# app-emacs/muse
# app-emacs/nagios-mode
# app-emacs/navi2ch
# app-emacs/nerd-icons
# app-emacs/nginx-mode
# app-emacs/nim-mode
# app-emacs/ninja-mode
# app-emacs/nix-mode
# app-emacs/noflet
# app-emacs/no-littering
# app-emacs/nxml-docbook5-schemas
# app-emacs/nxml-gentoo-schemas
# app-emacs/nxml-libvirt-schemas
# app-emacs/nxml-svg-schemas
# app-emacs/oauth2
# app-emacs/ocaml-mode
# app-emacs/orderless
# app-emacs/org-appear
# app-emacs/org-contrib
# app-emacs/org-mode
# app-emacs/org-modern
# app-emacs/org-roam
# app-emacs/org-static-blog
# app-emacs/org-superstar-mode
# app-emacs/osm
# app-emacs/outline-magic
# app-emacs/package-build
# app-emacs/package-lint
# app-emacs/pandoc-mode
# app-emacs/paredit
# app-emacs/pariemacs
# app-emacs/parsebib
# app-emacs/parseclj
# app-emacs/parseedn
# app-emacs/pdf-tools
# app-emacs/persist
# app-emacs/pfuture
# app-emacs/php-mode
# app-emacs/pinentry
# app-emacs/pkg-info
# app-emacs/planner
# app-emacs/plz
# app-emacs/poke
# app-emacs/poke-mode
# app-emacs/polymode
# app-emacs/po-mode
# app-emacs/popup
# app-emacs/popwin
# app-emacs/posframe
# app-emacs/pos-tip
# app-emacs/pov-mode
# app-emacs/powerline
# app-emacs/powershell
# app-emacs/projectile
# app-emacs/proofgeneral
# app-emacs/protbuf
# app-emacs/psgml
# app-emacs/puppet-mode
# app-emacs/pymacs
# app-emacs/python-mode
# app-emacs/pyvenv
# app-emacs/quack
# app-emacs/queue
# app-emacs/quilt-el
# app-emacs/qwerty
# app-emacs/racket-mode
# app-emacs/rainbow-delimiters
# app-emacs/rainbow-mode
# app-emacs/raku-mode
# app-emacs/reazon
# app-emacs/redo+
# app-emacs/reformatter
# app-emacs/regress
# app-emacs/remember
# app-emacs/repology
# app-emacs/request
# app-emacs/rescript-mode
# app-emacs/restclient
# app-emacs/revive
# app-emacs/rfcview
# app-emacs/rg
# app-emacs/riece
# app-emacs/rnc-mode
# app-emacs/rpm-spec-mode
# app-emacs/rudel
# app-emacs/rust-mode
# app-emacs/s
# app-emacs/scad-mode
# app-emacs/scala-mode
# app-emacs/scala-ts-mode
# app-emacs/scheme-complete
# app-emacs/scim-bridge-el
# app-emacs/scss-mode
# app-emacs/semi
# app-emacs/servant
# app-emacs/sesman
# app-emacs/session
# app-emacs/setnu
# app-emacs/setup
# app-emacs/sharper
# app-emacs/shell-split-string
# app-emacs/shrink-path
# app-emacs/shut-up
# app-emacs/slime
# app-emacs/sly
# app-emacs/sml-mode
# app-emacs/sokoban
# app-emacs/spacemacs-theme
# app-emacs/speed-type
# app-emacs/spinner
# app-emacs/ssass-mode
# app-emacs/ssh
# app-emacs/string-inflection
# app-emacs/stripes
# app-emacs/sumibi
# app-emacs/sunrise-commander
# app-emacs/svg-lib
# app-emacs/swift-mode
# app-emacs/swiper
# app-emacs/switch-window
# app-emacs/systemd-mode
# app-emacs/system-packages
# app-emacs/tablist
# app-emacs/teco
# app-emacs/tempel
# app-emacs/template
# app-emacs/tempo-snippets
# app-emacs/thinks
# app-emacs/transient
# app-emacs/treemacs
# app-emacs/treemacs-all-the-icons
# app-emacs/treepy
# app-emacs/treesit-auto
# app-emacs/ts
# app-emacs/tuareg-mode
# app-emacs/twittering-mode
# app-emacs/typescript-mode
# app-emacs/typing
# app-emacs/uboat
# app-emacs/undercover
# app-emacs/undo-tree
# app-emacs/uptimes
# app-emacs/use-package
# app-emacs/uxntal-mode
# app-emacs/vertico
# app-emacs/vhdl-mode
# app-emacs/visual-basic-mode
# app-emacs/vm
# app-emacs/volume
# app-emacs/vterm
# app-emacs/vue-html-mode
# app-emacs/vue-mode
# app-emacs/w3mnav
# app-emacs/wanderlust
# app-emacs/web-mode
# app-emacs/webpaste
# app-emacs/web-server
# app-emacs/websocket
# app-emacs/wgrep
# app-emacs/which-key
# app-emacs/whine
# app-emacs/wikipedia-mode
# app-emacs/with-editor
# app-emacs/with-simulated-input
# app-emacs/ws-butler
# app-emacs/xclip
# app-emacs/xelb
# app-emacs/xrdb-mode
# app-emacs/xslide
# app-emacs/yaml
# app-emacs/yaml-mode
# app-emacs/yasnippet
# app-emacs/yasnippet-snippets
# app-emacs/yatex
# app-emacs/zenburn
# app-emacs/zenirc

# Local Variables:
# mode: sh
# End:
