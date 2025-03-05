require 'rspec'
require_relative '../../app/services/flight_service'

RSpec.describe FlightService do
  describe '.parse' do
    context 'when the line contains a valid flight segment' do
      let(:line) { 'SEGMENT: Flight BCN 2023-03-02 15:00 -> NYC 22:45' }

      it 'parses the hotel segment correctly' do
        result = FlightService.parse(line)
        expect(result).to eq({
          type: 'Flight',
          origin: 'BCN',
          date: '2023-03-02',
          destination: 'NYC',
          departure_time: '15:00',
          arrival_time: '22:45'
        })
      end
    end

    context 'when the line does not contain a valid hotel segment' do
      let(:line) { 'SEGMENT: Invalid segment' }

      it 'returns nil' do
        expect {
          result = FlightService.parse(line)
          expect(result).to be_nil
        }.to output("Invalid segment format: SEGMENT: Invalid segment\n").to_stdout
      end
    end
  end
end
