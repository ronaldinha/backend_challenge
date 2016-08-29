require_relative "model.rb"
require_relative "constants.rb"

class Rental < Model
    attr_accessor :rental_id, :car, :start_date, :end_date, :distance, :has_deductible_reduction , :actions
    alias_method :id, :rental_id

    DEFAULTS = {
        id: nil,
        car: nil,
        start_date: nil,
        end_date: nil,
        distance: nil
    }

    def initialize(hash = {})
        @rental_id = hash[:id] || DEFAULTS[:id]
        @car = Memory.find_car(hash[:car_id]) || DEFAULTS[:car]
        @start_date = Date.parse(hash[:start_date] || DEFAULTS[:start_date])
        @end_date = Date.parse(hash[:end_date] || DEFAULTS[:end_date])
        @distance = hash[:distance] || DEFAULTS[:distance]
        @has_deductible_reduction = !!hash[:deductible_reduction]
        valid?
        determine_actions
    end

    def update(start_date = nil, end_date = nil, distance = nil)
        self.start_date = start_date unless start_date.nil?
        self.end_date = end_date unless end_date.nil?
        self.distance = distance unless distance.nil?
        valid?
        determine_actions
    end

    def price
        safe_to_i(time_component + distance_component)
    end

    def insurance_fee
        safe_to_i(commission * Constants::INSURANCE_COMISSION_RATE)
    end

    def assistance_fee
        safe_to_i(Constants::ROADSIDE_PRICE_PER_DAY * duration)
    end

    def drivy_fee
        safe_to_i(commission - insurance_fee - assistance_fee + deductible_reduction)
    end

    def driver_fee
        safe_to_i(price + deductible_reduction)
    end

    def owner_fee
        safe_to_i(price - commission)
    end

    def to_json(options = {})
        {
            id: id,
            actions: actions
        }.to_json(options)
    end

    private
    def determine_actions
        self.actions = Constants::ACTOR_DEFAULTS.map do |actor, default_action|
            amount = send("#{actor}_fee")
            type = amount.positive? ? default_action : -default_action
            { who: actor.to_s, type: Constants::ACTOR_ACTION_TYPE.key(type).to_s, amount: amount }
        end
    end

    def commission
        price * Constants::COMMISION_RATE
    end

    def deductible_reduction
        has_deductible_reduction ? Constants::DEDUCTIBLE_CHARGE_PER_DAY * duration : 0
    end

    def duration
        end_date.mjd - start_date.mjd + 1 # shold include the first day
    end

    def time_component
        j = duration > 0 ? 1 : 0
        k = duration > 1 ? [duration - 1, 3].min : 0 # interval wanted = [1,2,3]
        m = duration > 4 ? [duration - 4, 6].min : 0 # interval wanted = [1,2,3,4,5,6]
        n = duration > 10 ? duration - 10 : 0
        result = car.price_per_day * (Constants::DISCOUNTS['10'] * n + Constants::DISCOUNTS['4'] * m + Constants::DISCOUNTS['1'] * k + j)
        safe_to_i(result) # must be done to avoid float accuracy errors on float to int conversion
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