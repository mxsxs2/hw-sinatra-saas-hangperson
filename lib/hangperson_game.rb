# frozen_string_literal: true

class HangpersonGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service
  # Add readeble instance  variables
  attr_reader :word
  attr_reader :guesses
  attr_reader :wrong_guesses
  attr_reader :word_with_guesses
  @@max_incorrect_allowed = 7

  # Init app and variables
  def initialize(word)
    # Make the word lowercase
    @word = word.downcase
    @guesses = ''
    @wrong_guesses = ''
    @word_with_guesses = ''
  end

  # Guesses if a letter is in the word
  public

  def guess(letter)
    # Raise error on invalid input
    raise ArgumentError if letter.nil? || letter.empty? || /^[a-zA-Z]$/.match(letter).nil?

    # Make the letter lowercase
    letter = letter.downcase
    # If the letter wasnt guessed yet
    if !@guesses.include?(letter) && !@wrong_guesses.include?(letter)
      # Check if it is in the word
      if @word.include?(letter)
        @guesses += letter
      else
        @wrong_guesses += letter
      end
      create_masked_word
      return true
    end
    false
  end

  # Creates the masked word
  private

  def create_masked_word
    str = [] # Retarded immutable frozen string hack.
    @word.each_char.with_index do |c, i|
      str[i] = if @guesses.include?(c)
                 c
               else
                 '-'
               end
      @word_with_guesses = str.join('')
    end
  end

  # Check whether the game is won or not
  public

  def check_win_or_lose
    return :win if @word_with_guesses == @word
    return :lose if @guesses.length + @wrong_guesses.length == @@max_incorrect_allowed

    :play
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start do |http|
      return http.post(uri, '').body
    end
  end
end
