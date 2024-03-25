#!/usr/bin/env ruby
require_relative './lib/game'

begin
game  = Game.new(ARGV[0])

rescue StandardError => e
    puts "Initialization failed: #{e.message}"
    exit(1)
end

#Run the game
game.play_game
