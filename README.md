# Battleship Game

This is a simple implementation of the Battleship game in Ruby.

## Description

Battleship is a game played between 2 players. Each player is initialized with an M * M grid with 'S' number of ships placed at specified positions on the grid. The objective of the game is to destroy the opponent's battleships by launching missiles.

## Features

- Initialization of the game with input from a file
- Simulates the game based on the provided input
- Determines the winner and writes the game result to an output file

## Prerequisites

Before running the Battleship game, ensure you have the following prerequisites installed:

- Ruby version 3.1.3
  
## Setup

1. Clone the repository:

   `git clone https://github.com/smiley-sachdeva/battleship_game`
   
2. Install dependencies:

    `bundle install`

## Usage

1. Create an input file with the following format:

   ```plaintext
    5
    5
    1,1:2,0:2,3:3,4:4,3
    0,1:2,3:3,0:3,4:4,1
    5
    0,1:4,3:2,3:3,1:4,1
    0,1:0,0:1,1:2,3:4,3

2. Run the game with the input file:

    `./game.rb input.txt`

3. Check the output file (`output.txt`) for the game result.
4. Run specs: `rspec specs/game_spec.rb`

