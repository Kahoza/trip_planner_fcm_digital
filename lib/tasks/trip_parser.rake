namespace :trip do
  desc "Parse user itinerary and generate trip details"
  task :parser, [ :file ] => :environment do |t, args|
    file_path = args[:file] || "input.txt"
    base_city = ENV["BASED"]

    unless File.exist?(file_path)
      puts "The input file #{file_path} does not exist."
      exit(1)
    end

    if ENV["BASED"].nil? || ENV["BASED"].strip.empty?
      puts "Please provide the city where the user is based on, for example"
      puts "  BASED=SVQ bundle exec ruby main.rb input.txt"
      exit(1)
    end

    TripService.new(file_path, base_city).process_trips
  end
end
