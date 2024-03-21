require 'pry'

class Game
    attr_reader :grid_size, 
                :total_ships, 
                :player1_ships, 
                :player2_ships, 
                :total_missiles, 
                :player1_moves, 
                :player2_moves
  
    def initialize(file_path)
      read_input(file_path)
      @player1_grid = initialize_grid(@grid_size)
      @player2_grid = initialize_grid(@grid_size)
      place_ships(@player1_grid, @player1_ships)
      place_ships(@player2_grid, @player2_ships)
    end
  
    def play_game
      execute_moves(@player1_grid, @player2_moves)
      execute_moves(@player2_grid, @player1_moves)
      write_output
    end
  
    private
  
    def read_input(file_path)
      File.foreach(file_path).with_index do |line, index|
        case index
        when 0
          @grid_size = line.to_i
        when 1
          @total_ships = line.to_i
        when 2
          @player1_ships = parse_ship_positions(line)
        when 3
          @player2_ships = parse_ship_positions(line)
        when 4
          @total_missiles = line.to_i
        when 5
          @player1_moves = parse_moves(line)
        when 6
          @player2_moves = parse_moves(line)
        end
      end
    end
  
    def parse_ship_positions(line)
      line.chomp.split(':').map { |pair| pair.split(',').map(&:to_i) }
    end
  
    def parse_moves(line)
      line.chomp.split(':').map { |pair| pair.split(',').map(&:to_i) }
    end
  
    def initialize_grid(size)
      Array.new(size) { Array.new(size, '_') }
    end
  
    def place_ships(grid, ships)
        ships.each do |(x,y)| 
            grid[x][y] = 'B'
        end
    end
  
    def execute_moves(grid, moves)
      moves.each { |move| process_move(grid, move) }
    end
  
    def process_move(grid, move)
        x, y = move
        if x && y && grid[x] && grid[x][y]
          if grid[x][y] == 'B'
            grid[x][y] = 'X'
          else
            grid[x][y] = 'O'
          end
        else
          puts "Invalid move: #{move}"
        end
    end
      
  
    def write_output
      File.open('output.txt', 'w') do |file|
        file.puts "Player1"
        @player1_grid.each { |row| file.puts row.join(' ') }
        file.puts "Player2"
        @player2_grid.each { |row| file.puts row.join(' ') }
        file.puts "P1: #{count_hits(@player1_grid)}, P2: #{count_hits(@player2_grid)}"
        file.puts determine_winner
      end
    end
  
    def count_hits(grid)
      grid.flatten.count('X')
    end
  
    def determine_winner
      p1_hits = count_hits(@player1_grid)
      p2_hits = count_hits(@player2_grid)
      if p1_hits > p2_hits
        "Player 1 wins"
      elsif p1_hits < p2_hits
        "Player 2 wins"
      else
        "It is a draw"
      end
    end
end