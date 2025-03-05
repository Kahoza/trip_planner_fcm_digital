class ConnectingFlightsService
  def self.handle(segments)
    connecting_flights = find_connecting_flights(segments)

    return nil if connecting_flights.empty?

    remove_connecting_flights_from_segments(segments, connecting_flights)

    build_trip_from_connecting_flights(connecting_flights)
  end

  private

  def self.find_connecting_flights(segments)
    segments.select { |segment| segment[:type] == "Flight" }
            .group_by { |flight| flight[:date] }
            .select { |_, flights| flights.size > 1 }
  end

  def self.remove_connecting_flights_from_segments(segments, connecting_flights)
    segments.reject! { |segment| connecting_flights.keys.include?(segment[:date]) }
  end

  def self.build_trip_from_connecting_flights(connecting_flights)
    flights = connecting_flights.values.flatten

    {
      destination: flights.last[:destination],
      flights: flights,
      trains: [],
      hotels: [],
      start_date: flights.first[:date],
      end_date: flights.first[:date]
    }
  end
end
