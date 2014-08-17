Konekraft - Code Toys
=====================
[![Code Climate](https://codeclimate.com/github/IceDragon200/Konekraft.png)](https://codeclimate.com/github/IceDragon200/Konekraft)
### 1.7.0
### Slate 1.1.0
### SASM 0.5.0
### Konekt 3.0.0

## What happened to Sadie?
This IS Sadie, however the name was changed.
Reaktor was renamed to Konekt, to avoid conflicting with Native Instruments's Konekt

## What is this?
Konekraft is a collection of experimental libraries, associated with Computer
Architecture and Electronics.
* Slate:
  Is a virtual machine based on the 8085 CPU, it uses a custom
  language for writing programs, currently the languages are: RASM and SASM

* SASM / RASM:
  Is an Assembly like language written for Slate, SASM is parsed and structured
  as its own language.
  RASM on the other hand is written in ruby, and exports to SASM bytecode.

* Konekt:
  A simulation library for electronics like components.

## Dependencies
As of 1.2.1, there are no dependencies for Sadie::Reaktor

* SASM requires rltk

## File Extensions
.reks2, .kks2
  Legacy Reaktor 2 / Konekt 2 Script

.reks3, .kks3
  Konekt 3 Script

.smxe
  Slate binary program

.sasm
  Slate source program

.rsasm
  Ruby DSL Slate source program

## Why is everything that should be spelt with a 'c' have a 'k' instead?
I'm not German, but k is a kool letter.
