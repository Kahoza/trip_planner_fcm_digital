require 'rspec'
require_relative '../../app/services/hotel_service'

RSpec.describe HotelService do
  describe '.parse' do
    context 'when the line contains a valid hotel segment' do
      let(:line) { 'SEGMENT: Hotel BCN 2023-01-05 to 2023-01-10' }

      it 'parses the hotel segment correctly' do
        result = HotelService.parse(line)
        expect(result).to eq({
          type: 'Hotel',
          destination: 'BCN',
          arrival_date: '2023-01-05',
          departure_date: '2023-01-10'
        })
      end
    end

    context 'when the line does not contain a valid hotel segment' do
      let(:line) { 'SEGMENT: Invalid segment' }

      it 'returns nil' do
        expect {
          result = HotelService.parse(line)
          expect(result).to be_nil
        }.to output("Invalid segment format: SEGMENT: Invalid segment\n").to_stdout
      end
    end
  end
end
