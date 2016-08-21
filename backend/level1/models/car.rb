require_relative "model.rb"

class Car < Model
    attr_accessor :car_id, :user, :rentals, :price_per_day, :price_per_km
    alias_method :owner, :user
    alias_method :owner=, :user=
    alias_method :id, :car_id

    DEFAULTS = {
        id: nil,
        user: nil,
        rentals: [],
        price_per_day: nil,
        price_per_km: nil
    }

    def initialize(hash = {})
        @car_id = hash[:id] || DEFAULTS[:id]
        @user = hash[:user] || DEFAULTS[:user]
        @rentals = hash[:rentals] || DEFAULTS[:rentals]
        @price_per_day = hash[:price_per_day] || DEFAULTS[:price_per_day]
        @price_per_km = hash[:price_per_km] || DEFAULTS[:price_per_km]
        raise unless valid?
    end

    private
    def car_id_valid?
        raise StandardError.new('missing id') if car_id.nil?
    end

    def price_per_day_valid?
        raise StandardError.new('missing price_per_day') if price_per_day.nil?
    end

    def price_per_km_valid?
        raise StandardError.new('missing price_per_km') if price_per_km.nil?
    end
end