# game_spec.rb

require_relative '../lib/game'

RSpec.describe Game do
  describe "#initialize" do
    context "with valid input file" do
      file_path = File.expand_path('../fixtures/valid_input.txt', __FILE__)

      let(:game) { Game.new(file_path) }

      it "initializes the game with correct attributes" do
        expect(game.grid_size).to eq(5)
        expect(game.total_ships).to eq(5)
        expect(game.total_missiles).to eq(5)
        expect(game.player1_ships).to eq([[1, 1], [2, 0], [2, 3], [3, 4], [4, 3]])
        expect(game.player2_ships).to eq([[0, 1], [2, 3], [3, 0], [3, 4], [4, 1]])
        expect(game.player1_moves).to eq([[0, 1], [4, 3], [2, 3], [3, 1], [4, 1]])
        expect(game.player2_moves).to eq([[0, 1], [0, 0], [1, 1], [2, 3], [4, 3]])
      end
    end

    context "with invalid input file" do
      it "raises an error" do
        file_path = File.expand_path('../fixtures/invalid_input.txt', __FILE__)
        expect { Game.new(file_path) }.to raise_error(StandardError)
      end
    end
  end

  describe "#play_game" do
    file_path = File.expand_path('../fixtures/valid_input.txt', __FILE__)
    let(:game) {Game.new(file_path)}

    before do
      allow(game).to receive(:execute_moves)
      allow(game).to receive(:write_output)
    end

    it "executes moves for both players" do
      expect(game).to receive(:execute_moves).with(game.player1_grid, game.player2_moves)
      expect(game).to receive(:execute_moves).with(game.player2_grid, game.player1_moves)
      game.play_game
    end
    
    it "simulates the game and writes the correct output" do
      game = Game.new(file_path)
      expect(File).to receive(:open).with('output.txt', 'w')
      game.play_game
    end
  end

  describe "#process_move" do
    file_path = File.expand_path('../fixtures/valid_input.txt', __FILE__)
    let(:game) { Game.new(file_path) }

    context "when the move hits a ship" do
      it "updates the grid with 'X' at the correct position" do
        move = [1, 1]
        game.send(:process_move, game.player1_grid, move)
        expect(game.player1_grid[1][1]).to eq('X')
      end
    end

    context "when the move misses a ship" do
      it "updates the grid with 'O' at the correct position" do
        move = [0, 0]
        game.send(:process_move, game.player1_grid, move)
        expect(game.player1_grid[0][0]).to eq('O')
      end
    end

    context "when the move is out of bounds" do
      it "does not update the grid" do
        move = [6, 6]
        game.send(:process_move, game.player1_grid, move)
        expect(game.player1_grid[6]).to be_nil
      end
    end
  end
end

