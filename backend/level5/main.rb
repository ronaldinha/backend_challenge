require "json"
require "byebug"
require "date"
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }

# your code
DATA_FILENAME = "data.json"
OUTPUT_DIRECTORY = "result"
OUTPUT_FILENAME = "output.json"

data = JSON.parse(File.read(DATA_FILENAME), { symbolize_names: true })
expected_output = JSON.parse(File.read(OUTPUT_FILENAME), { symbolize_names: true })

cars = data[:cars].map { |car| Car.new(car) }
rentals = data[:rentals].map do |rental|
    car_id = rental.delete(:car_id)
    rental[:car] = cars.select {|c| c.id >= car_id}.first
    Rental.new(rental)
end

res = { rentals: rentals }
if expected_output.to_json.eql?(res.to_json)
    File.open(File.dirname(__FILE__) + "/#{OUTPUT_DIRECTORY}/#{OUTPUT_FILENAME}", "w") { |file| file.write JSON.pretty_generate(res) }
else
    puts "So bad, the output is not the one expected!"
end