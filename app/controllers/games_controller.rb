require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabet = ('a'..'z').to_a
    @letters = []
    10.times { @letters << alphabet.sample }
    @start_time = Time.now
  end

  def score
    @time_elapsed = Time.now - Time.parse(params[:start_time])
    w = params[:word]
    letters = params[:letters].split(' ')
    w_info = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{w}").read)
    @result = if w_info['found'] && w.chars.all? { |l| letters.include?(l) && w.chars.count(l) <= letters.count(l) }
                "Congratulations #{w.upcase} is a valid word"
              elsif !w_info['found'] && w.chars.all? { |l| letters.include?(l) && w.chars.count(l) <= letters.count(l) }
                "#{w.upcase} is not english"
              else
                "#{w.upcase} is not possible given the grid #{letters.join(' ').upcase}"
              end
  end
end
