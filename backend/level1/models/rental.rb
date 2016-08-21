require_relative "model.rb"

class Rental < Model
    attr_accessor :rental_id, :user, :car, :start_date, :end_date, :distance
    alias_method :id, :rental_id

    DEFAULTS = {
        id: nil,
        user: nil,
        car: nil,
        start_date: nil,
        end_date: nil,
        distance: nil
    }

    def initialize(hash = {})
        # write a validate method for parameter that will use each attribute validate method
        @rental_id = hash[:id] || DEFAULTS[:id]
        @user = hash[:user] || DEFAULTS[:user]
        @car = hash[:car] || DEFAULTS[:car]
        @start_date = Date.parse(hash[:start_date] || DEFAULTS[:start_date])
        @end_date = Date.parse(hash[:end_date] || DEFAULTS[:end_date])
        @distance = hash[:distance] || DEFAULTS[:distance]
        raise unless valid?
    end

    def price
        time_component + distance_component
    end

    def to_json(options = {})
        { id: id, price: price }.to_json(options)
    end

    private
    def duration
        end_date.mjd - start_date.mjd + 1 # shold include the first day
    end

    def time_component
        duration * car.price_per_day
    end

    def distance_component
        distance * car.price_per_km
    end

    def rental_id_valid?
        raise StandardError.new('missing id') if id.nil?
    end

    def car_valid?
        raise StandardError.new('missing car') if car.nil?
    end

    def start_date_valid?
        raise StandardError.new('missing start_date') if start_date.nil?
    end

    def end_date_valid?
        raise StandardError.new('missing end_date') if end_date.nil?
    end

    def distance_valid?
        raise StandardError.new('missing distance') if distance.nil?
    end
end