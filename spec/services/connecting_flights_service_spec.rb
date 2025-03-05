require 'rspec'
require_relative '../../app/services/connecting_flights_service'

RSpec.describe ConnectingFlightsService do
  describe '.handle' do
    let(:segments) do
      [
        { type: 'Flight', origin: 'ALC', destination: 'SCQ', date: '2025-05-08', departure_time: '10:00', arrival_time: '12:00' },
        { type: 'Flight', origin: 'SCQ', destination: 'LIS', date: '2025-05-08', departure_time: '16:00', arrival_time: '17:00' },
        { type: 'Train', origin: 'BER', destination: 'MUN', date: '2025-08-02', departure_time: '09:00', arrival_time: '15:00' }
      ]
    end

    it 'builds a trip from connecting flights' do
      trip = ConnectingFlightsService.handle(segments)
      expect(trip).to eq({
        destination: 'LIS',
        flights: [
          { type: 'Flight', origin: 'ALC', destination: 'SCQ', date: '2025-05-08', departure_time: '10:00', arrival_time: '12:00' },
          { type: 'Flight', origin: 'SCQ', destination: 'LIS', date: '2025-05-08', departure_time: '16:00', arrival_time: '17:00' }
        ],
        trains: [],
        hotels: [],
        start_date: '2025-05-08',
        end_date: '2025-05-08'
      })
    end

    it 'returns nil if no connecting flights are found' do
      segments = [
        { type: 'Flight', origin: 'NYC', destination: 'LAX', date: '2025-03-01', departure_time: '10:00', arrival_time: '14:00' },
        { type: 'Train', origin: 'BER', destination: 'MUN', date: '2025-03-02', departure_time: '09:00', arrival_time: '11:00' }
      ]
      trip = ConnectingFlightsService.handle(segments)
      expect(trip).to be_nil
    end

    it 'removes connecting flights from segments' do
      ConnectingFlightsService.handle(segments)
      expect(segments).to eq([
        { type: 'Train', origin: 'BER', destination: 'MUN', date: '2025-08-02', departure_time: '09:00', arrival_time: '15:00' }
      ])
    end
  end
end
