

class Player

  attr_accessor :player_num, :first_turn

  def initialize (player_num)
    @player_num = player_num
    @first_turn = true
    @pieces_placed = []
  end

  def did_place (p)
    @pieces_placed << p
  end

  def has_placed (p)
    @pieces_placed.include? p
  end
end
