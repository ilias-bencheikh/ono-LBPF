(lang dune 3.7)

(generate_opam_files true)

(using directory-targets 0.1)

(using menhir 2.1)

(name ono)

(license AGPL-3.0-or-later)

(authors "TODO")

(maintainers "TODO")

(homepage "TODO")

(bug_reports "TODO")

(package
 (name ono)
 (synopsis "TODO")
 (depends
  (ocaml
   (>= 5.3))
  (menhir
   (and
    :build
    (>= 20220210)))
  (dune-build-info :build)
  (dune-site :build)
  ;; runtime
  (bos
   (>= 0.2.1))
  (cmdliner
   (>= 1.3.0))
  (digestif
   (>= 1.2.0))
  (logs
   (>= 0.10.0))
  (ocaml_intrinsics
   (>= "v0.16.1"))
  ocamlgraph
  (prelude
   (>= 0.5))
  (processor
   (>= 0.2))
  (sedlex
   (>= 3.3))
  (smtml
   (= 0.19.0))
  (synchronizer
   (>= 0.2))
  raylib
  (uutf
   (>= 1.0.3))
  (xmlm
   (>= 1.4.0))
  z3
  ;; doc
  (odoc
   (and
    (>= 3.0.0)
    :with-doc))))
