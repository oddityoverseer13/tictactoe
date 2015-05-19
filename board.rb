class Board
	attr_reader :w,:h,:data
	def initialize(w,h,data=nil)
		@w = w
		@h = h
		@data = data || ys.map{|i| xs.map{|j| nil}}

	end
	def xs
		(0..(@w-1))
	end
	def ys
		(0..(@h-1))
	end
	def rows
		xs.map{|x| ys.map{|y| [x,y]}}
	end
	def cols
		ys.map{|y| xs.map{|x| [x,y]}}
	end
	def diags
		# TODO: Change this to dynamic generation
		[[[0,0],[1,1],[2,2]],
		 [[0,2],[1,1],[2,0]]]
	end
	def cellCoords
		rows.reduce(:+)
	end
	def cells
		cellCoords.map{|x,y| @data[x][y]}
	end
	def setCoords
		# Return array of winning sets
		rows + cols + diags
	end
	def sets
		setCoords.map{|set| set.map{|x,y| @data[x][y]}}
	end
	def valid?(x,y)
		@data[x][y].nil?
	end
	def validMoves
		cellCoords.select{|x,y| valid?(x,y)}
	end
	def move(x,y,player)
		@data[x][y] = player
	end
	def unmove(x,y)
		@data[x][y] = nil
	end
	def to_s
		cols.map{|c| c.map{|x,y| (@data[x][y] == nil) ? '_': @data[x][y]}.join(' ')}.join("\n")
	end
	def end?
		# There's a winner or no moves left
		! winner.nil? || cells.none? {|cell| cell.nil?}
	end
	def winner
		# Any sets have all the same, non-nil, elements
		if sets.any?{|s| Board.countInRow(s,'X') == 3 }
			'X'
		elsif sets.any?{|s| Board.countInRow(s,'O') == 3 }
			'O'
		else
			nil
		end
	end
	class << self
		def countInRow(set,player)
			bestCount = 1
			currentCount = 1
			lastE = nil
			set.each do |e|
				if e == player
					if lastE == e
						currentCount += 1
					end
					if currentCount > bestCount
						bestCount = currentCount
					end
					lastE = e
				end
			end
			bestCount
		end
		def posCoords
			[[0,0],[1,0],[2,0],[0,1],[1,1],[2,1],[0,2],[1,2],[2,2]]
		end
		def inputGrid
			"1 2 3\n" +
			"4 5 6\n" +
			"7 8 9"
		end
	end
end
