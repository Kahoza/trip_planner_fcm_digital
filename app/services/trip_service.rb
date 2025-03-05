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

      @segments << line if line.start_with?("SEGMENT:")
    end
    puts @segments
  end
end
