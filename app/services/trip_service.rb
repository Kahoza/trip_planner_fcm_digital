class TripService
  def initialize(file_path, base_city)
    @file_path = file_path
    @base_city = base_city
    @segments = []
  end

  def process_trips
    parse_file
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
    puts @segments
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
end
