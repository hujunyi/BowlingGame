# This class represent one frame
class Frame
  attr_reader :reward,:records
  def initialize 
    @reward = nil
    @records = []
  end
  def play
    ball = knock_down(10)
    @records << ball
    if ball == 10
      @reward = "strike"
    else
      second_ball = knock_down(10-ball)
      @records << second_ball
      ball += second_ball
      @reward = "spare" if ball == 10
    end
  end
  def last_play
    puts "This is the last frame"
    ball = knock_down
    @records << ball
    if ball == 10
      # If this is a strike, then there are two additional balls
      @reward = "strike"
      second_ball = knock_down
      floor = 10
      # If the second ball doesn't get 10, then the third ball has the floor
      floor -= second_ball if second_ball != 10
      @records << second_ball
      third_ball = knock_down(floor)
      @records << third_ball
    else 
      # If this is not a strike, then the second ball has the floor 10-ball
      second_ball = knock_down(10-ball)
      @records << second_ball
      if ball + second_ball == 10
        # If this is a spare, then there is one additional ball
        third_ball = knock_down
        @records.push(third_ball)
        @reward = "spare" 
      end
    end
  end
  private
  def knock_down(floor=10)
    num = Integer(gets)
    while num>floor||num<0
      puts "Invalid input. Please type in a number between 0 and #{floor}"
      num = Integer(gets)
    end
    num
  end
end
# An array holds the next two balls for the current ball
class NextTwo
  attr_reader :record
  def initialize
    @records = []
  end
  def push(score)
    if @records.size < 2
      @records.push(score)
    else
      @records.delete_at(0)
      @records.push(score)
    end
  end
  # Get the sum of the next two balls
  def bonus_for_strike
    @records.reduce(:+)
  end
  # Get the score of the next ball
  def bonus_for_spare
    @records.last
  end
end
class Bowling
  attr_reader :frames,:score
  def initialize(n)
    @frames = []
    n.times do
      @frames << Frame.new
    end
  end
  # Play the 10 frames, let user input the scores for each frame
  def play_game
    puts "Type in the number of pins knocked down with each ball(0-10)"
    length = @frames.size
    @frames[0..(length-2)].each_with_index do |f,index|
      puts "Frame No.#{index+1}"
      f.play
    end
    @frames.last.last_play
  end
  def get_score
    score = 0
    nextTwo = NextTwo.new
    # Handle the last one
    @frames.last.records.reverse.each do |s|
      score += s
      nextTwo.push(s)
    end
    # calculate the score reversely
    @frames[0..(@frames.size-2)].reverse.each do |f|
      # Get the bonus if the frame has
      if f.reward == "strike"
        score += nextTwo.bonus_for_strike
      elsif f.reward == "spare"
        score += nextTwo.bonus_for_spare
      end
      # Push the records in the frame into the nextTwo for further reference
      f.records.reverse.each do |s|
        score += s
        nextTwo.push(s)
      end
    end
    puts "Your total score is: #{score}"
  end
  def turkey
    turkey = []
    index = 0
    while index<@frames.length-2
      if @frames[index].reward== "strike" && @frames[index+1].reward == "strike" && @frames[index+2].reward == "strike"
        turkey << index+1
        index += 2
      end
      index +=1
    end
    puts "Turkey is bowled at the index of #{turkey}\n(In requirements file sent to me: When 2 strikes are bowled in a row, that is called a 'Turkey'. Now I assume it to be 3 according to your description.)" if !turkey.empty?
  end
end
bowl = Bowling.new(10)  
bowl.play_game
bowl.get_score
bowl.turkey
