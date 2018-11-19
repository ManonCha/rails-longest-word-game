require 'json'
require 'open-uri'

class GamesController < ApplicationController
  protect_from_forgery except: :new

  def new
    @letters = [*('A'..'Z')].sample(10)
  end

  def score
    letters = params[:letters]
    word = params[:word]
    if included?(letters, word) && english_word?(word)
      @answer = "congratulations!"
    elsif included?(letters, word) && !english_word?(word)
      @answer = "Sorry but <strong>#{word}</strong> does not seem to be an English word"
    elsif !included?(letters, word)
      @answer = "Sorry but #{word} cannot be built out of #{letters}"
    end
  end

  def included?(letters, word)
    word.upcase.chars.all? { |letter| word.upcase.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end

# def compute_score(attempt, time_taken)
#   time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
# end

# def run_game(attempt, grid, start_time, end_time)
#   result = { time: end_time - start_time }

#   score_and_message = score_and_message(attempt, grid, result[:time])
#   result[:score] = score_and_message.first
#   result[:message] = score_and_message.last

#   result
# end

#  def score_and_message(word, grid, time)
#   if included?(attempt.upcase, grid)
#     if english_word?(attempt)
#       score = compute_score(attempt, time)
#       [score, "well done"]
#     else
#       [0, "not an english word"]
#     end
#   else
#     [0, "not in the grid"]
#   end
# end
