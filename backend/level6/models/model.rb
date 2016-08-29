require "json"
require_relative "../memory/memory.rb"

class Model
    def to_json(options = {})
        hash = {}
        self.instance_variables.each do |var|
            hash[var] = self.instance_variable_get var
        end
        hash.to_json
    end

    protected
    def valid?
        self.instance_variables.inject(true) do |acc, var|
            var_name = var.to_s.delete('@')
            method_name = "#{var_name}_valid?"
            self.respond_to?(method_name, true) ? (send(method_name) and acc) : acc
        end
    end

    def safe_to_i(value)
        (value + 0.5).to_i
    end
end