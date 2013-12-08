#
# Sadie/lib/sadie/sasm/lexer.rb
#   by IceDragon
require 'rltk'
module Sadie
  module SASM
    class Lexer < RLTK::Lexer

      ### ignore
      rule(/\n/)
      rule(/\s/)
      ### keywords
      rule(/namespace/) { :KWNS }
      rule(/label/)     { :KLBL }
      rule(/extern/)    { :KEXT }
      rule(/using/)     { :KUSE }
      ## instructions
      rule(/aci/)  { :KIACI }
      rule(/adc/)  { :KIADC }
      rule(/add/)  { :KIADD }
      rule(/adi/)  { :KIADI }
      rule(/ana/)  { :KIANA }
      rule(/ani/)  { :KIANI }
      rule(/call/) { :KICALL }
      rule(/cc/)   { :KICC }
      rule(/cm/)   { :KICM }
      rule(/cma/)  { :KICMA }
      rule(/cmc/)  { :KICMC }
      rule(/cmp/)  { :KICMP }
      rule(/cnc/)  { :KICNC }
      rule(/cnz/)  { :KICNZ }
      rule(/cp/)   { :KICP }
      rule(/cpe/)  { :KICPE }
      rule(/cpi/)  { :KICPI }
      rule(/cpo/)  { :KICPO }
      rule(/cz/)   { :KICZ }
      rule(/daa/)  { :KIDAA }
      rule(/dad/)  { :KIDAD }
      rule(/dcr/)  { :KIDCR }
      rule(/dcx/)  { :KIDCX }
      rule(/di/)   { :KIDI }
      rule(/ei/)   { :KIEI }
      rule(/hlt/)  { :KIHLT }
      rule(/in/)   { :KIIN }
      rule(/inr/)  { :KIINR }
      rule(/inx/)  { :KIINX }
      rule(/jc/)   { :KIJC }
      rule(/jm/)   { :KIJM }
      rule(/jmp/)  { :KIJMP }
      rule(/jnc/)  { :KIJNC }
      rule(/jnz/)  { :KIJNZ }
      rule(/jp/)   { :KIJP }
      rule(/jpe/)  { :KIJPE }
      rule(/jpo/)  { :KIJPO }
      rule(/jz/)   { :KIJZ }
      rule(/lda/)  { :KILDA }
      rule(/ldax/) { :KILDAX }
      rule(/lhld/) { :KILHLD }
      rule(/lxi/)  { :KILXI }
      rule(/mov/)  { :KIMOV }
      rule(/mvi/)  { :KIMVI }
      rule(/nop/)  { :KINOP }
      rule(/null/) { :KINULL }
      rule(/ora/)  { :KIORA }
      rule(/ori/)  { :KIORI }
      rule(/out/)  { :KIOUT }
      rule(/pchl/) { :KIPCHL }
      rule(/pop/)  { :KIPOP }
      rule(/push/) { :KIPUSH }
      rule(/ral/)  { :KIRAL }
      rule(/rar/)  { :KIRAR }
      rule(/rc/)   { :KIRC }
      rule(/ret/)  { :KIRET }
      rule(/rim/)  { :KIRIM }
      rule(/rlc/)  { :KIRLC }
      rule(/rm/)   { :KIRM }
      rule(/rnc/)  { :KIRNC }
      rule(/rnz/)  { :KIRNZ }
      rule(/rp/)   { :KIRP }
      rule(/rpe/)  { :KIRPE }
      rule(/rpo/)  { :KIRPO }
      rule(/rrc/)  { :KIRRC }
      rule(/rst/)  { :KIRST }
      rule(/rz/)   { :KIRZ }
      rule(/sbb/)  { :KISBB }
      rule(/sbi/)  { :KISBI }
      rule(/shld/) { :KISHLD }
      rule(/sim/)  { :KISIM }
      rule(/sphl/) { :KISPHL }
      rule(/sta/)  { :KISTA }
      rule(/stax/) { :KISTAX }
      rule(/stc/)  { :KISTC }
      rule(/sub/)  { :KISUB }
      rule(/sui/)  { :KISUI }
      rule(/xchg/) { :KIXCHG }
      rule(/xra/)  { :KIXRA }
      rule(/xri/)  { :KIXRI }
      rule(/xthl/) { :KIXTHL }

      # single
      rule(/A/) { :REG_A }
      rule(/B/) { :REG_B }
      rule(/C/) { :REG_C }
      rule(/D/) { :REG_D }
      rule(/E/) { :REG_E }
      rule(/H/) { :REG_H }
      rule(/L/) { :REG_L }
      # pairs
      rule(/AF/)  { :REG_AF  }
      rule(/BC/)  { :REG_BC  }
      rule(/DE/)  { :REG_DE  }
      rule(/HL/)  { :REG_HL  }
      rule(/PSW/) { :REG_PSW }
      rule(/SP/)  { :REG_SP  }
      rule(/PC/)  { :REG_PC  }

      rule(/,/)                     {      :COMMA }
      rule(/::/)                    {      :DCOLON }
      rule(/:/)                     {      :COLON }
      rule(/\./)                    {      :PERIOD }
      #rule(/;/)                     {      :SEMI   }

      rule(/[A-Za-z][A-Za-z0-9_]*/) { |t| [:IDENT, t] }

      rule(/0x[A-F\d]+/)            { |t| [:NUMBER, t.hex] }
      rule(/\d+/)                   { |t| [:NUMBER, t.to_i] }

      rule(/;/)                     { push_state(:comment) }
      rule(/\n/, :comment)          { pop_state }
      rule(/.+/, :comment)

    end
  end
end