# frozen_string_literal: true

class HangpersonGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service
  # Add readeble instance  variables
  attr_reader :word
  attr_reader :guesses
  attr_reader :wrong_guesses

  # Init app and variables
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  # Guesses if a letter is in the word
  def guess(letter)
    # If the letter wasnt guessed yet
    if !@guesses.include?(letter) && !@wrong_guesses.include?(letter)
      # Check if it is in the word
      if @word.include?(letter)
        @guesses += letter
      else
        @wrong_guesses += letter
      end
    end
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
