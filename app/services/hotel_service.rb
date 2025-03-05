class HotelService
  def self.parse(line)
    match = line.split(" ")
    if match.size == 6 && match[0] == "SEGMENT:" && match[1] == "Hotel"
      {
        type: "Hotel",
        destination: match[2],
        arrival_date: match[3],
        departure_date: match[5]
      }
    else
      puts "Invalid segment format: #{line}"
      nil
    end
  end
end
