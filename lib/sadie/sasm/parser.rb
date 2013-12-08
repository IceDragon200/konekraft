#
# Sadie/lib/sadie/sasm/parser.rb
#   by IceDragon
require 'rltk/parser'
require 'sadie/sasm/lexer'
require 'sadie/sasm/ast'
module Sadie
  module SASM
    class Parser < RLTK::Parser
      #right :REG_A, :REG_B, :REG_C, :REG_D, :REG_E, :REG_F, :REG_H, :REG_L
      #production(:input, "statement") { |s,_| s }
      production(:statement) do
        # extern
        clause('KEXT namespace_arg PERIOD IDENT') { |_,ns,_,lb| AST::ExternLabel.new(lb, ns) }

        # using
        clause('KUSE namespace_arg') { |_,ns| AST::UsingNamespace.new(ns) }

        # namespace
        clause('KWNS') { |_| AST::NamespaceDeclaration.new(nil) }
        clause('KWNS namespace_arg') { |_, ns| AST::NamespaceDeclaration.new(ns) }

        # label
        clause('KLBL IDENT') { |_, s| AST::Label.new(s) }
        clause('KLBL namespace_label') { |_, ns| AST::LabelNamespace.new(s, ns) }

        # instructions
        clause('instruction') { |i| i }
      end
      production(:namespace_arg) do
        clause("IDENT") { |n| AST::Namespace.new([n]) }
        clause("IDENT DCOLON namespace_arg") { |n, _, n2| n2.path.unshift(n); n2 }
      end
      production(:instruction) do
        clause('NUMBER')                    { |t|        AST::Number.new(t) }
        #
        clause('KINOP')                     { |_|        AST::Instruction.new(0, [])}
        clause('KILXI REG_BC COMMA NUMBER') { |_,_,_,n1| AST::Instruction.new(1, [n1])}
        clause('KISTAX REG_BC')             { |_,_|      AST::Instruction.new(2, [])}
        clause('KIINX REG_BC')              { |_,_|      AST::Instruction.new(3, [])}
        clause('KIINR REG_B')               { |_,_|      AST::Instruction.new(4, [])}
        clause('KIDCR REG_B')               { |_,_|      AST::Instruction.new(5, [])}
        clause('KIMVI REG_B COMMA NUMBER')  { |_,_,_,n1| AST::Instruction.new(6, [n1])}
        clause('KIRLC')                     { |_|        AST::Instruction.new(7, [])}
        clause('KINULL')                    { |_|        AST::Instruction.new(8, [])}
        clause('KIDAD REG_BC')              { |_,_|      AST::Instruction.new(9, [])}
        clause('KILDAX REG_BC')             { |_,_|      AST::Instruction.new(10, [])}
        clause('KIDCX REG_BC')              { |_,_|      AST::Instruction.new(11, [])}
        clause('KIINR REG_C')               { |_,_|      AST::Instruction.new(12, [])}
        clause('KIDCR REG_C')               { |_,_|      AST::Instruction.new(13, [])}
        clause('KIMVI REG_C COMMA NUMBER')  { |_,_,_,n1| AST::Instruction.new(14, [n1])}
        clause('KIRRC')                     { |_|        AST::Instruction.new(15, [])}
        clause('KINULL')                    { |_|        AST::Instruction.new(16, [])}
        clause('KILXI REG_DE COMMA NUMBER') { |_,_,_,n1| AST::Instruction.new(17, [n1])}
        clause('KISTAX REG_DE')             { |_,_|      AST::Instruction.new(18, [])}
        clause('KIINX REG_DE')              { |_,_|      AST::Instruction.new(19, [])}
        clause('KIINR REG_D')               { |_,_|      AST::Instruction.new(20, [])}
        clause('KIDCR REG_D')               { |_,_|      AST::Instruction.new(21, [])}
        clause('KIMVI REG_D COMMA NUMBER')  { |_,_,_,n1| AST::Instruction.new(22, [n1])}
        clause('KIRAL')                     { |_|        AST::Instruction.new(23, [])}
        clause('KINULL')                    { |_|        AST::Instruction.new(24, [])}
        clause('KIDAD REG_DE')              { |_,_|      AST::Instruction.new(25, [])}
        clause('KILDAX REG_DE')             { |_,_|      AST::Instruction.new(26, [])}
        clause('KIDCX REG_DE')              { |_,_|      AST::Instruction.new(27, [])}
        clause('KIINR REG_E')               { |_,_|      AST::Instruction.new(28, [])}
        clause('KIDCR REG_E')               { |_,_|      AST::Instruction.new(29, [])}
        clause('KIMVI REG_E COMMA NUMBER')  { |_,_,_,n1| AST::Instruction.new(30, [n1])}
        clause('KIRAR')                     { |_|        AST::Instruction.new(31, [])}
        clause('KIRIM')                     { |_|        AST::Instruction.new(32, [])}
        clause('KILXI REG_HL COMMA NUMBER') { |_,_,_,n1| AST::Instruction.new(33, [n1])}
        clause('KISHLD address')            { |_,n1|     AST::Instruction.new(34, [n1])}
        clause('KIINX REG_HL')              { |_,_|      AST::Instruction.new(35, [])}
        clause('KIINR REG_H')               { |_,_|      AST::Instruction.new(36, [])}
        clause('KIDCR REG_H')               { |_,_|      AST::Instruction.new(37, [])}
        clause('KIMVI REG_H COMMA NUMBER')  { |_,_,_,n1| AST::Instruction.new(38, [n1])}
        clause('KIDAA')                     { |_|        AST::Instruction.new(39, [])}
        clause('KINULL')                    { |_|        AST::Instruction.new(40, [])}
        clause('KIDAD REG_HL')              { |_,_|      AST::Instruction.new(41, [])}
        clause('KILHLD address')            { |_,n1|     AST::Instruction.new(42, [n1])}
        clause('KIDCX REG_HL')              { |_,_|      AST::Instruction.new(43, [])}
        clause('KIINR REG_L')               { |_,_|      AST::Instruction.new(44, [])}
        clause('KIDCR REG_L')               { |_,_|      AST::Instruction.new(45, [])}
        clause('KIMVI REG_L COMMA NUMBER')  { |_,_,_,n1| AST::Instruction.new(46, [n1])}
        clause('KICMA')                     { |_|        AST::Instruction.new(47, [])}
        clause('KISIM')                     { |_|        AST::Instruction.new(48, [])}
        clause('KILXI REG_SP COMMA NUMBER') { |_,_,_,n1| AST::Instruction.new(49, [n1])}
        clause('KISTA address')             { |_,n1|     AST::Instruction.new(50, [n1])}
        clause('KIINX REG_SP')              { |_,_|      AST::Instruction.new(51, [])}
        clause('KIINR REG_M')               { |_,_|      AST::Instruction.new(52, [])}
        clause('KIDCR REG_M')               { |_,_|      AST::Instruction.new(53, [])}
        clause('KIMVI REG_M COMMA NUMBER')  { |_,_,_,n1| AST::Instruction.new(54, [n1])}
        clause('KISTC')                     { |_|        AST::Instruction.new(55, [])}
        clause('KINULL')                    { |_|        AST::Instruction.new(56, [])}
        clause('KIDAD REG_SP')              { |_,_|      AST::Instruction.new(57, [])}
        clause('KILDA address')             { |_,n1|     AST::Instruction.new(58, [n1])}
        clause('KIDCX REG_SP')              { |_,_|      AST::Instruction.new(59, [])}
        clause('KIINR REG_A')               { |_,_|      AST::Instruction.new(60, [])}
        clause('KIDCR REG_A')               { |_,_|      AST::Instruction.new(61, [])}
        clause('KIMVI REG_A COMMA NUMBER')  { |_,_,_,n1| AST::Instruction.new(62, [n1])}
        clause('KICMC')                     { |_|        AST::Instruction.new(63, [])}
        clause('KIMOV REG_B COMMA REG_B')   { |_,_,_,_|  AST::Instruction.new(64, [])}
        clause('KIMOV REG_B COMMA REG_C')   { |_,_,_,_|  AST::Instruction.new(65, [])}
        clause('KIMOV REG_B COMMA REG_D')   { |_,_,_,_|  AST::Instruction.new(66, [])}
        clause('KIMOV REG_B COMMA REG_B')   { |_,_,_,_|  AST::Instruction.new(67, [])}
        clause('KIMOV REG_B COMMA REG_H')   { |_,_,_,_|  AST::Instruction.new(68, [])}
        clause('KIMOV REG_B COMMA REG_L')   { |_,_,_,_|  AST::Instruction.new(69, [])}
        clause('KIMOV REG_B COMMA REG_M')   { |_,_,_,_|  AST::Instruction.new(70, [])}
        clause('KIMOV REG_B COMMA REG_A')   { |_,_,_,_|  AST::Instruction.new(71, [])}
        clause('KIMOV REG_C COMMA REG_B')   { |_,_,_,_|  AST::Instruction.new(72, [])}
        clause('KIMOV REG_C COMMA REG_C')   { |_,_,_,_|  AST::Instruction.new(73, [])}
        clause('KIMOV REG_C COMMA REG_D')   { |_,_,_,_|  AST::Instruction.new(74, [])}
        clause('KIMOV REG_C COMMA REG_E')   { |_,_,_,_|  AST::Instruction.new(75, [])}
        clause('KIMOV REG_C COMMA REG_H')   { |_,_,_,_|  AST::Instruction.new(76, [])}
        clause('KIMOV REG_C COMMA REG_L')   { |_,_,_,_|  AST::Instruction.new(77, [])}
        clause('KIMOV REG_C COMMA REG_M')   { |_,_,_,_|  AST::Instruction.new(78, [])}
        clause('KIMOV REG_C COMMA REG_A')   { |_,_,_,_|  AST::Instruction.new(79, [])}
        clause('KIMOV REG_D COMMA REG_B')   { |_,_,_,_|  AST::Instruction.new(80, [])}
        clause('KIMOV REG_D COMMA REG_C')   { |_,_,_,_|  AST::Instruction.new(81, [])}
        clause('KIMOV REG_D COMMA REG_D')   { |_,_,_,_|  AST::Instruction.new(82, [])}
        clause('KIMOV REG_D COMMA REG_E')   { |_,_,_,_|  AST::Instruction.new(83, [])}
        clause('KIMOV REG_D COMMA REG_H')   { |_,_,_,_|  AST::Instruction.new(84, [])}
        clause('KIMOV REG_D COMMA REG_L')   { |_,_,_,_|  AST::Instruction.new(85, [])}
        clause('KIMOV REG_D COMMA REG_M')   { |_,_,_,_|  AST::Instruction.new(86, [])}
        clause('KIMOV REG_D COMMA REG_A')   { |_,_,_,_|  AST::Instruction.new(87, [])}
        clause('KIMOV REG_E COMMA REG_B')   { |_,_,_,_|  AST::Instruction.new(88, [])}
        clause('KIMOV REG_E COMMA REG_C')   { |_,_,_,_|  AST::Instruction.new(89, [])}
        clause('KIMOV REG_E COMMA REG_D')   { |_,_,_,_|  AST::Instruction.new(90, [])}
        clause('KIMOV REG_E COMMA REG_E')   { |_,_,_,_|  AST::Instruction.new(91, [])}
        clause('KIMOV REG_E COMMA REG_H')   { |_,_,_,_|  AST::Instruction.new(92, [])}
        clause('KIMOV REG_E COMMA REG_L')   { |_,_,_,_|  AST::Instruction.new(93, [])}
        clause('KIMOV REG_E COMMA REG_M')   { |_,_,_,_|  AST::Instruction.new(94, [])}
        clause('KIMOV REG_E COMMA REG_A')   { |_,_,_,_|  AST::Instruction.new(95, [])}
        clause('KIMOV REG_H COMMA REG_B')   { |_,_,_,_|  AST::Instruction.new(96, [])}
        clause('KIMOV REG_H COMMA REG_C')   { |_,_,_,_|  AST::Instruction.new(97, [])}
        clause('KIMOV REG_H COMMA REG_D')   { |_,_,_,_|  AST::Instruction.new(98, [])}
        clause('KIMOV REG_H COMMA REG_E')   { |_,_,_,_|  AST::Instruction.new(99, [])}
        clause('KIMOV REG_H COMMA REG_H')   { |_,_,_,_|  AST::Instruction.new(100, [])}
        clause('KIMOV REG_H COMMA REG_L')   { |_,_,_,_|  AST::Instruction.new(101, [])}
        clause('KIMOV REG_H COMMA REG_M')   { |_,_,_,_|  AST::Instruction.new(102, [])}
        clause('KIMOV REG_H COMMA REG_A')   { |_,_,_,_|  AST::Instruction.new(103, [])}
        clause('KIMOV REG_L COMMA REG_B')   { |_,_,_,_|  AST::Instruction.new(104, [])}
        clause('KIMOV REG_L COMMA REG_C')   { |_,_,_,_|  AST::Instruction.new(105, [])}
        clause('KIMOV REG_L COMMA REG_D')   { |_,_,_,_|  AST::Instruction.new(106, [])}
        clause('KIMOV REG_L COMMA REG_E')   { |_,_,_,_|  AST::Instruction.new(107, [])}
        clause('KIMOV REG_L COMMA REG_H')   { |_,_,_,_|  AST::Instruction.new(108, [])}
        clause('KIMOV REG_L COMMA REG_L')   { |_,_,_,_|  AST::Instruction.new(109, [])}
        clause('KIMOV REG_L COMMA REG_M')   { |_,_,_,_|  AST::Instruction.new(110, [])}
        clause('KIMOV REG_L COMMA REG_A')   { |_,_,_,_|  AST::Instruction.new(111, [])}
        clause('KIMOV REG_M COMMA REG_B')   { |_,_,_,_|  AST::Instruction.new(112, [])}
        clause('KIMOV REG_M COMMA REG_C')   { |_,_,_,_|  AST::Instruction.new(113, [])}
        clause('KIMOV REG_M COMMA REG_D')   { |_,_,_,_|  AST::Instruction.new(114, [])}
        clause('KIMOV REG_M COMMA REG_E')   { |_,_,_,_|  AST::Instruction.new(115, [])}
        clause('KIMOV REG_M COMMA REG_H')   { |_,_,_,_|  AST::Instruction.new(116, [])}
        clause('KIMOV REG_M COMMA REG_L')   { |_,_,_,_|  AST::Instruction.new(117, [])}
        clause('KIHLT')                     { |_|        AST::Instruction.new(118, [])}
        clause('KIMOV REG_M COMMA REG_A')   { |_,_,_,_|  AST::Instruction.new(119, [])}
        clause('KIMOV REG_A COMMA REG_B')   { |_,_,_,_|  AST::Instruction.new(120, [])}
        clause('KIMOV REG_A COMMA REG_C')   { |_,_,_,_|  AST::Instruction.new(121, [])}
        clause('KIMOV REG_A COMMA REG_D')   { |_,_,_,_|  AST::Instruction.new(122, [])}
        clause('KIMOV REG_A COMMA REG_E')   { |_,_,_,_|  AST::Instruction.new(123, [])}
        clause('KIMOV REG_A COMMA REG_H')   { |_,_,_,_|  AST::Instruction.new(124, [])}
        clause('KIMOV REG_A COMMA REG_L')   { |_,_,_,_|  AST::Instruction.new(125, [])}
        clause('KIMOV REG_A COMMA REG_M')   { |_,_,_,_|  AST::Instruction.new(126, [])}
        clause('KIMOV REG_A COMMA REG_A')   { |_,_,_,_|  AST::Instruction.new(127, [])}
        clause('KIADD REG_B')               { |_,_|      AST::Instruction.new(128, [])}
        clause('KIADD REG_C')               { |_,_|      AST::Instruction.new(129, [])}
        clause('KIADD REG_D')               { |_,_|      AST::Instruction.new(130, [])}
        clause('KIADD REG_E')               { |_,_|      AST::Instruction.new(131, [])}
        clause('KIADD REG_H')               { |_,_|      AST::Instruction.new(132, [])}
        clause('KIADD REG_L')               { |_,_|      AST::Instruction.new(133, [])}
        clause('KIADD REG_M')               { |_,_|      AST::Instruction.new(134, [])}
        clause('KIADD REG_A')               { |_,_|      AST::Instruction.new(135, [])}
        clause('KIADC REG_B')               { |_,_|      AST::Instruction.new(136, [])}
        clause('KIADC REG_C')               { |_,_|      AST::Instruction.new(137, [])}
        clause('KIADC REG_D')               { |_,_|      AST::Instruction.new(138, [])}
        clause('KIADC REG_E')               { |_,_|      AST::Instruction.new(139, [])}
        clause('KIADC REG_H')               { |_,_|      AST::Instruction.new(140, [])}
        clause('KIADC REG_L')               { |_,_|      AST::Instruction.new(141, [])}
        clause('KIADC REG_M')               { |_,_|      AST::Instruction.new(142, [])}
        clause('KIADC REG_A')               { |_,_|      AST::Instruction.new(143, [])}
        clause('KISUB REG_B')               { |_,_|      AST::Instruction.new(144, [])}
        clause('KISUB REG_C')               { |_,_|      AST::Instruction.new(145, [])}
        clause('KISUB REG_D')               { |_,_|      AST::Instruction.new(146, [])}
        clause('KISUB REG_E')               { |_,_|      AST::Instruction.new(147, [])}
        clause('KISUB REG_H')               { |_,_|      AST::Instruction.new(148, [])}
        clause('KISUB REG_L')               { |_,_|      AST::Instruction.new(149, [])}
        clause('KISUB REG_M')               { |_,_|      AST::Instruction.new(150, [])}
        clause('KISUB REG_A')               { |_,_|      AST::Instruction.new(151, [])}
        clause('KISBB REG_B')               { |_,_|      AST::Instruction.new(152, [])}
        clause('KISBB REG_C')               { |_,_|      AST::Instruction.new(153, [])}
        clause('KISBB REG_D')               { |_,_|      AST::Instruction.new(154, [])}
        clause('KISBB REG_E')               { |_,_|      AST::Instruction.new(155, [])}
        clause('KISBB REG_H')               { |_,_|      AST::Instruction.new(156, [])}
        clause('KISBB REG_L')               { |_,_|      AST::Instruction.new(157, [])}
        clause('KISBB REG_M')               { |_,_|      AST::Instruction.new(158, [])}
        clause('KISBB REG_A')               { |_,_|      AST::Instruction.new(159, [])}
        clause('KIANA REG_B')               { |_,_|      AST::Instruction.new(160, [])}
        clause('KIANA REG_C')               { |_,_|      AST::Instruction.new(161, [])}
        clause('KIANA REG_D')               { |_,_|      AST::Instruction.new(162, [])}
        clause('KIANA REG_E')               { |_,_|      AST::Instruction.new(163, [])}
        clause('KIANA REG_H')               { |_,_|      AST::Instruction.new(164, [])}
        clause('KIANA REG_L')               { |_,_|      AST::Instruction.new(165, [])}
        clause('KIANA REG_M')               { |_,_|      AST::Instruction.new(166, [])}
        clause('KIANA REG_A')               { |_,_|      AST::Instruction.new(167, [])}
        clause('KIXRA REG_B')               { |_,_|      AST::Instruction.new(168, [])}
        clause('KIXRA REG_C')               { |_,_|      AST::Instruction.new(169, [])}
        clause('KIXRA REG_D')               { |_,_|      AST::Instruction.new(170, [])}
        clause('KIXRA REG_E')               { |_,_|      AST::Instruction.new(171, [])}
        clause('KIXRA REG_H')               { |_,_|      AST::Instruction.new(172, [])}
        clause('KIXRA REG_L')               { |_,_|      AST::Instruction.new(173, [])}
        clause('KIXRA REG_M')               { |_,_|      AST::Instruction.new(174, [])}
        clause('KIXRA REG_A')               { |_,_|      AST::Instruction.new(175, [])}
        clause('KIORA REG_B')               { |_,_|      AST::Instruction.new(176, [])}
        clause('KIORA REG_C')               { |_,_|      AST::Instruction.new(177, [])}
        clause('KIORA REG_D')               { |_,_|      AST::Instruction.new(178, [])}
        clause('KIORA REG_E')               { |_,_|      AST::Instruction.new(179, [])}
        clause('KIORA REG_H')               { |_,_|      AST::Instruction.new(180, [])}
        clause('KIORA REG_L')               { |_,_|      AST::Instruction.new(181, [])}
        clause('KIORA REG_M')               { |_,_|      AST::Instruction.new(182, [])}
        clause('KIORA REG_A')               { |_,_|      AST::Instruction.new(183, [])}
        clause('KICMP REG_B')               { |_,_|      AST::Instruction.new(184, [])}
        clause('KICMP REG_C')               { |_,_|      AST::Instruction.new(185, [])}
        clause('KICMP REG_D')               { |_,_|      AST::Instruction.new(186, [])}
        clause('KICMP REG_E')               { |_,_|      AST::Instruction.new(187, [])}
        clause('KICMP REG_H')               { |_,_|      AST::Instruction.new(188, [])}
        clause('KICMP REG_L')               { |_,_|      AST::Instruction.new(189, [])}
        clause('KICMP REG_M')               { |_,_|      AST::Instruction.new(190, [])}
        clause('KICMP REG_A')               { |_,_|      AST::Instruction.new(191, [])}
        clause('KIRNZ')                     { |_|        AST::Instruction.new(192, [])}
        clause('KIPOP REG_BC')              { |_,_|      AST::Instruction.new(193, [])}
        clause('KIJNZ address')             { |_,n1|     AST::Instruction.new(194, [n1])}
        clause('KIJMP address')             { |_,n1|     AST::Instruction.new(195, [n1])}
        clause('KICNZ address')             { |_,n1|     AST::Instruction.new(196, [n1])}
        clause('KIPUSH REG_BC')             { |_,_|      AST::Instruction.new(197, [])}
        clause('KIADI NUMBER')              { |_,n1|     AST::Instruction.new(198, [n1])}
        clause('KIRST NUM0')                { |_,_|      AST::Instruction.new(199, [])}
        clause('KIRZ')                      { |_|        AST::Instruction.new(200, [])}
        clause('KIRET')                     { |_|        AST::Instruction.new(201, [])}
        clause('KIJZ address')              { |_,n1|     AST::Instruction.new(202, [n1])}
        clause('KINULL')                    { |_|        AST::Instruction.new(203, [])}
        clause('KICZ address')              { |_,n1|     AST::Instruction.new(204, [n1])}
        clause('KICALL address')            { |_,n1|     AST::Instruction.new(205, [n1])}
        clause('KIACI NUMBER')              { |_,n1|     AST::Instruction.new(206, [n1])}
        clause('KIRST NUM1')                { |_,_|      AST::Instruction.new(207, [])}
        clause('KIRNC')                     { |_|        AST::Instruction.new(208, [])}
        clause('KIPOP REG_DE')              { |_,_|      AST::Instruction.new(209, [])}
        clause('KIJNC address')             { |_,n1|     AST::Instruction.new(210, [n1])}
        clause('KIOUT address')             { |_,n1|     AST::Instruction.new(211, [n1])}
        clause('KICNC address')             { |_,n1|     AST::Instruction.new(212, [n1])}
        clause('KIPUSH REG_DE')             { |_,_|      AST::Instruction.new(213, [])}
        clause('KISUI NUMBER')              { |_,n1|     AST::Instruction.new(214, [n1])}
        clause('KIRST NUM2')                { |_,_|      AST::Instruction.new(215, [])}
        clause('KIRC')                      { |_|        AST::Instruction.new(216, [])}
        clause('KINULL')                    { |_|        AST::Instruction.new(217, [])}
        clause('KIJC address')              { |_,n1|     AST::Instruction.new(218, [n1])}
        clause('KIIN address')              { |_,n1|     AST::Instruction.new(219, [n1])}
        clause('KICC address')              { |_,n1|     AST::Instruction.new(220, [n1])}
        clause('KINULL')                    { |_|        AST::Instruction.new(221, [])}
        clause('KISBI NUMBER')              { |_,n1|     AST::Instruction.new(222, [n1])}
        clause('KIRST NUM3')                { |_,_|      AST::Instruction.new(223, [])}
        clause('KIRPO')                     { |_|        AST::Instruction.new(224, [])}
        clause('KIPOP REG_HL')              { |_,_|      AST::Instruction.new(225, [])}
        clause('KIJPO')                     { |_|        AST::Instruction.new(226, [])}
        clause('KIXTHL')                    { |_|        AST::Instruction.new(227, [])}
        clause('KICPO address')             { |_,n1|     AST::Instruction.new(228, [n1])}
        clause('KIPUSH REG_HL')             { |_,_|      AST::Instruction.new(229, [])}
        clause('KIANI NUMBER')              { |_,n1|     AST::Instruction.new(230, [n1])}
        clause('KIRST NUM4')                { |_,_|      AST::Instruction.new(231, [])}
        clause('KIRPE')                     { |_|        AST::Instruction.new(232, [])}
        clause('KIPCHL')                    { |_|        AST::Instruction.new(233, [])}
        clause('KIJPE address')             { |_,n1|     AST::Instruction.new(234, [n1])}
        clause('KIXCHG')                    { |_|        AST::Instruction.new(235, [])}
        clause('KICPE address')             { |_,n1|     AST::Instruction.new(236, [n1])}
        clause('KINULL')                    { |_|        AST::Instruction.new(237, [])}
        clause('KIXRI NUMBER')              { |_,n1|     AST::Instruction.new(238, [n1])}
        clause('KIRST NUM5')                { |_,_|      AST::Instruction.new(239, [])}
        clause('KIRP')                      { |_|        AST::Instruction.new(240, [])}
        clause('KIPOP REG_PSW')             { |_,_|      AST::Instruction.new(241, [])}
        clause('KIJP address')              { |_,n1|     AST::Instruction.new(242, [n1])}
        clause('KIDI')                      { |_|        AST::Instruction.new(243, [])}
        clause('KICP address')              { |_,n1|     AST::Instruction.new(244, [n1])}
        clause('KIPUSH REG_PSW')            { |_,_|      AST::Instruction.new(245, [])}
        clause('KIORI NUMBER')              { |_,n1|     AST::Instruction.new(246, [n1])}
        clause('KIRST NUM6')                { |_,_|      AST::Instruction.new(247, [])}
        clause('KIRM')                      { |_|        AST::Instruction.new(248, [])}
        clause('KISPHL')                    { |_|        AST::Instruction.new(249, [])}
        clause('KIJM address')              { |_,n1|     AST::Instruction.new(250, [n1])}
        clause('KIEI')                      { |_|        AST::Instruction.new(251, [])}
        clause('KICM address')              { |_,n1|     AST::Instruction.new(252, [n1])}
        clause('KINULL')                    { |_|        AST::Instruction.new(253, [])}
        clause('KICPI NUMBER')              { |_,n1|     AST::Instruction.new(254, [n1])}
        clause('KIRST NUM7')                { |_,_|      AST::Instruction.new(255, [])}
      end
      empty_list(:params, :param, :COMMA)
      production(:param) do
        clause("REG")       { |t| AST::Register.new(t) }
        clause("NUMBER")    { |t| AST::Number.new(t) }
        clause("namespace_arg") { |t| t }
        clause("IDENT")     { |t| t }
      end
      production(:address) do
        clause('IDENT')     { |i| AST::Label.new(i) }
        clause('NUMBER')    { |n| AST::Number.new(n) }
        clause('namespace_label') { |i| i }
      end
      production(:namespace_label, "namespace_arg PERIOD IDENT") do |ns, _, lb|
        AST::NamespaceLabel.new(lb, ns)
      end
      ### finalize
      finalize use: 'sparser.tbl'#, lookahead: false
    end
  end
end