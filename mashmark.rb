require 'bundler/setup'
require 'sinatra'
require 'haml'
require 'marky_markov'

get '/' do
  sources = {
    sherlock: "The Adventures of Sherlock Holmes",
    hst: "Assorted works of Hunter S. Thompson",
    kjv: "King James Bible",
    lovecraft: "Assorted works of HP Lovecraft"
  }

  haml :index, locals: {sources: sources}
end

get '/mash' do
  markov = MarkyMarkov::TemporaryDictionary.new(2)
  markov.parse_file("sources/#{params[:source1]}.txt")
  markov.parse_file("sources/#{params[:source2]}.txt")
  output = []
  [1,2,3,4].shuffle.first.times do
    output << markov.generate_1_sentence
  end
  haml :results, locals: {output: output}
end
