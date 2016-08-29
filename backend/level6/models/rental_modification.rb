require_relative "model.rb"
require_relative "constants.rb"

class RentalModification < Model
    attr_accessor :rental_modification_id, :rental, :start_date, :end_date, :distance, :actions
    alias_method :id, :rental_modification_id

    DEFAULTS = {
        id: nil,
        rental: nil,
        start_date: nil,
        end_date: nil,
        distance: nil
    }

    def initialize(hash = {})
        @rental_modification_id = hash[:id] || DEFAULTS[:id]
        @rental = Memory.find_rental(hash[:rental_id]) || DEFAULTS[:rental]
        @start_date = Date.parse(hash[:start_date]) unless hash[:start_date].nil?
        @end_date = Date.parse(hash[:end_date]) unless hash[:end_date].nil?
        @distance = hash[:distance] unless hash[:distance].nil?
        valid?
        @actions = determine_actions
    end

    def to_json(options = {})
        {
            id: id,
            rental_id: rental.id,
            actions: actions
        }.to_json(options)
    end

    private
    def determine_actions
        delta = determine_delta
        Constants::ACTOR_DEFAULTS.map do |actor, default_action|
            action_type = delta[actor].positive? ? default_action : -default_action
            {
                who: actor.to_s,
                type: Constants::ACTOR_ACTION_TYPE.key(action_type).to_s,
                amount: delta[actor].abs
            }
        end
    end

    def determine_delta
        previous_rental_actions = rental.actions
        rental.update(start_date, end_date, distance)
        new_rental_actions = rental.actions
        Constants::ACTOR_DEFAULTS.inject({}) do |acc, (actor, _)|
            previous_amount = previous_rental_actions.detect{ |action| action[:who].to_sym == actor.to_sym }.dig(:amount)
            new_amount = new_rental_actions.detect{ |action| action[:who].to_sym == actor.to_sym }.dig(:amount)
            acc[actor] = new_amount - previous_amount
            acc
        end
    end

    def rental_modification_id_valid?
        raise StandardError.new('missing id') if rental_modification_id.nil?
        raise StandardError.new('id must be positive') if rental_modification_id and rental_modification_id < 0
    end

    def rental_valid?
        raise StandardError.new('missing rental') if rental.nil?
    end

    def end_date_valid?
        raise StandardError.new('end_date must be greater than start_date') if (start_date and start_date > end_date)
    end

    def distance_valid?
        raise StandardError.new('distance must be positive') if distance and distance < 0
    end
end