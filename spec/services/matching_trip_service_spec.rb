require 'rspec'
require_relative '../../app/services/matching_trip_service'

RSpec.describe MatchingTripService do
  describe '.check_by_transport' do
    let(:trips) do
      [
        {
          destination: 'BKK',
          flights: [ { type: 'Flight', origin: 'BKK', destination: 'GOID', date: '2025-04-20' } ],
          trains: [],
          hotels: [],
          start_date: '2025-04-10',
          end_date: '2025-04-20'
        },
        {
          destination: 'BER',
          flights: [],
          trains: [],
          hotels: [],
          start_date: '2025-03-04',
          end_date: '2025-03-06'
        }
      ]
    end

    it 'finds a matching trip by destination and dates' do
      segment = { type: 'Flight', origin: 'GOI', destination: 'BKK', date: '2025-04-10' }
      matching_trip = MatchingTripService.check_by_transport(trips, segment)
      expect(matching_trip).to eq(trips[0])
    end

    it 'returns nil if no matching trip is found' do
      segment = { type: 'Flight', origin: 'SYD', destination: 'PER', date: '2025-03-07' }
      matching_trip = MatchingTripService.check_by_transport(trips, segment)
      expect(matching_trip).to be_nil
    end
  end

  describe '.check_by_accommodation' do
    let(:trips) do
      [
        {
          destination: 'FCO',
          flights: [],
          trains: [ { type: 'Train', origin: 'MXP', destination: 'FCO', date: '2025-12-01' } ],
          hotels: [],
          start_date: '2025-12-01',
          end_date: '2025-12-01'
        },
        {
          destination: 'OPO',
          flights: [],
          trains: [],
          hotels: [],
          start_date: '2025-08-04',
          end_date: '2025-08-16'
        }
      ]
    end

    it 'finds a matching trip by destination and arrival and departure dates' do
      segment = { type: 'Hotel', destination: 'FCO', arrival_date: '2025-12-01', departure_date: '2025-12-03' }
      matching_trip = MatchingTripService.check_by_accommodation(trips, segment)
      expect(matching_trip).to eq(trips[0])
    end

    it 'returns nil if no matching trip is found' do
      segment = { type: 'Hotel', destination: 'BRI', arrival_date: '2025-10-09', departure_date: '2025-03-08' }
      matching_trip = MatchingTripService.check_by_accommodation(trips, segment)
      expect(matching_trip).to be_nil
    end
  end
end
