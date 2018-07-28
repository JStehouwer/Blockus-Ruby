require 'gosu'
require 'pry'
require_relative 'graphics'
require_relative 'player'
require_relative 'settings'
require_relative 'tests'

class Main < Gosu::Window

  def initialize
    Tests.new(true, true).run_tests

    Settings.init
    Settings.debug_mode true

    super Settings.window_size[0].to_i, Settings.window_size[1].to_i
    self.caption = 'Blokus'

    @random = Random.new
    @index = 15
    @rot = 0
    @flip = 'n'

    @board = Board.new Settings.board_size

    @cur_player = 0
    @num_players = 4
    @players = []
    (1..@num_players).each do |p|
      np = Player.new p
      @players << np
    end
    @current_player = @players[@cur_player]
  end

  def update
  end

  def draw
    Graphics.draw_background
    Graphics.draw_side_pieces @current_player

    Graphics.draw_board @board

    cs = Settings.cell_size.to_i
    if (mouse_x * cs < Settings.window_size.min * cs) && (mouse_y < Settings.window_size.min * cs)
      @py = (mouse_y.to_i / cs)
      @px = (mouse_x.to_i / cs)
      Graphics.draw_piece Settings.pieces[@index].flip(@flip).rotate(@rot),
                          Settings.player_colors[@players[@cur_player].player_num],
                          @px * cs,
                          @py * cs,
                          true
    end
  end

  def button_down (id)
    if Settings.controls['exit'].include? id
      close
    elsif id == Gosu::KB_Q
      @index = (@index + 1) % Settings.pieces.size
    elsif id == Gosu::KB_E
      @rot = (@rot + 1) % 4
    elsif id == Gosu::KB_W
      @flip = 'n'
    elsif id == Gosu::KB_S
      @flip = 'h'
    elsif id == Gosu::KB_A
      @flip = 'v'
    elsif id == Gosu::KB_R
      if @current_player.has_placed @index
        puts "Player #{@current_player.player_num} has already placed this piece" if Settings.debug_mode
      else
        placed = @board.place @current_player.player_num,
                              Settings.pieces[@index].flip(@flip).rotate(@rot),
                              @px,
                              @py,
                              @current_player.first_turn
        puts "Try to place: #{placed}" if Settings.debug_mode
        if placed
          @current_player.did_place @index
          if @current_player.first_turn
            @current_player.first_turn = false
          end
          @cur_player = (@cur_player + 1) % @num_players
          @current_player = @players[@cur_player]
        end
      end
    end
  end
end

Main.new.show
