class MatchingTripService
  def self.check_by_transport(trips, segment)
    trips.find do |trip|
      (trip[:destination] == (segment[:destination]) || (trip[:destination] == segment[:origin])) ||
        (trip[:start_date] == segment[:date]) || (trip[:end_date] == segment[:date])
    end
  end

    def self.check_by_accommodation(trips, segment)
      trips.find do |trip|
        trip[:destination] == segment[:destination] &&
        (trip[:start_date] <= segment[:arrival_date] || trip[:end_date] >= segment[:departure_date])
      end
    end
end
