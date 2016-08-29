class Memory
    @@cars = []
    @@rentals = []
    @@rental_modifications = []

    class << self
        attr_accessor :cars, :rentals, :rental_modifications

        def find_car(id)
            raise StandardError.new("invalid car id") unless id.positive?
            self.cars.detect { |car| car.id == id }
        end

        def find_rental(id)
            raise StandardError.new("invalid rental id") unless id.positive?
            rentals.detect { |rental| rental.id == id }
        end
    end
end