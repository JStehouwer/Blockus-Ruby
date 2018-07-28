class Piece

  attr_accessor :h, :w, :p

  def initialize (p)
    @p = p
    @h = p[0].size
    @w = p.size
  end

  def flip (f)
    fp = nil
    if f == 'n'
      fp = self.dup
    elsif f == 'v' 
      fp = Piece.new @p.map{|i| i.reverse}
    elsif f == 'h'
      fp = Piece.new @p.reverse
    end
    return fp
  end

  def rotate (r)
    rp = nil
    case r
    when 0
      rp = self.dup
    when 1
      rp = Array.new @h
      (0..@h-1).each do |row|
        rp[row] = Array.new @w
      end
      (0..@w-1).each do |col|
        (0..@h-1).each do |row|
          begin
          rp[row][@w-col-1] = @p[col][row]
          rescue
          binding.pry
          end
        end
      end
      rp = Piece.new rp
    when 2
      rp = self.dup.rotate 1
      rp = rp.rotate 1
    when 3
      rp = self.dup.rotate 1
      rp = rp.rotate 1
      rp = rp.rotate 1
    end
    return rp
  end

  def equal (other)
    result = @w == other.w
    result = result && @h == other.h
    result = @p == other.p
    return result
  end
end
