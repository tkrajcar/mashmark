require 'bundler/setup'
require 'sinatra'
require 'haml'
require 'punkt-segmenter'
require './markov'

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
  markov = MarkovChainer.new(2)
  read_and_train("sources/#{params[:source1]}.txt", markov)
  read_and_train("sources/#{params[:source2]}.txt", markov)
  output = []
  [3,4,5,6].shuffle.first.times do
    output << markov.generate_sentence
  end
  haml :results, locals: {output: output}
end

def read_and_train(filename, markov)
  all = File.read(filename)
  tokenizer = Punkt::SentenceTokenizer.new(all)
  sentences = tokenizer.sentences_from_text(all, output: :sentences_text)
  sentences.each do |sentence|
    next if sentence =~ /@/
    markov.add_sentence(sentence)
  end
end
