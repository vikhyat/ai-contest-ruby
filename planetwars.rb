class Fleet
  attr_reader :owner, :num_ships, :source_planet, 
    :destination_planet, :total_trip_length, :turns_remaining
 
   def initialize(owner, num_ships, source_planet, 
                 destination_planet, total_trip_length, 
                 turns_remaining)
    @owner, @num_ships = owner, num_ships
    @source_planet = source_planet
    @destination_planet = destination_planet
    @total_trip_length = total_trip_length
    @turns_remaining = turns_remaining
  end
end

class Planet
  attr_reader :planet_id, :growth_rate, :x, :y
  attr_accessor :owner, :num_ships

  def initialize(planet_id, owner, num_ships, growth_rate, x, y)
    @planet_id, @owner, @num_ships = planet_id, owner, num_ships
    @growth_rate, @x, @y = growth_rate, x, y
  end

  def add_ships(n)
    @num_ships += amt
  end

  def remove_ships(n)
    @num_ships -= n
  end
end

class PlanetWars
  attr_reader :planets, :fleets
  def initialize(game_state)
    parse_game_state(game_state)
  end

  def num_planets
    @planets.length
  end

  def get_planet(id)
    @planets[id]
  end

  def num_fleets
    @fleets.length
  end

  def get_fleet(id)
    @fleets[id]
  end

  def my_planets
    @planets.select {|planet| planet.owner == 1 }
  end

  def neutral_planets
    @planets.select {|planet| planet.owner == 0 }
  end

  def enemy_planets
    @planets.select {|planet| planet.owner > 1 }
  end

  def not_my_planets
    @planets.reject {|planet| planet.owner == 1 }
  end

  def my_fleets
    @fleets.select {|fleet| fleet.owner == 1 }
  end

  def enemy_fleets
    @fleets.select {|fleet| fleet.owner > 1 }
  end

  def to_s
    s = []
    @planets.each do |p|
      s << "P #{p.x} #{p.y} #{p.owner} #{p.num_ships} #{p.growth_rate}"
    end
    @fleets.each do |f|
      s << "F #{f.owner} #{f.num_ships} #{f.source_planet} #{f.destination_planet} #{f.total_trip_length} #{f.turns_remaining}"
    end
    return s.join("\n")
  end

  def distance(source_id, destination_id)
    source = get_planet(source_id)
    destination = get_planet(destination_id)
    return Math::sqrt( (source.x - destination.x)**2 + (source.y - destination.y)**2 )
  end

  def issue_order(source, destination, num_ships)
    puts "#{source} #{destination} #{num_ships}"
    STDOUT.flush
  end

  def is_alive(player_id)
    if (@planets.select{|p| p.owner == player_id }).length > 0
      return true
    elsif (@fleets.select{|p| p.owner == player_id }).length > 0
      return true
    else
      return false
    end
  end

  def parse_game_state(s)
    @planets = []
    @fleets = []
    lines = s.split("\n")
    planet_id = 0

    lines.each do |line|
      p line
      line = line.split("#")[0]
      tokens = line.split(" ")
      next if tokens.length == 1
      if tokens[0] == "P"
        return 0 if tokens.length != 6
        p = Planet.new(planet_id,
                       tokens[3].to_i, # owner
                       tokens[4].to_i, # num_ships
                       tokens[5].to_i, # growth_rate
                       tokens[1].to_f, # x
                       tokens[2].to_f) # y
        planet_id += 1
        @planets << p
      elsif tokens[0] == "F"
        return 0 if tokens.length != 7
        f = Fleet.new(tokens[1].to_i, # owner
                      tokens[2].to_i, # num_ships
                      tokens[3].to_i, # source
                      tokens[4].to_i, # destination
                      tokens[5].to_i, # total_trip_length
                      tokens[6].to_i) # turns_remaining
        @fleets << f
      else
        return 0
      end
    end
    return 1
  end

  def finish_turn
    puts "go"
    STDOUT.flush
  end
end
