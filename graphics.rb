require 'gosu'
require_relative 'settings'

class Graphics

  def self.draw_background 
    color = Settings.colors['grey']
    ws = Settings.window_size
    Gosu::draw_quad 0, 0, color,
                    0, ws[1], color,
                    ws[0], ws[1], color,
                    ws[0], 0, color,
                    1

    cs = Settings.cell_size
    line_color = Settings.colors['black']
    ws = Settings.window_size.min
    (0..Settings.board_size).each do |r|
      (0..Settings.board_size).each do |c|
        x = r * cs
        y = r * cs

        lw = (r % 4 == 0) && (c % 4 == 0) ? 3 : 1

        Gosu::draw_quad x - lw, 0, line_color,
                        x - lw, ws, line_color,
                        x + lw, ws, line_color,
                        x + lw, 0, line_color,
                        2

        Gosu::draw_quad 0, y - lw, line_color,
                        0, y + lw, line_color,
                        ws, y + lw, line_color,
                        ws, y - lw, line_color,
                        2
      end
    end
  end

  def self.draw_piece (piece, player_color, x, y, bg)
    cs = Settings.cell_size
    pc = player_color
    pcbg = player_color / 2

    draw_layer = 3 + (bg ? 1 : 0)

    (0..piece.w-1).each do |c|
      (0..piece.h-1).each do |r|
        if piece.p[c][r] == 1
          Gosu::draw_quad x + c * cs, y + r * cs, pc,
                          x + c * cs, y + (r + 1) * cs, pc,
                          x + (c + 1) * cs, y + (r + 1) * cs, pc,
                          x + (c + 1) * cs, y + r * cs, pc,
                          draw_layer + 1
        else
          if bg
            Gosu::draw_quad x + c * cs, y + r * cs, pcbg,
                            x + c * cs, y + (r + 1) * cs, pcbg,
                            x + (c + 1) * cs, y + (r + 1) * cs, pcbg,
                            x + (c + 1) * cs, y + r * cs, pcbg,
                            draw_layer - 1
          end
        end
      end
    end
  end

  def self.draw_board (board)
    cs = Settings.cell_size
    (0..board.board_size-1).each do |r|
      (0..board.board_size-1).each do |c|
        b = board.board[r][c]
        if b > 0
          pc = Settings.player_colors[b]
          Gosu::draw_quad r * cs, c * cs, pc,
                          r * cs, (c + 1) * cs, pc,
                          (r + 1) * cs, (c + 1) * cs, pc,
                          (r + 1) * cs, c * cs, pc,
                          3
        end
      end
    end
  end

  def self.draw_side_pieces (player)
    pc = Settings.player_colors[player.player_num]
    pieces = Settings.pieces
    cs = Settings.cell_size
    (0..pieces.size-1).each do |p|
      x_off = p / 3
      y_off = p % 3

      piece = pieces[p]
      if player.has_placed p
        Graphics.draw_piece piece, 0xff_dddddd, (x_off * 4 + 21) * cs, (y_off * 6 + 1) * cs, true
      else
        Graphics.draw_piece piece, pc, (x_off * 4 + 21) * cs, (y_off * 6 + 1) * cs, true
      end
    end
  end
end
