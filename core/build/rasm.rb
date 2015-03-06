        def nop
          _op(0)
        end

        def lxi(regi1, numb1)
          case [_register(regi1)]
          when [:bc] then _op(1, numb1.to_i)
          when [:de] then _op(17, numb1.to_i)
          when [:hl] then _op(33, numb1.to_i)
          when [:sp] then _op(49, numb1.to_i)
          else raise ArgumentError, "invalid parameters #{[_register(regi1)]}"
          end
        end

        def stax(regi1)
          case [_register(regi1)]
          when [:bc] then _op(2)
          when [:de] then _op(18)
          else raise ArgumentError, "invalid parameters #{[_register(regi1)]}"
          end
        end

        def inx(regi1)
          case [_register(regi1)]
          when [:bc] then _op(3)
          when [:de] then _op(19)
          when [:hl] then _op(35)
          when [:sp] then _op(51)
          else raise ArgumentError, "invalid parameters #{[_register(regi1)]}"
          end
        end

        def inr(regi1)
          case [_register(regi1)]
          when [:b] then _op(4)
          when [:c] then _op(12)
          when [:d] then _op(20)
          when [:e] then _op(28)
          when [:h] then _op(36)
          when [:l] then _op(44)
          when [:m] then _op(52)
          when [:a] then _op(60)
          else raise ArgumentError, "invalid parameters #{[_register(regi1)]}"
          end
        end

        def dcr(regi1)
          case [_register(regi1)]
          when [:b] then _op(5)
          when [:c] then _op(13)
          when [:d] then _op(21)
          when [:e] then _op(29)
          when [:h] then _op(37)
          when [:l] then _op(45)
          when [:m] then _op(53)
          when [:a] then _op(61)
          else raise ArgumentError, "invalid parameters #{[_register(regi1)]}"
          end
        end

        def mvi(regi1, numb1)
          case [_register(regi1)]
          when [:b] then _op(6, numb1.to_i)
          when [:c] then _op(14, numb1.to_i)
          when [:d] then _op(22, numb1.to_i)
          when [:e] then _op(30, numb1.to_i)
          when [:h] then _op(38, numb1.to_i)
          when [:l] then _op(46, numb1.to_i)
          when [:m] then _op(54, numb1.to_i)
          when [:a] then _op(62, numb1.to_i)
          else raise ArgumentError, "invalid parameters #{[_register(regi1)]}"
          end
        end

        def rlc
          _op(7)
        end

        def null
          case []
          when [] then _op(8)
          when [] then _op(16)
          when [] then _op(24)
          when [] then _op(40)
          when [] then _op(56)
          when [] then _op(203)
          when [] then _op(217)
          when [] then _op(221)
          when [] then _op(237)
          when [] then _op(253)
          else raise ArgumentError, "invalid parameters #{[]}"
          end
        end

        def dad(regi1)
          case [_register(regi1)]
          when [:bc] then _op(9)
          when [:de] then _op(25)
          when [:hl] then _op(41)
          when [:sp] then _op(57)
          else raise ArgumentError, "invalid parameters #{[_register(regi1)]}"
          end
        end

        def ldax(regi1)
          case [_register(regi1)]
          when [:bc] then _op(10)
          when [:de] then _op(26)
          else raise ArgumentError, "invalid parameters #{[_register(regi1)]}"
          end
        end

        def dcx(regi1)
          case [_register(regi1)]
          when [:bc] then _op(11)
          when [:de] then _op(27)
          when [:hl] then _op(43)
          when [:sp] then _op(59)
          else raise ArgumentError, "invalid parameters #{[_register(regi1)]}"
          end
        end

        def rrc
          _op(15)
        end

        def ral
          _op(23)
        end

        def rar
          _op(31)
        end

        def rim
          _op(32)
        end

        def shld(addr1)
          _op(34, addr1.to_i)
        end

        def daa
          _op(39)
        end

        def lhld(addr1)
          _op(42, addr1.to_i)
        end

        def cma
          _op(47)
        end

        def sim
          _op(48)
        end

        def sta(addr1)
          _op(50, addr1.to_i)
        end

        def stc
          _op(55)
        end

        def lda(addr1)
          _op(58, addr1.to_i)
        end

        def cmc
          _op(63)
        end

        def mov(regi1, regi2)
          case [_register(regi1), _register(regi2)]
          when [:b, :b] then _op(64)
          when [:b, :c] then _op(65)
          when [:b, :d] then _op(66)
          when [:b, :b] then _op(67)
          when [:b, :h] then _op(68)
          when [:b, :l] then _op(69)
          when [:b, :m] then _op(70)
          when [:b, :a] then _op(71)
          when [:c, :b] then _op(72)
          when [:c, :c] then _op(73)
          when [:c, :d] then _op(74)
          when [:c, :e] then _op(75)
          when [:c, :h] then _op(76)
          when [:c, :l] then _op(77)
          when [:c, :m] then _op(78)
          when [:c, :a] then _op(79)
          when [:d, :b] then _op(80)
          when [:d, :c] then _op(81)
          when [:d, :d] then _op(82)
          when [:d, :e] then _op(83)
          when [:d, :h] then _op(84)
          when [:d, :l] then _op(85)
          when [:d, :m] then _op(86)
          when [:d, :a] then _op(87)
          when [:e, :b] then _op(88)
          when [:e, :c] then _op(89)
          when [:e, :d] then _op(90)
          when [:e, :e] then _op(91)
          when [:e, :h] then _op(92)
          when [:e, :l] then _op(93)
          when [:e, :m] then _op(94)
          when [:e, :a] then _op(95)
          when [:h, :b] then _op(96)
          when [:h, :c] then _op(97)
          when [:h, :d] then _op(98)
          when [:h, :e] then _op(99)
          when [:h, :h] then _op(100)
          when [:h, :l] then _op(101)
          when [:h, :m] then _op(102)
          when [:h, :a] then _op(103)
          when [:l, :b] then _op(104)
          when [:l, :c] then _op(105)
          when [:l, :d] then _op(106)
          when [:l, :e] then _op(107)
          when [:l, :h] then _op(108)
          when [:l, :l] then _op(109)
          when [:l, :m] then _op(110)
          when [:l, :a] then _op(111)
          when [:m, :b] then _op(112)
          when [:m, :c] then _op(113)
          when [:m, :d] then _op(114)
          when [:m, :e] then _op(115)
          when [:m, :h] then _op(116)
          when [:m, :l] then _op(117)
          when [:m, :a] then _op(119)
          when [:a, :b] then _op(120)
          when [:a, :c] then _op(121)
          when [:a, :d] then _op(122)
          when [:a, :e] then _op(123)
          when [:a, :h] then _op(124)
          when [:a, :l] then _op(125)
          when [:a, :m] then _op(126)
          when [:a, :a] then _op(127)
          else raise ArgumentError, "invalid parameters #{[_register(regi1), _register(regi2)]}"
          end
        end

        def hlt
          _op(118)
        end

        def add(regi1)
          case [_register(regi1)]
          when [:b] then _op(128)
          when [:c] then _op(129)
          when [:d] then _op(130)
          when [:e] then _op(131)
          when [:h] then _op(132)
          when [:l] then _op(133)
          when [:m] then _op(134)
          when [:a] then _op(135)
          else raise ArgumentError, "invalid parameters #{[_register(regi1)]}"
          end
        end

        def adc(regi1)
          case [_register(regi1)]
          when [:b] then _op(136)
          when [:c] then _op(137)
          when [:d] then _op(138)
          when [:e] then _op(139)
          when [:h] then _op(140)
          when [:l] then _op(141)
          when [:m] then _op(142)
          when [:a] then _op(143)
          else raise ArgumentError, "invalid parameters #{[_register(regi1)]}"
          end
        end

        def sub(regi1)
          case [_register(regi1)]
          when [:b] then _op(144)
          when [:c] then _op(145)
          when [:d] then _op(146)
          when [:e] then _op(147)
          when [:h] then _op(148)
          when [:l] then _op(149)
          when [:m] then _op(150)
          when [:a] then _op(151)
          else raise ArgumentError, "invalid parameters #{[_register(regi1)]}"
          end
        end

        def sbb(regi1)
          case [_register(regi1)]
          when [:b] then _op(152)
          when [:c] then _op(153)
          when [:d] then _op(154)
          when [:e] then _op(155)
          when [:h] then _op(156)
          when [:l] then _op(157)
          when [:m] then _op(158)
          when [:a] then _op(159)
          else raise ArgumentError, "invalid parameters #{[_register(regi1)]}"
          end
        end

        def ana(regi1)
          case [_register(regi1)]
          when [:b] then _op(160)
          when [:c] then _op(161)
          when [:d] then _op(162)
          when [:e] then _op(163)
          when [:h] then _op(164)
          when [:l] then _op(165)
          when [:m] then _op(166)
          when [:a] then _op(167)
          else raise ArgumentError, "invalid parameters #{[_register(regi1)]}"
          end
        end

        def xra(regi1)
          case [_register(regi1)]
          when [:b] then _op(168)
          when [:c] then _op(169)
          when [:d] then _op(170)
          when [:e] then _op(171)
          when [:h] then _op(172)
          when [:l] then _op(173)
          when [:m] then _op(174)
          when [:a] then _op(175)
          else raise ArgumentError, "invalid parameters #{[_register(regi1)]}"
          end
        end

        def ora(regi1)
          case [_register(regi1)]
          when [:b] then _op(176)
          when [:c] then _op(177)
          when [:d] then _op(178)
          when [:e] then _op(179)
          when [:h] then _op(180)
          when [:l] then _op(181)
          when [:m] then _op(182)
          when [:a] then _op(183)
          else raise ArgumentError, "invalid parameters #{[_register(regi1)]}"
          end
        end

        def cmp(regi1)
          case [_register(regi1)]
          when [:b] then _op(184)
          when [:c] then _op(185)
          when [:d] then _op(186)
          when [:e] then _op(187)
          when [:h] then _op(188)
          when [:l] then _op(189)
          when [:m] then _op(190)
          when [:a] then _op(191)
          else raise ArgumentError, "invalid parameters #{[_register(regi1)]}"
          end
        end

        def rnz
          _op(192)
        end

        def pop(regi1)
          case [_register(regi1)]
          when [:bc] then _op(193)
          when [:de] then _op(209)
          when [:hl] then _op(225)
          when [:ps] then _op(241)
          else raise ArgumentError, "invalid parameters #{[_register(regi1)]}"
          end
        end

        def jnz(addr1)
          _op(194, addr1.to_i)
        end

        def jmp(addr1)
          _op(195, addr1.to_i)
        end

        def cnz(addr1)
          _op(196, addr1.to_i)
        end

        def push(regi1)
          case [_register(regi1)]
          when [:bc] then _op(197)
          when [:de] then _op(213)
          when [:hl] then _op(229)
          when [:ps] then _op(245)
          else raise ArgumentError, "invalid parameters #{[_register(regi1)]}"
          end
        end

        def adi(numb1)
          _op(198, numb1.to_i)
        end

        def rst(fixn1)
          case [_rst(fixn1)]
          when [:num0] then _op(199)
          when [:num1] then _op(207)
          when [:num2] then _op(215)
          when [:num3] then _op(223)
          when [:num4] then _op(231)
          when [:num5] then _op(239)
          when [:num6] then _op(247)
          when [:num7] then _op(255)
          else raise ArgumentError, "invalid parameters #{[_rst(fixn1)]}"
          end
        end

        def rz
          _op(200)
        end

        def ret
          _op(201)
        end

        def jz(addr1)
          _op(202, addr1.to_i)
        end

        def cz(addr1)
          _op(204, addr1.to_i)
        end

        def call(addr1)
          _op(205, addr1.to_i)
        end

        def aci(numb1)
          _op(206, numb1.to_i)
        end

        def rnc
          _op(208)
        end

        def jnc(addr1)
          _op(210, addr1.to_i)
        end

        def out(addr1)
          _op(211, addr1.to_i)
        end

        def cnc(addr1)
          _op(212, addr1.to_i)
        end

        def sui(numb1)
          _op(214, numb1.to_i)
        end

        def rc
          _op(216)
        end

        def jc(addr1)
          _op(218, addr1.to_i)
        end

        def in(addr1)
          _op(219, addr1.to_i)
        end

        def cc(addr1)
          _op(220, addr1.to_i)
        end

        def sbi(numb1)
          _op(222, numb1.to_i)
        end

        def rpo
          _op(224)
        end

        def jpo
          _op(226)
        end

        def xthl
          _op(227)
        end

        def cpo(addr1)
          _op(228, addr1.to_i)
        end

        def ani(numb1)
          _op(230, numb1.to_i)
        end

        def rpe
          _op(232)
        end

        def pchl
          _op(233)
        end

        def jpe(addr1)
          _op(234, addr1.to_i)
        end

        def xchg
          _op(235)
        end

        def cpe(addr1)
          _op(236, addr1.to_i)
        end

        def xri(numb1)
          _op(238, numb1.to_i)
        end

        def rp
          _op(240)
        end

        def jp(addr1)
          _op(242, addr1.to_i)
        end

        def di
          _op(243)
        end

        def cp(addr1)
          _op(244, addr1.to_i)
        end

        def ori(numb1)
          _op(246, numb1.to_i)
        end

        def rm
          _op(248)
        end

        def sphl
          _op(249)
        end

        def jm(addr1)
          _op(250, addr1.to_i)
        end

        def ei
          _op(251)
        end

        def cm(addr1)
          _op(252, addr1.to_i)
        end

        def cpi(numb1)
          _op(254, numb1.to_i)
        end

