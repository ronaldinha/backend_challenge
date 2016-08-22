require_relative "model.rb"

class User < Model
    attr_accessor :user_id, :bookings, :cars
    alias_method :id, :user_id

    DEFAULTS = {
        id: nil,
        bookings: [],
        cars: []
    }

    def initialize(id = nil, bookings = [], cars = [])
        @user_id = hash[:id] || DEFAULTS[:id]
        @bookings = hash[:bookings] || DEFAULTS[:bookings]
        @cars = hash[:cars] || DEFAULTS[:cars]
        raise unless valid?
    end

    private
    def user_id_valid?
        raise StandardError.new('missing id') if user_id.nil?
        raise StandardError.new('id must be positive') if user_id < 0
    end
end