require_relative "model.rb"

class Car < Model
    attr_accessor :car_id, :rentals, :price_per_day, :price_per_km
    alias_method :id, :car_id

    DEFAULTS = {
        id: nil,
        rentals: [],
        price_per_day: nil,
        price_per_km: nil
    }

    def initialize(hash = {})
        @car_id = hash[:id] || DEFAULTS[:id]
        @rentals = hash[:rentals] || DEFAULTS[:rentals]
        @price_per_day = hash[:price_per_day] || DEFAULTS[:price_per_day]
        @price_per_km = hash[:price_per_km] || DEFAULTS[:price_per_km]
        valid?
    end

    private
    def car_id_valid?
        raise StandardError.new('missing id') if car_id.nil?
        raise StandardError.new('id must be positive') if car_id < 0
    end

    def price_per_day_valid?
        raise StandardError.new('missing price_per_day') if price_per_day.nil?
        raise StandardError.new('price_per_day must be positive') if price_per_day and price_per_day < 0
    end

    def price_per_km_valid?
        raise StandardError.new('missing price_per_km') if price_per_km.nil?
        raise StandardError.new('price_per_km must be positive') if price_per_km and price_per_km < 0
    end
end