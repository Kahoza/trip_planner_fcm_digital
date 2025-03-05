class FlightService
  def self.parse(line)
    match = line.split(" ")
    if match.size == 8 && match[0] == "SEGMENT:" && match[1] == "Flight"
      {
        type: "Flight",
        origin: match[2],
        date: match[3],
        departure_time: match[4],
        destination: match[6],
        arrival_time: match[7]
      }
    else
      puts "Invalid segment format: #{line}"
      nil
    end
  end
end
