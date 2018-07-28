require_relative 'settings'

class Board

  attr_accessor :board, :board_size, :pieces

  def initialize (board_size)
    @board_size = board_size

    @board = Array.new @board_size
    (0..@board_size-1).each do |r|
      @board[r] = Array.new @board_size, 0
    end

    @pieces = Array.new
  end

  def place (player, piece, x, y, first_turn = false, ignore = false, force = false)
    begin
      if is_valid player, piece, x, y, first_turn, ignore, force
        (0..piece.w-1).each do |c|
          (0..piece.h-1).each do |r|
            @board[x+c][y+r] = player if piece.p[c][r] != 0
          end
        end
        return true
      else
        puts "Invalid placement for piece" if Settings.debug_mode
        return false
      end
    rescue
      puts 'Problem placing piece' if Settings.debug_mode
      return false
    end
  end

  def is_valid (player, piece, x, y, first_turn = false, ignore = false, force = false)
    if force
      return true
    end
    if first_turn
      case player
      when 1
        return piece.p[0][0] == 1 && x == 0 && y == 0
      when 2
        h = piece.h - 1
        w = piece.w - 1
        return piece.p[w][h] == 1 && x + w == 19 && y + h == 19
      when 3
        h = piece.h - 1
        return piece.p[0][h] == 1 && x == 0 && y + h == 19
      when 4
        w = piece.w - 1
        return piece.p[w][0] == 1 && x + w == 19 && y == 0
      end
    end
    is_diag = ignore
    (0..piece.w-1).each do |c|
      (0..piece.h-1).each do |r|
        if piece.p[c][r] == 1
          diags = []
          adjts = []
          # Make sure no spaces are already occupied
          if @board[x+c][y+r] != 0
            return false
          end
          # If on the edge of the board
          if x+c != 0
            adjts << [-1,0]
            if y+r != 0
              diags << [-1,-1]
            end
            if y+r != 19
              diags << [-1,1]
            end
          end
          if x + c != 19
            adjts << [1,0]
            if y+r != 0
              diags << [1,-1]
            end
            if y+r != 19
              diags << [1,1]
            end
          end
          if y+r != 0
            adjts << [0,-1]
          end
          if y+r != 19
            adjts << [0,1]
          end
          # Check if player owns diag
          diags.each do |d|
            if @board[x+c+d[0]][y+r+d[1]] == player
              is_diag = true
            end
          end
          # Make sure no adjacent spaces are owned by this player
          adjts.each do |a|
            if @board[x+c+a[0]][y+r+a[1]] == player
              return false
            end
          end
        end
      end
    end
    return is_diag
  end
end
