#
# Sadie/src/ReaktorBase.rb
#   by IceDragon
#   dc 11/03/2013
#   dm 20/05/2013
module Sadie
  class ReaktorBase

    class RegistrationError < Exception
    end

    include Sadie::Callback

    ## constants
    VERSION = "1.5.0".freeze

    ## class variables
    @@reaktor_register = {}

    ## instance attributes
    attr_reader :energy # Sadie::Energy
    attr_reader :input, # Hash<INPUT, ReaktorBase*>
                :output # Hash<OUTPUT, ReaktorBase*>

    ##
    # initialize
    def initialize
      init_callbacks
      init
    end

    ##
    # init
    def init
      @energy = Sadie::Energy.new(0)
      @input  = {}
      @output = {}
      setup_ports
    end

    ##
    # setup_ports
    def setup_ports
      # overwrite in sublass to add inputs and outputs (VERSION < 1.4.0)
      # Since VERSION 1.4.0 + IO is handled using the register_input/output sys
      self.class.inputs.each_pair { |id, _| @input[id] = nil }
      self.class.outputs.each_pair { |id, _| @output[id] = nil }
    end

    ##
    # valid_input?(INPUT input_id)
    def valid_input?(input_id)
      @input.has_key?(input_id)
    end

    ##
    # valid_output?(OUTPUT input_id)
    def valid_output?(output_id)
      @output.has_key?(output_id)
    end

    ##
    # input_connected?(INPUT input_id)
    def input_connected?(input_id)
      !@input[input_id].nil?
    end

    ##
    # output_connected?(OUTPUT input_id)
    def output_connected?(output_id)
      !@output[output_id].nil?
    end

    ##
    # reset
    def reset
      # restore component to some original state
    end

    ##
    # connect(OUTPUT from_output_id, INPUT to_input_id, ReaktorBase* reaktor)
    def connect(from_output_id, to_input_id, reaktor)
              connect_to(:output, reaktor, from_output_id, to_input_id)
      reaktor.connect_to(:input, self, to_input_id, from_output_id)
    end

    ##
    # connect_to(Symbol[:input, :output] i_or_o,
    #            ReaktorBase* reaktor, INTERFACE to, INTERFACE from)
    def connect_to(i_or_o, reaktor, to, from)
      to_input  = i_or_o == :input
      to_output = i_or_o == :output
      raise(ArgumentError) unless to_input || to_output
      interface = to_input ? @input : @output
      valid = to_input ? valid_input?(to) : valid_output?(to)
      raise(ArgumentError, "interface_id #{to} for #{i_or_o} is invalid") unless valid
      input_id, output_id = to_input ? [to, from] : [from, to]
      interface[to] = Sadie::Connection.new(reaktor, input_id, output_id)
    end

    ##
    # react(INPUT input_id, Energy energy)
    def react(input_id, energy)
      # react from another reaktor
      # handle the input_id and act on the given energy value
      connection = @input[input_id]
      try_callback(:on_react,
                   self, connection, energy) if valid_input?(input_id)
    end

    ##
    # emit_energy -> Energy
    def emit_energy
      # do something with the energy before using it for emission, for example
      # making a clone, when using an EmitterReaktor
      @energy
    end

    ##
    # emit(OUTPUT output_id)
    # emit(OUTPUT output_id, Energy energy)
    def emit(output_id, energy=emit_energy)
      # default emission action
      if connection = @output[output_id]
        connection.reaktor.react(connection.input_id, energy)
        try_callback(:on_emit, self, connection, energy)
      end
    end

    ### Reaktor Registration System
    ##
    # ::register(String name)
    def self.register(name)
      raise(RegistrationError,
            "%s tried to register, but %s is already registered as %s" %
            [self, name, @@reaktor_register[name]]
            ) if @@reaktor_register.has_key?(name)
      @@reaktor_register[name] = self
    end

    ##
    # ::unregister(String name)
    def self.unregister(name)
      @@reaktor_register.delete(name)
    end

    ##
    # ::reaktors -> Array<ReaktorBase*>
    def self.reaktors
      @@reaktor_register.values
    end

    ##
    # ::[String name] -> ReaktorBase*
    def self.[](name)
      @@reaktor_register[name]
    end

    ##
    # ::reaktor_book -> Hash<String, ReaktorBase*>
    def self.reaktor_book
      @@reaktor_register
    end

    ### Reaktor Settings
    ##
    # ::inputs -> Hash<String name, Integer id>
    def self.inputs
      @inputs ||= {}
    end

    ##
    # ::outputs -> Hash<String name, Integer id>
    def self.outputs
      @outputs ||= {}
    end

    ##
    # ::register_input(Integer id, String name)
    def self.register_input(id, name="")
      inputs[id] = name
    end

    ##
    # ::register_output(Integer id, String name)
    def self.register_output(id, name="")
      outputs[id] = name
    end

  end

  Reaktor = Sadie::ReaktorBase

end
