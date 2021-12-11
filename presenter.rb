module Presenter
  def print_welcome
    puts "###################################"
    puts "#   Welcome to Clivia Generator   #"
    puts "###################################"
  end

  def print_score(score)
    [score[:name], score[:score]]
  end
end
