require "json"
require "byebug"
require "date"
require "active_support/inflector"
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/memory/*.rb'].each {|file| require file }

# your code
DATA_FILENAME = "data.json"
OUTPUT_DIRECTORY = "result"
OUTPUT_FILENAME = "output.json"

data = JSON.parse(File.read(DATA_FILENAME), { symbolize_names: true })
expected_output = JSON.parse(File.read(OUTPUT_FILENAME), { symbolize_names: true })

resources = [:cars, :rentals, :rental_modifications]
resources.each do |resource|
    begin
        resource_data = data[resource].map { |params| resource.to_s.classify.constantize.new(params) }
    rescue => e
        puts "An error occured while extracting #{resource} data : #{e.message}"
        exit
    end
    Memory.send("#{resource}=", resource_data)
end

res = { rental_modifications: Memory.rental_modifications }
if expected_output.to_json.eql?(res.to_json)
    File.open(File.dirname(__FILE__) + "/#{OUTPUT_DIRECTORY}/#{OUTPUT_FILENAME}", "w") { |file| file.write JSON.pretty_generate(res) }
    puts "Yay! You did it!"
else
    puts "So bad, the output is not the one expected!"
end