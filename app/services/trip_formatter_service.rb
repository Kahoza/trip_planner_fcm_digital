class TripFormatterService
  def self.format_trips(trips, mismatched_segments)
    trips.each do |trip|
      puts "TRIP to #{trip[:destination]}"
      format_flights(trip[:flights])
      format_trains(trip[:trains])
      format_hotels(trip[:hotels])
      puts "\n"
    end

    format_mismatched_segments(mismatched_segments) unless mismatched_segments.empty?
  end

  private

  def self.format_flights(flights)
    flights.each do |flight|
      puts "Flight from #{flight[:origin]} to #{flight[:destination]} at #{flight[:date]} #{flight[:departure_time]} to #{flight[:arrival_time]}"
    end
  end

  def self.format_trains(trains)
    trains.each do |train|
      puts "Train from #{train[:origin]} to #{train[:destination]} at #{train[:date]} #{train[:departure_time]} to #{train[:arrival_time]}"
    end
  end

  def self.format_hotels(hotels)
    hotels.each do |hotel|
      puts "Hotel at #{hotel[:destination]} on #{hotel[:arrival_date]} to #{hotel[:departure_date]}"
    end
  end

  def self.format_mismatched_segments(mismatched_segments)
    puts "The following segments don't match the base city of the user, please review:"
    mismatched_segments.each do |segment|
      puts "#{segment[:type]} from #{segment[:origin]} to #{segment[:destination]} on #{segment[:date]}"
    end
  end
end
