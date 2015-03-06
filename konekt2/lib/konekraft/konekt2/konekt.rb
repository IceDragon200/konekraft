module Konekraft
  module Konekt2
    class RegistrationError < Exception
    end

    ### class_variables
    @@konekt_register = {}

    ### Konekt Registration System
    ##
    # ::register(Konekt* konekt, String name)
    def self.register(konekt, name)
      raise(RegistrationError,
            "%s tried to register, but %s is already registered as %s" %
            [konekt, name, @@konekt_register[name]]
            ) if @@konekt_register.has_key?(name)
      @@konekt_register[name] = konekt
    end

    ##
    # ::unregister(String name)
    def self.unregister(name)
      @@konekt_register.delete(name)
    end

    ##
    # ::konekts -> Array<Konekt*>
    def self.konekts
      @@konekt_register.values
    end

    ##
    # ::[String name] -> Konekt*
    def self.[](name)
      @@konekt_register[name]
    end

    ##
    # ::konekt_entries -> Hash<String, KonektBase*>
    def self.konekt_entries
      @@konekt_register
    end

    def self.find(name)
      @@konekt_register.fetch(name)
    end

    def self.all
      konekts
    end

    def self.load_rktm_h(hsh)
      konekt_klass = find(hsh.delete("TYPE"))
      konekt = konekt_klass.new
      konekt.import_rktm_h(hsh)
      return konekt
    end
  end
end
