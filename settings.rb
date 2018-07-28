require 'pry'
require_relative 'piece'

class Settings

  def self.init
    @@board_size = 20
    @@cell_size = 40.0
    @@window_size = [Settings.cell_size * @@board_size + @@cell_size * 30, Settings.cell_size * @@board_size]
    @@colors = {
                'black'  => 0xff_000000,
                'grey'   => 0xff_666666,
                'white'  => 0xff_ffffff,
                'red'    => 0xff_dd3333,
                'green'  => 0xff_33dd33,
                'blue'   => 0xff_3333dd,
                'yellow' => 0xff_dddd33
               }
    @@controls = {
                  'exit' => [Gosu::KB_ESCAPE]
                 }
    @@pieces = Settings.read_pieces 'pieces/base.txt'
    @@player_colors = {1 => @@colors['blue'], 2 => @@colors['red'], 3 => @@colors['green'], 4 => @@colors['yellow']}
    @@debug_mode = false
  end

  def self.board_size
    @@board_size
  end

  def self.cell_size
    @@cell_size
  end

  def self.colors
    @@colors
  end

  def self.controls
    @@controls
  end

  def self.pieces
    @@pieces
  end

  def self.player_colors
    @@player_colors
  end

  def self.window_size
    @@window_size
  end

  def self.debug_mode (debug_mode = nil)
    if not debug_mode.nil?
      @@debug_mode = debug_mode
    end
    @@debug_mode
  end

  def self.read_pieces (file)
    pieces = Array.new
    file_lines = File.readlines file
    file_lines.each do |line|
      line = line.strip
      next if line == "" # Skip this line if it's empty
      piece = line.split ','
      piece = piece.map {|l| l.split ''}
      piece = piece.map{ |r| r.map{ |c| c.to_i } }
      pieces << Piece.new(piece)
    end
    return pieces
  end
end
