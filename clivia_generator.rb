# do not forget to require your gem dependencies
# do not forget to require_relative your local dependencies
require "httparty"
require "json"
require_relative "presenter"
require_relative "requester"
require_relative "helpers/helpers"

class CliviaGenerator
  # maybe we need to include a couple of modules?
  include Helpers
  include Presenter
  include Requester

  def initialize
    # we need to initialize a couple of properties here
    @score = 0
    @questions = []
    @file_name = ARGV.size.zero? ? "score.json" : ARGV.shift
  end

  def start
    # welcome message
    print_welcome
    # prompt the user for an action
    actions = select_main_menu_action
    # keep going until the user types exit
    action = nil
    until action == "exit"
      action = gets_option("", actions)
      case action
      when "random" then random_trivia
      when "scores" then puts "scores"
      when "exit" then puts "exit"
      end
    end
  end

  def random_trivia
    # load the questions from the api
    load_questions
    # questions are loaded, then let's ask them
    ask_questions
  end

  def ask_questions
    # ask each question
    # if response is correct, put a correct message and increase score
    # if response is incorrect, put an incorrect message, and which was the correct answer
    # once the questions end, show user's score and promp to save it
    @questions.each do |question|
      answer = ask_question(question)
      correct_answer = decode(question[:correct_answer])
      if answer == correct_answer
        puts "#{answer}... Correct!"
        @score += 10
      else
        puts "#{answer}... Incorrect!"
        puts "The correct answer was: #{correct_answer}"
      end
    end
    puts "Well done! Your score is #{@score}"
    puts "--------------------------------------------------"
    save_option = gets_option("Do you want to save your score? (y/n)", ["y", "n"])
    if save_option == "y"
      puts "Type the name to assign to the score"
      print "> "
      name_score = gets.chomp
      name_score.empty? && (name_score = "Anonymous")
      save({name: name_score, score: @score})
    end
    @score = 0
    print_welcome
    select_main_menu_action
  end

  def save(data)
    # write to file the scores data
    data_final = []
    if File.exist?(@file_name) && !File.empty?(@file_name)
      data_final = JSON.parse(File.read(@file_name)).push(data)
    else
      data_final = [data]
    end
    File.write(@file_name, data_final.to_json)
  end

  def parse_scores
    # get the scores data from file
  end

  def load_questions
    # ask the api for a random set of questions
    response = HTTParty.get("https://opentdb.com/api.php?amount=10")
    # then parse the questions
    @questions = response.body
    parse_questions
  end

  def parse_questions
    # questions came with an unexpected structure, clean them to make it usable for our purposes
    @questions = JSON.parse(@questions, symbolize_names: true)[:results]
  end

  def print_scores
    # print the scores sorted from top to bottom
  end
end

trivia = CliviaGenerator.new
trivia.start
