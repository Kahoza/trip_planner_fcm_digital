require 'rspec'
require_relative '../../app/services/trip_formatter_service'

RSpec.describe TripFormatterService do
  describe '.format_trips' do
    let(:trips) do
      [
        {
          destination: 'ORY',
          flights: [
            { origin: 'BRU', destination: 'ORY', date: '2025-03-01', departure_time: '10:00', arrival_time: '13:00' },
            { origin: 'ORY', destination: 'BRU', date: '2025-03-05', departure_time: '17:00', arrival_time: '20:00' }
          ],
          trains: [],
          hotels: [
            { destination: 'ORY', arrival_date: '2025-03-01', departure_date: '2025-03-05' }
          ],
          start_date: '2025-03-01',
          end_date: '2025-03-05'
        }
      ]
    end

    let(:mismatched_segments) do
      [
        { type: 'Flight', origin: 'LHR', destination: 'BER', date: '2025-03-04' }
      ]
    end

    it 'formats trips and mismatched segments' do
      expect { TripFormatterService.format_trips(trips, mismatched_segments) }.to output(
        <<~OUTPUT
          TRIP to ORY
          Flight from BRU to ORY at 2025-03-01 10:00 to 13:00
          Flight from ORY to BRU at 2025-03-05 17:00 to 20:00
          Hotel at ORY on 2025-03-01 to 2025-03-05

          The following segments don't match the base city of the user, please review:
          Flight from LHR to BER on 2025-03-04
        OUTPUT
      ).to_stdout
    end
  end
end
