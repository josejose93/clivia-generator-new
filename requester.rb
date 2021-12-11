require "htmlentities"

module Requester
  def select_main_menu_action
    actions = ["random", "scores", "exit"]
    puts actions.join(" | ")
    actions
  end

  def ask_question(question)
    puts "Category: #{question[:category]} | Difficulty: #{question[:difficulty]}"
    puts "Question: #{decode(question[:question])}"
    alternatives = decode_array(question[:incorrect_answers].push(question[:correct_answer]).shuffle)
    options = array_to_string((1..alternatives.size).to_a)
    answer = gets_option(enum_options(alternatives), options)
    alternatives[answer.to_i - 1]
  end

  def will_save?(score)
    puts "Well done! Your score is #{score}"
    puts "--------------------------------------------------"
    save_option = gets_option("Do you want to save your score? (y/n)", ["y", "n"])
    if save_option == "y"
      puts "Type the name to assign to the score"
      print "> "
      name_score = gets.chomp
      name_score.empty? && (name_score = "Anonymous")
      save({ name: name_score, score: @score })
    end
    print_welcome
    select_main_menu_action
  end

  def gets_option(prompt, options)
    !prompt.empty? && (puts prompt)
    action = nil
    until options.include?(action)
      print "> "
      action = gets.chomp
      options.include?(action) || (puts "Invalid Action")
    end
    action
  end
end
