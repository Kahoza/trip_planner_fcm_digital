require 'rspec'
require 'rails_helper'

require_relative '../../app/services/trip_service'

RSpec.describe TripService do
  let(:file_path) { Rails.root.join('spec/fixtures/sample_trip.txt') }
  let(:base_city) { 'SVQ' }
  let(:trip_service) { TripService.new(file_path, base_city) }

  describe '#parse_file' do
    context 'when the line starts with RESERVATION' do
      it 'skips it' do
        trip_service.send(:parse_file)
        segments = trip_service.instance_variable_get(:@segments)
        expect(segments).not_to include(nil)
      end
    end
    context 'when the line starts with SEGMENT' do
      it 'parses the file and loads the segments' do
        trip_service.send(:parse_file)
        segments = trip_service.instance_variable_get(:@segments)
        expect(segments.size).to eq(8)
        expect(segments.first[:type]).to eq("Hotel")
        expect(segments.last[:type]).to eq("Hotel")
      end
    end
  end

  describe '#parse_segment' do
    context 'when the segment to parse is Flight' do
      it 'parses the segment' do
        line = 'SEGMENT: Flight SVQ 2023-03-02 06:40 -> BCN 09:10'
        segment = trip_service.send(:parse_segment, line)
        expect(segment).to eq({
          type: "Flight",
          origin: "SVQ",
          date: "2023-03-02",
          departure_time: "06:40",
          destination: "BCN",
          arrival_time: "09:10"
        })
      end
    end

    context 'when the segment to parse is Train' do
      it 'parses the segment' do
        line = 'SEGMENT: Train SVQ 2023-02-15 09:30 -> MAD 11:00'
        segment = trip_service.send(:parse_segment, line)
        expect(segment).to eq({
          type: "Train",
          origin: "SVQ",
          date: "2023-02-15",
          departure_time: "09:30",
          destination: "MAD",
          arrival_time: "11:00"
        })
      end
    end
    context 'when the segment to parse is Hotel' do
      it 'parses the segment' do
        line = 'SEGMENT: Hotel MAD 2023-02-15 -> 2023-02-17'
        segment = trip_service.send(:parse_segment, line)
        expect(segment).to eq({
          type: "Hotel",
          destination: "MAD",
          arrival_date: "2023-02-15",
          departure_date: "2023-02-17"
        })
      end
    end

    context 'when the segment to parse is unknown' do
      it 'returns nil' do
        line = 'SEGMENT: Ferry Valencia 2023-08-09 09:30 -> IBZ 13:00'
         expect {
          segment = trip_service.send(:parse_segment, line)
          expect(segment).to be_nil
        }.to output("Unknown segment type in line: SEGMENT: Ferry Valencia 2023-08-09 09:30 -> IBZ 13:00\n").to_stdout
      end
    end
  end

  describe '#group_segments_into_trips' do
    before do
      trip_service.process_trips
    end

    context 'when there are connecting flights' do
      it 'adds them to the trips array' do
        connecting_flight = {
          destination: "NYC",
          flights: [
            { type: "Flight", origin: "SVQ", date: "2023-03-02", departure_time: "06:40", destination: "BCN", arrival_time: "09:10" },
            { type: "Flight", origin: "BCN", date: "2023-03-02", departure_time: "15:00", destination: "NYC", arrival_time: "22:45" }
          ],
          trains: [],
          hotels: [],
          start_date: "2023-03-02",
          end_date: "2023-03-02"
        }
        allow(ConnectingFlightsService).to receive(:handle).and_return(connecting_flight)
        trips = trip_service.send(:group_segments_into_trips)
        expect(trips).to include(connecting_flight)
      end
    end
    it 'groups flights, trains, and hotels into trips' do
      trips = trip_service.send(:group_segments_into_trips)
      expect(trips).not_to be_empty
      expect(trips.size).to eq(2)

      first_trip = trips.first
      expect(first_trip[:destination]).to eq("BCN")
      expect(first_trip[:flights].size).to eq(2)
      expect(first_trip[:trains].size).to eq(0)
      expect(first_trip[:hotels].size).to eq(1)

      last_trip = trips.last
      expect(last_trip[:destination]).to eq("MAD")
      expect(last_trip[:flights].size).to eq(0)
      expect(last_trip[:trains].size).to eq(2)
      expect(last_trip[:hotels].size).to eq(1)
    end
  end
end
