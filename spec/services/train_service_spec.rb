require 'rspec'
require_relative '../../app/services/train_service'

RSpec.describe TrainService do
  describe '.parse' do
    context 'when the line contains a valid train segment' do
      let(:line) { 'SEGMENT: Train SVQ 2023-02-15 09:30 -> MAD 11:00' }

      it 'parses the hotel segment correctly' do
        result = TrainService.parse(line)
        expect(result).to eq({
          type: 'Train',
          origin: 'SVQ',
          date: '2023-02-15',
          destination: 'MAD',
          departure_time: '09:30',
          arrival_time: '11:00'
        })
      end
    end

    context 'when the line does not contain a valid hotel segment' do
      let(:line) { 'SEGMENT: Invalid segment' }

      it 'returns nil' do
        expect {
          result = TrainService.parse(line)
          expect(result).to be_nil
        }.to output("Invalid segment format: SEGMENT: Invalid segment\n").to_stdout
      end
    end
  end
end
