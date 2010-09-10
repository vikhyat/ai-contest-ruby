require './planetwars.rb'

def naive_strategy(pw)
  # don't do anything if any of the following is true:
  # (1) we have more than three fleets in flight
  # (2) we don't have any planets left
  # (3) we have captured every planet
  return if pw.my_fleets.length >= 3
  return if pw.my_planets.length == 0
  return if pw.not_my_planets.length == 0
  
  # get a list of planets owned by me, sorted from weakest to strongest
  my_planets = pw.my_planets.sort_by {|x| x.num_ships }
  # get a list of planets that aren't mine, from strongest to weakest
  other_planets = pw.not_my_planets.sort_by {|x| 1.0/(1+x.num_ships) }

  # send half of the ships from my weakest planet to my strongest one
  source = my_planets[-1].planet_id
  source_ships = my_planets[-1].num_ships
  dest = other_planets[-1].planet_id
  if source >= 0 and dest >= 0 
    num_ships = source_ships / 2
    pw.issue_order(source, dest, num_ships)
  end
end

def do_turn(pw)
  naive_strategy(pw)
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
