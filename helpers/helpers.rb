require "htmlentities"

module Helpers
  def decode(word)
    coder = HTMLEntities.new
    coder.decode(word)
  end

  def decode_array(words)
    words.map { |word| decode(word) }
  end

  def array_to_string(array)
    array.map(&:to_s)
  end

  def enum_options(options)
    options_enum = ""
    options.each_with_index do |option, index|
      options_enum += "#{index + 1}.".red + " #{option}\n"
    end
    options_enum
  end
end
