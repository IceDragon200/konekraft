#!/usr/bin/ruby
# Sadie/test/test-reaktor2x.rb
#
require_relative 'common'

FileUtils.rm(Dir.glob("log/*"), force: true)

def frame_sleep
  sleep 1.0 / 20.0
end

def quick_network
  ###
  logname = caller_locations(1,1)[0].label
  Dir.mkdir("log") unless Dir.exist?("log")
  log = File.new("log/#{logname}.log", "w+")
  log.sync = true
  #Sadie::Reaktor::Base.vlog = log
  ###
  network = Sadie::Reaktor::Network.new
  network.vlog = log
  yield network
  network.terminate
end

def network_block(network, hsh={})
  condition_func = hsh[:condition_func]
  ###
  condition_func ||= ->(net) { net.ticks > 4 }
  ###
  loop do
    network.vlog.puts # space!
    frame_sleep
    yield network if block_given?
    network.tick
    network.trigger
    network.post_tick
    break if condition_func.(network)
  end
  network.vlog.puts # space!
end

##
# this test-suite is created for Reaktor 2.x components
class SadieReaktor2xTest < Test::Unit::TestCase

  include Sadie::Reaktor

  #File.write("reaktor_map.lst", Sadie::Reaktor.reaktors.map do |rktr_c|
  #  [rktr_c.name.to_s, rktr_c.port_spec.map { |k, v| {k => v.to_s} }.join("\n")]
  #end.join("\n\n"))

  def test_busbar
    quick_network do |network|
      emitter = network.add_main(Emitter)
      busbar  = network.add(Busbar)
      ###
      emitter.energy.value += 1
      ###
      (emitter/:output) | (busbar/:common)
      ###
      network_block(network)
    end
  end

  def test_capacitor
    quick_network do |network|
      emitter = network.add_main(Emitter)
      capacitor = network.add(Capacitor)
      ###
      emitter.energy.value += 1
      capacitor.charge_ceil = 14
      (emitter/:output) | (capacitor/:input)
      ###
      network_block(network)
    end
  end

  def test_contactor
    quick_network do |network|
      emitter_aux1 = network.add_main(Emitter)
      emitter_aux2 = network.add_main(Emitter)
      emitter_common1 = network.add_main(Emitter)
      emitter_common2 = network.add_main(Emitter)
      emitter_common3 = network.add_main(Emitter)
      contactor = network.add(Contactor)
      ### energy setup
      emitter_aux1.energy.value += 4
      emitter_aux2.energy.value += 4
      emitter_common1.energy.value += 1
      emitter_common2.energy.value += 1
      emitter_common3.energy.value += 1
      ### connection
      (emitter_aux1/:output) | (contactor/:aux1_in)
      (emitter_aux2/:output) | (contactor/:aux2_in)
      (emitter_common1/:output) | (contactor/:common1_in)
      (emitter_common2/:output) | (contactor/:common2_in)
      (emitter_common3/:output) | (contactor/:common3_in)
      ###
      network_block(network)
    end
  end

  def test_counter
    quick_network do |network|
      emitter = network.add_main(Emitter)
      counter = network.add(Counter)
      ###
      emitter.energy.value += 1
      ###
      (emitter/:output) | (counter/:adder)
      ###
      network_block(network)
    end
  end

  def test_drain
    quick_network do |network|
      emitter = network.add_main(Emitter)
      capacitor = network.add(Capacitor)
      drain = network.add(Drain)
      ###
      emitter.energy.value = 1
      capacitor.charge_ceil = 5
      drain.threshold = 3
      ###
      drain.add_callback(:on_react_drain) do |rktr, port, energy|
        rktr.try_vlog { |io| io.puts "  !!! Drained" }
      end
      ###
      (emitter/:output) | (capacitor/:input)
      (capacitor/:output) | (drain/:input)
      ###
      network_block(network)
    end
  end

  def test_emitter
    quick_network do |network|
      emitter = network.add_main(Emitter)
      ###
      emitter.energy.value += 1
      ###
      network_block(network)
    end
  end

  def test_floodgate
    quick_network do |network|
      emitter = network.add_main(Emitter)
      capacitor = network.add(Capacitor)
      floodgate = network.add_main(Floodgate)
      ### setup
      emitter.energy.value = 1
      capacitor.charge_ceil = 7
      floodgate.flood_trigger_thresh = 4
      ### callbacks
      floodgate.add_callback(:on_react_flood) do |rktr, port, energy|
        rktr.try_vlog { |io| io.puts "  !!! DA FLOOD!!! D:" }
      end
      ###
      (emitter/:output) | (capacitor/:input)
      (capacitor/:output) | (floodgate/:input)
      ###
      network_block(network)
    end
  end

  def test_fuse
    quick_network do |network|
      emitter = network.add_main(Emitter)
      capacitor = network.add(Capacitor)
      fuse = network.add_main(Fuse)
      ###
      emitter.energy.value = 1
      capacitor.charge_ceil = 8
      fuse.threshold = 2
      ###
      fuse.add_callback(:on_react_fuse_break) do |rktr, port, energy|
        rktr.try_vlog { |io| io.puts "  !!! Fuse has broken!?" }
      end
      fuse.add_callback(:on_react_fuse_broken) do |rktr, port, energy|
        rktr.try_vlog { |io| io.puts "  !!! The fuse is broken" }
      end
      ###
      (emitter/:output) | (capacitor/:input)
      (capacitor/:output) | (fuse/:input)
      ###
      network_block(network)
    end
  end

  def test_indicator
    quick_network do |network|
      emitter   = network.add_main(Emitter)
      capacitor = network.add(Capacitor)
      indicator = network.add(Indicator)
      ###
      emitter.energy.value = 1
      capacitor.charge_ceil = 8
      indicator.threshold = 4
      ###
      indicator.add_callback(:on_react_just_lit) do |rktr, port, energy|
        rktr.try_vlog { |io| io.puts "  !!! LIT" }
      end
      indicator.add_callback(:on_react_just_unlit) do |rktr, port, energy|
        rktr.try_vlog { |io| io.puts "  !!! UN-LIT" }
      end
      ###
      (emitter/:output) | (capacitor/:input)
      (capacitor/:output) | (indicator/:input)
      ###
      network_block(network)
    end
  end

  def test_momentary_switch
    quick_network do |network|
      emitter    = network.add_main(Emitter)
      mmt_switch = network.add(MomentarySwitch)
      indicator  = network.add(Indicator)
      ###
      emitter.energy.value = 1
      indicator.threshold  = 1
      ###
      (emitter/:output) | (mmt_switch/:input)
      (mmt_switch/:output) | (indicator/:input)
      ###
      network_block(network) do |nwrk|
        mmt_switch.state_press
      end
    end
  end

  def test_passive
    quick_network do |network|
      emitter    = network.add_main(Emitter)
      passive    = network.add(Passive)
      ###
      emitter.energy.value = 1
      ###
      (emitter/:output) | (passive/:input)
      ###
      network_block(network)
    end
  end

  def test_relay
    quick_network do |network|
      emitter        = network.add_main(Emitter)
      emitter_common = network.add_main(Emitter)
      capacitor      = network.add(Capacitor)
      relay          = network.add(Relay)
      indicator_coil = network.add(Indicator)
      indicator_nc   = network.add(Indicator)
      indicator_no   = network.add(Indicator)
      ###
      indicator_coil.name += "_coil"
      indicator_nc.name += "_nc"
      indicator_no.name += "_no"
      ###
      emitter.energy.value = 1
      emitter_common.energy.value = 1
      capacitor.charge_ceil = 5
      relay.coil_state_thresh = 3
      indicator_coil.threshold = 1
      indicator_nc.threshold = 1
      indicator_no.threshold = 1
      ###
      # lit
      indicator_coil.add_callback(:on_react_just_lit) do |rktr, port, energy|
        rktr.try_vlog { |io| io.puts "  !!! Coil Lit" }
      end
      indicator_nc.add_callback(:on_react_just_lit) do |rktr, port, energy|
        rktr.try_vlog { |io| io.puts "  !!! Normally Closed Lit" }
      end
      indicator_no.add_callback(:on_react_just_lit) do |rktr, port, energy|
        rktr.try_vlog { |io| io.puts "  !!! Normally Open Lit" }
      end
      # unlit
      indicator_coil.add_callback(:on_react_just_unlit) do |rktr, port, energy|
        rktr.try_vlog { |io| io.puts "  !!! Coil Unlit" }
      end
      indicator_nc.add_callback(:on_react_just_unlit) do |rktr, port, energy|
        rktr.try_vlog { |io| io.puts "  !!! Normally Closed Unlit" }
      end
      indicator_no.add_callback(:on_react_just_unlit) do |rktr, port, energy|
        rktr.try_vlog { |io| io.puts "  !!! Normally Open Unlit" }
      end
      ###
      (emitter/:output) | (capacitor/:input)
      (capacitor/:output) | (relay/:coil_in)
      (emitter_common/:output) | (relay/:common_in)
      (relay/:coil_out) | (indicator_coil/:input)
      (relay/:nc_out) | (indicator_nc/:input)
      (relay/:no_out) | (indicator_no/:input)
      ###
      network_block(network)
    end
  end

  def test_seven_segment
    quick_network do |network|
      emitter_seg = Array.new(7) { network.add_main(Emitter) }
      seven_segment  = network.add(SevenSegment)
      ###
      emitter_seg.each { |emitter| emitter.energy.value = 1 }
      seven_segment.segment_thresh = 1
      ###
      (emitter_seg[0]/:output) | (seven_segment/:seg1_in)
      (emitter_seg[1]/:output) | (seven_segment/:seg2_in)
      (emitter_seg[2]/:output) | (seven_segment/:seg3_in)
      (emitter_seg[3]/:output) | (seven_segment/:seg4_in)
      (emitter_seg[4]/:output) | (seven_segment/:seg5_in)
      (emitter_seg[5]/:output) | (seven_segment/:seg6_in)
      (emitter_seg[6]/:output) | (seven_segment/:seg7_in)
      ###
      network_block(network)
    end
  end

  def test_switch_spst
    quick_network do |network|
      emitter = network.add_main(Emitter)
      switch  = network.add(SwitchSPST)
      ###
      emitter.energy.value = 1
      ###
      (emitter/:output) | (switch/:l1)
      ###
      network_block(network) do |nwrk|
        switch.state_toggle
      end
    end
  end

  def test_switch_spdt
    quick_network do |network|
      emitter = network.add_main(Emitter)
      switch  = network.add(SwitchSPDT)
      ###
      emitter.energy.value = 1
      ###
      (emitter/:output) | (switch/:l1)
      ###
      network_block(network) do |nwrk|
        switch.state_toggle
      end
    end
  end

  def test_switch_dpst
    quick_network do |network|
      emitter1 = network.add_main(Emitter)
      emitter2 = network.add_main(Emitter)
      switch = network.add(SwitchDPST)
      ###
      emitter1.energy.value = 1
      emitter2.energy.value = 2
      ###
      (emitter1/:output) | (switch/:l1)
      (emitter2/:output) | (switch/:l2)
      ###
      network_block(network) do |nwrk|
        switch.state_toggle
      end
    end
  end

  def test_switch_dpdt
    quick_network do |network|
      emitter1 = network.add_main(Emitter)
      emitter2 = network.add_main(Emitter)
      switch = network.add(SwitchDPDT)
      ###
      emitter1.energy.value = 1
      emitter2.energy.value = 2
      ###
      (emitter1/:output) | (switch/:l1)
      (emitter2/:output) | (switch/:l2)
      ###
      network_block(network) do |nwrk|
        switch.state_toggle
      end
    end
  end

end
