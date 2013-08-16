#
# Sadie/lib/sadie/reaktor/reaktor.rb
#   dm 15/08/2013
module Sadie
  module Reaktor

    class RegistrationError < Exception
    end

    ### class_variables
    @@reaktor_register = {}

    ### Reaktor Registration System
    ##
    # ::register(Reaktor* reaktor, String name)
    def self.register(reaktor, name)
      raise(RegistrationError,
            "%s tried to register, but %s is already registered as %s" %
            [reaktor, name, @@reaktor_register[name]]
            ) if @@reaktor_register.has_key?(name)
      @@reaktor_register[name] = reaktor
    end

    ##
    # ::unregister(String name)
    def self.unregister(name)
      @@reaktor_register.delete(name)
    end

    ##
    # ::reaktors -> Array<Reaktor*>
    def self.reaktors
      @@reaktor_register.values
    end

    ##
    # ::[String name] -> Reaktor*
    def self.[](name)
      @@reaktor_register[name]
    end

    ##
    # ::reaktor_entries -> Hash<String, ReaktorBase*>
    def self.reaktor_entries
      @@reaktor_register
    end

  end
end