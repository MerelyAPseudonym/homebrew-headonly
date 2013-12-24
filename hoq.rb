require 'formula'

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class TransitionalMode < Requirement
  fatal true

  satisfy do
    Tab.for_name('camlp5').unused_options.include? 'strict'
  end

  def message; <<-EOS.undent
    camlp5 must be compiled in transitional mode (instead of --strict mode):
      brew install camlp5
    EOS
  end
end

class Hoq < Formula
  homepage 'http://homotopytypetheory.org/coq/'
  head 'https://github.com/HoTT/HoTT.git'

  def install
    camlp5_lib = Formula.factory('camlp5').lib+'ocaml/camlp5'
    system "./configure", "-prefix", prefix,
                          "-mandir", man,
                          "-camlp5dir", camlp5_lib,
                          "-emacslib", "#{lib}/emacs/site-lisp",
                          "-coqdocdir", "#{share}/coq/latex",
                          "-coqide", "no",
                          "-with-doc", "no"
    ENV.deparallelize # Otherwise "mkdir bin" can be attempted by more than one job
    system "make world"
    system "make install"
  end 
end
