module Requester
  def select_main_menu_action
    # prompt the user for the "random | scores | exit" actions
    actions = ["random", "scores", "exit"]
    puts actions.join(" | ")
    actions
  end

  def ask_question(question)
    # show category and difficulty from question
    # show the question
    # show each one of the options
    # grab user input
  end

  def will_save?(score)
    # show user's score
    # ask the user to save the score
    # grab user input
    # prompt the user to give the score a name if there is no name given, set it as Anonymous
  end

  def gets_option(prompt, options)
    # prompt for an input
    !prompt.empty? && (puts prompt)
    action = nil
    # keep going until the user gives a valid option
    until options.include?(action)
      print "> "
      action = gets.chomp
      options.include?(action) || (puts "Invalid Action") 
    end
    action
  end
end
