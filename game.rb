#!/usr/bin/env ruby
require_relative './lib/game'

raise StandardError, "Invalid file path: #{ARGV[0]}" unless File.exist?(ARGV[0])


game  = Game.new(ARGV[0])
game.play_game