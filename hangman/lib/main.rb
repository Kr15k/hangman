## load dictionary
## select random word between 5 and 12 characters for hidden string
## draw hidden string
## check if input letter from user is correct
## reveal correct letters
## display wrong letters used
## make sure can't use same letters over again
# allow to guess whole word
## max amount of guesses countdown
## loose if no guesses left
# allow player to save game
# allow to load saved game when program starts

@dict = []
@words_in_dict = 0
@word = ""
@win = nil
@wrong_letters = []
@max_guesses = 12
@game = true

def space
  13.times do
    puts("\n")
  end
end

def load_dict
  File.foreach("google-10000-english-no-swears.txt") do |line|
    word = line.strip
    @words_in_dict += 1
    if (5..12).include?(word.length)
          @dict.push(word)
    end
  end
end

def random_word
  num = rand(0..@words_in_dict)
  while @dict[num] == nil
    num = rand(0..@words_in_dict)
  end
  @word = @dict[num]
  @word_arr = Array.new(@word.length, "_")
end

def visualize_game
  puts "Attempts left #{@max_guesses}"
  if @wrong_letters != []
    puts "#{@wrong_letters.join(" ")}\n\n"
  end
  puts @word_arr.join(" ")
end

def player_input(input)
  if @wrong_letters.include?(input) || @word_arr.include?(input)
      @max_guesses += 1
      puts("Use a unused character!")
  end
  unless @wrong_letters.include?(input) || @word_arr.include?(input)
    word_ary = @word.chars
    @exist = false
    if input.length == 1
      word_ary.each_with_index do |value, i|
        if @word[i].include?(input)
          @word_arr[i] = input
          @exist = true
        end
      end
      if @exist == false
        unless @word_arr.include?(input)
          @wrong_letters.append(input)
        end
      elsif @exist == true
        @max_guesses += 1
      end
    end
  end
end

def check_for_win
  @max_guesses -= 1
  if @word_arr.include?("_") == false
    @win = true
  elsif @max_guesses == 0
    @win = false
  end
  if @win == true
    puts("You won!")
    @game = false
  elsif @win == false
    puts("You lost!")
    @game = false
  end
end

def game
  load_dict
  random_word
  while @game == true do
    visualize_game
    puts("Guess the word\n")
    player_input(gets.chomp)
    space
    check_for_win
  end
  puts "The word was #{@word.upcase}"
end

game
