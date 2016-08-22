require_relative "model.rb"

class Rental < Model
    attr_accessor :rental_id, :user, :car, :start_date, :end_date, :distance, :deductible_reduction
    alias_method :id, :rental_id

    DEFAULTS = {
        id: nil,
        user: nil,
        car: nil,
        start_date: nil,
        end_date: nil,
        distance: nil
    }
    DISCOUNTS = {
        '1'     => 0.9,
        '4'     => 0.7,
        '10'    => 0.5
    }
    COMMISION_RATE = 0.3
    INSURANCE_COMISSION_RATE = 0.5
    ROADSIDE_PRICE_PER_DAY = 1 * 100 # PRICES ARE IN CENTS
    DEDUCTIBLE = 800 * 100
    DEDUCTIBLE_CHARGE_PER_DAY = 4 * 100

    def initialize(hash = {})
        @rental_id = hash[:id] || DEFAULTS[:id]
        @user = hash[:user] || DEFAULTS[:user]
        @car = hash[:car] || DEFAULTS[:car]
        @start_date = Date.parse(hash[:start_date] || DEFAULTS[:start_date])
        @end_date = Date.parse(hash[:end_date] || DEFAULTS[:end_date])
        @distance = hash[:distance] || DEFAULTS[:distance]
        valid?
        @deductible_reduction = hash[:deductible_reduction] ? DEDUCTIBLE_CHARGE_PER_DAY * duration : 0
    end

    def price
        time_component + distance_component
    end

    def insurance_fee
        (commission * INSURANCE_COMISSION_RATE + 0.5).to_i
    end

    def assistance_fee
        ROADSIDE_PRICE_PER_DAY * duration
    end

    def drivy_fee
        (commission - insurance_fee - assistance_fee + 0.5).to_i
    end

    def to_json(options = {})
        {
            id: id,
            price: price,
            options: {
                deductible_reduction: deductible_reduction
            },
            commission: {
                insurance_fee: insurance_fee,
                assistance_fee: assistance_fee,
                drivy_fee: drivy_fee
            }
        }.to_json(options)
    end

    private
    def calc_deductible_reduction
        duration * DEDUCTIBLE_ADDITIONAL_CHARGE_PER_DAY
    end

    def commission
        price * COMMISION_RATE
    end

    def duration
        end_date.mjd - start_date.mjd + 1 # shold include the first day
    end

    def time_component
        j = duration > 0 ? 1 : 0
        k = duration > 1 ? [duration - 1, 3].min : 0 # interval wanted = [1,2,3]
        m = duration > 4 ? [duration - 4, 6].min : 0 # interval wanted = [1,2,3,4,5,6]
        n = duration > 10 ? duration - 10 : 0
        result = car.price_per_day * (DISCOUNTS['10'] * n + DISCOUNTS['4'] * m + DISCOUNTS['1'] * k + j)
        (result + 0.5).to_i # must be done to avoid float accuracy errors on float to int conversion
    end

    def distance_component
        distance * car.price_per_km
    end

    def rental_id_valid?
        raise StandardError.new('missing id') if rental_id.nil?
        raise StandardError.new('id must be positive') if rental_id and rental_id < 0
    end

    def car_valid?
        raise StandardError.new('missing car') if car.nil?
    end

    def start_date_valid?
        raise StandardError.new('missing start_date') if start_date.nil?
    end

    def end_date_valid?
        raise StandardError.new('missing end_date') if end_date.nil?
        raise StandardError.new('end_date must be greater than start_date') if (start_date and start_date > end_date)
    end

    def distance_valid?
        raise StandardError.new('missing distance') if distance.nil?
        raise StandardError.new('distance must be positive') if distance and distance < 0
    end
end