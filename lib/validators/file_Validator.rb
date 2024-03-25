require 'byebug'
require_relative '../patch/string_patch'

module Validators
    module FileValidator
        class FileError < StandardError; end
        class FileFormatError < StandardError; end

        ALLOWED_GRID_SIZE = 1..10
        SHIP_COORDINATES_SIZE = 2
        TOTAL_ALLOWED_MISSILES = 1..100

        def valid?(file)
            raise FileError, "Please provide the path to your input file" if file.nil? || file.empty?
            raise FileError, "File does not exist at the path" unless File.exists? file
            raise FileError, "File is empty" if File.empty? file

            true
        end

        def valid_input?(grid_size, 
                        total_ships,
                        player1_ships, 
                        player2_ships, 
                        total_missiles,
                        player1_moves, 
                        player2_moves)
            
            # Validate Grid size if it is valid number and lies within limit
            raise FileFormatError, "Please pass numeric grid size for battleship" unless valid_grid_size(grid_size)
            
            #Validate Ship size if is valid number
            raise FileFormatError, "Total ships must be number" unless total_ships.is_a?(Numeric)

            #Vaildate ship size lies within limiit
            is_valid_number_of_ships, max_ships = valid_number_of_ships?(total_ships)
            raise StandardError, "Number of ships exceeds the maximum allowed (#{total_ships} > #{max_ships})" unless is_valid_number_of_ships

            #validate ship positions on Grid for both players
            do_validate_positions(grid_size, total_ships, player1_ships, player: 'player1', element_type:'ship')
            do_validate_positions(grid_size, total_ships, player2_ships, player: 'player2', element_type:'ship')

            #Validate total missiles if it is valid number
            raise FileFormatError, "Please enter correct number of missiles i.e. between #{TOTAL_ALLOWED_MISSILES}" unless validate_total_missiles(total_missiles)

            #Vaildate moves and their coordiantes for both players
            do_validate_positions(grid_size, total_missiles, player1_moves, player: 'player1', element_type: 'move')
            do_validate_positions(grid_size, total_missiles, player1_moves, player: 'player2', element_type: 'move')
            true

        end

        private

        def pluralize(word, count)
            count == 1 ? word : word + 's'
        end          

        def max_ships(grid_size)
            (grid_size ** 2) / 2
        end

        def valid_grid_size(grid_size)
            grid_size.is_a?(Numeric) && ALLOWED_GRID_SIZE.include?(grid_size)
        end       

        def all_numbers?(array)
            array.flatten.all? { |element| element.is_a?(Numeric) }
        end

        def array_of_size_n?(array, n)
            return unless array.size === n
            array.all? { |inner_array| inner_array.is_a?(Array) && inner_array.size == SHIP_COORDINATES_SIZE }
        end

        def vaildate_element_coordinates?(positions, grid)
            positions.all? {|position| position.all? {|coordinate| coordinate <= grid  }}
        end

        def valid_number_of_ships?(total_ships)
            allowed_ships = max_ships(grid_size)

            return total_ships <= allowed_ships, allowed_ships
        end 

        def do_validate_positions(grid_size,total_elements, element_positions, player:, element_type: )
            raise FileFormatError, "Please input the positions of #{element_type.pluralize} on the grid for player:#{player}." if element_positions.nil? || element_positions.empty?
            raise FileFormatError, "Entered wrong number of #{element_type} positions for player:#{player}" unless array_of_size_n?(element_positions, total_elements)
            raise FileFormatError, "Entered wrong positions for #{element_type.pluralize} for player:#{player} in a grid(All must be number)" unless all_numbers?(element_positions)
            raise FileFormatError, "#{element_type} position of player: #{player} must be within grid" unless vaildate_element_coordinates?(element_positions, grid_size)
            
            true
        end

        def validate_total_missiles(totalt_missiles)
            total_missiles.is_a?(Numeric) && TOTAL_ALLOWED_MISSILES.include?(total_missiles)
        end
    end
end