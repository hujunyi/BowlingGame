# This class represent one frame
class Frame
  attr_reader :reward,:records
  def initialize 
    @reward = nil
    @records = []
  end
  def play
    ball = gets.to_i
    @records << ball
    if ball == 10
      @reward = "strike"
    else
      second_ball = gets.to_i
      @records << second_ball
      ball += second_ball
      @reward = "spare" if ball == 10
    end
  end
  def last_play
    puts "This is the last frame"
    ball = gets.to_i
    second_ball = gets.to_i
    @records << ball
    @records << second_ball
    if ball == 10||ball+second_ball == 10
      third_ball = gets.to_i
      @records.push(third_ball)
      @reward = "spare" 
      @reward = "strike"
    end
  end
end
# A array hold the next two balls for the current ball
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
    puts "Type in the number of pins knocked down with each ball"
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
    @frames[0..(@frames.size-2)].each do |f|
      # Get the bonus if the frame has
      if f.reward == "strike"
        score += nextTwo.bonus_for_strike
      elsif f.reward == "spare"
        score += nextTwo.bonus_for_spare
      end
      # Push the records in the frame into the nextTwo for further reference
      f.records.each do |s|
        score += s
        nextTwo.push(s)
      end
    end
    puts "Your total score is: #{score}"
  end
  def turkey
    turkey = []
    (@frames.length-1).times do |index|
      if @frames[index].reward == "strike" && @frames[index+1].reward == "strike"
        turkey << index+1
      end
    end
    puts "Turkey is bowled at the index of #{turkey}" if !turkey.empty?
  end

end
bowl = Bowling.new(10)  
bowl.play_game
bowl.get_score
bowl.turkey
