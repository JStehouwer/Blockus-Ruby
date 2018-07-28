require_relative 'board'
require_relative 'piece'

class Tests

  def initialize (run_tests, print_results)
    @run_tests = run_tests
    @print_results = print_results
  end

  def run_tests
    return unless @run_tests
    print "Running tests - #{@print_results ? '' : 'not '} printing results"
    @test_count = 0
    test_piece
    @test_count = 0
    test_board
    @test_count = 0
    test_board_edge
    @test_count = 0
    test_first_turn
  end

  def test_piece
    print 'Testing test_piece_flip'
    Settings.init

    # Reads pieces correctly
    p1 = Settings.pieces[15]
    p1_t = Piece.new [[1,1,1],[0,1,0],[0,1,0]]
    print p1.equal(p1_t), true

    # Vertical flip
    p2 = Settings.pieces[15].flip('v')
    p2_t = Piece.new [[1,1,1],[0,1,0],[0,1,0]]
    print p2.equal(p2_t), true

    # Horizontal flip
    p3 = Settings.pieces[15].flip('h')
    p3_t = Piece.new [[0,1,0],[0,1,0],[1,1,1]]
    print p3.equal(p3_t), true

    # Rotation 0
    p4 = Settings.pieces[15].rotate(0)
    p4_t = Piece.new [[1,1,1],[0,1,0],[0,1,0]]
    print p4.equal(p4_t), true

    # Rotation 1
    p5 = Settings.pieces[15].rotate(1)
    p5_t = Piece.new [[0,0,1],[1,1,1],[0,0,1]]
    print p5.equal(p5_t), true

    # Rotation 2 
    p6 = Settings.pieces[15].rotate(2)
    p6_t = Piece.new [[0,1,0],[0,1,0],[1,1,1]]
    print p6.equal(p6_t), true

    # Rotation 3
    p7 = Settings.pieces[15].rotate(3)
    p7_t = Piece.new [[1,0,0],[1,1,1],[1,0,0]]
    print p7.equal(p7_t), true

    # Rotation 3 and vertical flip
    p8 = Settings.pieces[15].rotate(3).flip('v')
    p8_t = Piece.new [[0,0,1],[1,1,1],[0,0,1]]
    print p8.equal(p8_t), true

    p9 = Settings.pieces[4].rotate(1)
    p9_t = Piece.new [[1],[1],[1],[1]]
    print p9.equal(p9_t), true
  end

  def test_board
    print 'Testing test_board'
    Settings.init

    b = Board.new Settings.board_size
    print b.pieces.size, 0
    print b.board.size, Settings.board_size
    print b.board[0].size, Settings.board_size
    
    p1 = Settings.pieces[15]
    print b.is_valid(1, p1, 0, 0, true), true

    b.place(1, p1, 0, 0, true)
    print b.is_valid(1, p1, 0, 0), false
    print b.is_valid(1, p1, 1, 0), false
    print b.is_valid(2, p1, 0, 0), false
    print b.is_valid(2, p1, 1, 2, false, true), true

    b.place(2, p1, 1, 2, false, true)
    print b.is_valid(1, p1, 1, 2), false
    print b.is_valid(2, p1, 1, 2), false
    print b.is_valid(3, p1, 1, 2), false

    p2 = Settings.pieces[17]
    print b.is_valid(1, p2, 3, 2), true
    b.place(1, p2, 3, 2)
    print b.is_valid(2, p2, 3, 4), false
    print b.is_valid(2, p2, 6, 3), false

    p3 = Settings.pieces[18]
    print b.is_valid(2, p3, 4, 4), true

    p4 = Settings.pieces[5].rotate(3)
    print b.is_valid(3, p4, 1, 0, false, true), true
  end

  def test_board_edge
    print 'Testing test_board_edge'
    Settings.init

    b = Board.new Settings.board_size
    p1 = Settings.pieces[15]
    p2 = Settings.pieces[17]
    print b.is_valid(1, p1, 0, 0, true), true
    b.place(1, p1, 0, 0, true)
    print b.is_valid(2, p2, 17, 17, true), true
    b.place(2, p2, 17, 17, true)

    p3 = Settings.pieces[6]
    print b.is_valid(1, p3.flip('h'), 0, 3), true
    print b.is_valid(1, p3.rotate(3), 3, 0), true
    print b.is_valid(2, p3.rotate(2), 18, 14), true
    print b.is_valid(2, p3, 15, 17), true
  end

  def test_first_turn
    print 'Testing test_first_turn'
    Settings.init

    b = Board.new Settings.board_size
    p1 = Settings.pieces[13]
    print b.is_valid(1, p1, 0, 0, true), true
    print b.is_valid(2, p1, 18, 17, true), true
    print b.is_valid(3, p1, 0, 17, true), true
    print b.is_valid(4, p1, 18, 0, true), true

    p2 = Settings.pieces[20]
    print b.is_valid(1, p2, 0, 0, true), false
    print b.is_valid(2, p2, 17, 17, true), false
    print b.is_valid(3, p2, 0, 17, true), false
    print b.is_valid(4, p2, 17, 0, true), false
  end

  def print (value, expected = nil)
    if expected.nil?
      puts value if @print_results
    else
      @test_count = @test_count + 1
      if @print_results
        puts value == expected ? "  #{@test_count}" : "  #{@test_count} - failed at #{caller[0].split('/')[-1].split(':')[0..1].join(' ')}"
      end
    end
  end
end
