require "httparty"
require "json"
require "terminal-table"
require "colorize"
require_relative "presenter"
require_relative "requester"
require_relative "helpers/helpers"

class CliviaGenerator
  include Helpers
  include Presenter
  include Requester

  def initialize
    @score = 0
    @questions = []
    @file_name = ARGV.size.zero? ? "score.json" : ARGV.shift
  end

  def start
    print_welcome
    actions = select_main_menu_action
    action = nil
    until action == "exit"
      action = gets_option("", actions)
      case action
      when "random" then random_trivia
      when "scores" then print_scores
      when "exit" then puts "exit"
      end
    end
  end

  def random_trivia
    load_questions
    @score = 0
    ask_questions
  end

  def ask_questions
    @questions.each do |question|
      answer = ask_question(question)
      correct_answer = decode(question[:correct_answer])
      if answer == correct_answer
        puts "#{answer}... Correct!"
        @score += 10
      else
        puts "#{answer}... Incorrect!"
        puts "The correct answer was: #{correct_answer}\n"
      end
    end
    # print "Well done! Your score is #{@score}\n--------------------------------------------------\n"
    # save_option = gets_option("Do you want to save your score? (y/n)", ["y", "n"])
    # if save_option == "y"
    #   print "Type the name to assign to the score\n> "
    #   name_score = gets.chomp
    #   name_score.empty? && (name_score = "Anonymous")
    #   save({ name: name_score, score: @score })
    # end
    # print_welcome
    # select_main_menu_action
    will_save?(@score)
  end

  def save(data)
    data_final = if File.exist?(@file_name) && !File.empty?(@file_name)
                   JSON.parse(File.read(@file_name), symbolize_names: true).push(data)
                 else
                   [data]
                 end
    File.write(@file_name, data_final.to_json)
  end

  def parse_scores
    if File.exist?(@file_name) && !File.empty?(@file_name)
      JSON.parse(File.read(@file_name), symbolize_names: true)
    else
      []
    end
  end

  def load_questions
    response = HTTParty.get("https://opentdb.com/api.php?amount=10")
    @questions = response.body
    parse_questions
  end

  def parse_questions
    @questions = JSON.parse(@questions, symbolize_names: true)[:results]
  end

  def print_scores
    list_scores = parse_scores
    list_scores = list_scores.sort_by { |score| score[:score] }.reverse
    table = Terminal::Table.new
    table.title = "Top Scores"
    table.headings = ["Name", "Score"]
    table.rows = list_scores.map do |score|
      print_score(score)
    end
    puts table
    print_welcome
    select_main_menu_action
  end
end

trivia = CliviaGenerator.new
trivia.start
