class TripService
  def initialize(file_path, base_city)
    @file_path = file_path
    @base_city = base_city
    @segments = []
    @mismatched_segments = []
  end

  def process_trips
    parse_file
    trips = group_segments_into_trips
    TripFormatterService.format_trips(trips, @mismatched_segments)
  end

  private

  def parse_file
    File.readlines(@file_path).each do |line|
      next if line.start_with?("RESERVATION")
      if line.start_with?("SEGMENT:")
        segment = parse_segment(line)
        if segment.nil?
          puts "Skipping segment: #{line.inspect}"
        else
          @segments << segment
        end
      end
    end
  end

  def parse_segment(line)
    case line
    when /SEGMENT:\s+Flight/
      FlightService.parse(line)
    when /SEGMENT:\s+Train/
      TrainService.parse(line)
    when /SEGMENT:\s+Hotel/
      HotelService.parse(line)
    else
      puts "Unknown segment type in line: #{line}"
      nil
    end
  end

  def group_segments_into_trips
    trips = []

    connecting_flight = ConnectingFlightsService.handle(@segments)
    trips << connecting_flight if connecting_flight

    @segments.each do |segment|
      case segment[:type]
      when "Flight", "Train"
        process_transport_segment(segment, trips)
      when "Hotel"
        process_accommodation_segment(segment, trips)
      end
    end
    trips.sort_by! { |trip| trip[:start_date] }
  end

  def process_transport_segment(segment, trips)
    matching_trip = MatchingTripService.check_by_transport(trips, segment)
    if !matching_trip
      if (segment[:origin] != @base_city) && (segment[:destination] != @base_city)
        @mismatched_segments << segment
      else
        current_trip = {
          destination: segment[:destination],
          flights: [],
          trains: [],
          hotels: [],
          start_date: segment[:date],
          end_date: segment[:date]
        }
        current_trip[:flights] << segment if segment[:type] == "Flight"
        current_trip[:trains] << segment if segment[:type] == "Train"
        trips << current_trip
      end
    else
      current_trip = matching_trip
      current_trip[:flights] << segment if segment[:type] == "Flight"
      current_trip[:trains] << segment if segment[:type] == "Train"
    end
  end

  def process_accommodation_segment(segment, trips)
    matching_trip = MatchingTripService.check_by_accommodation(trips, segment)

    if matching_trip
      matching_trip[:hotels] << segment
    else
      trips << {
        destination: segment[:destination],
        flights: [],
        trains: [],
        hotels: [ segment ],
        start_date: segment[:arrival_date],
        end_date: segment[:departure_date]
      }
    end
  end
end
