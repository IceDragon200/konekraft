Sadie - Experimental Designs
============================
### 1.4.0 [![Code Climate](https://codeclimate.com/github/IceDragon200/Sadie.png)](https://codeclimate.com/github/IceDragon200/Sadie)
### SASM 0.5.0
### Slate 1.1.0
### Reaktor 2.1.0

## What is this?
Sadie is a collection of experimental libraries, associated with Computer
Architecture and Electronics.
* Slate:
  Is a virtual machine based on the 8085 CPU, it uses a custom
  language for writing programs, currently the languages are: RASM and SASM

* SASM / RASM:
  Is an Assembly like language written for Slate, SASM is parsed and structured
  as its own language.
  RASM on the other hand is written in ruby, and exports to SASM bytecode.

* Reaktor:
  A simulation library for electronics like components.

## Dependencies
As of 1.2.1, there are no dependencies for Sadie::Reaktor

* SASM requires rltk