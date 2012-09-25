require 'active_support/core_ext/hash'

module NetworkExecutive
  class Configuration
    attr_accessor :name

    @@defaults = HashWithIndifferentAccess.new(
      name: 'My Network'
    )

    def initialize
      @@defaults.dup.each_pair { |k, v| self.send "#{k}=", v }
    end

    def defaults
      @@defaults
    end

    def attributes
      self.class.defaults.keys.each_with_object(HashWithIndifferentAccess.new) do |k, hash|
        hash[k] = self.send k
      end
    end
    alias_method :to_hash, :attributes
  end
end