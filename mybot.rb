require './planetwars.rb'

def do_turn(pw)
  # (1) don't do anything if we have a fleet in flight
  return if pw.my_fleets.length >= 1

  # (2) find my strongest planet
  source = -1
  source_score = -999999.0
  source_num_ships = 0
  pw.my_planets.each do |planet|
    score = planet.num_ships.to_f
    if score > source_score
      source_score = score
      source = planet.planet_id
      source_num_ships = planet.num_ships
    end
  end

  # (3) find the weakest planet belonging that isn't mine
  dest = -1
  dest_score = -999999.0
  pw.not_my_planets.each do |p|
    score = 1.0 / (1 + p.num_ships)
    if score > dest_score
      dest_score = score
      dest = p.planet_id
    end
  end

  # (4) send half of the ships from my strongest planet to the weakest one that i do not own
  if source >= 0 and dest >= 0
    num_ships = source_num_ships / 2
    pw.issue_order(source, dest, num_ships)
  end
end

map_data = ''
loop do
  current_line = gets.strip rescue break
  if current_line.length >= 2 and current_line[0..1] == "go"
    pw = PlanetWars.new(map_data)
    do_turn(pw)
    pw.finish_turn
    map_data = ''
  else
    map_data += current_line + "\n"
  end
end
