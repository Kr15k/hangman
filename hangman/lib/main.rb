class Game
  require 'csv'
  def initialize
    @dict = []
    @words_in_dict = 0
    @word = ''
    @wrong_letters = []
    @max_guesses = 12
    @game = true
    @load_num = nil
    @menu = false
  end

  def space
    13.times do
      puts("\n")
    end
  end

  def load_dict
    File.foreach('google-10000-english-no-swears.txt') do |line|
      word = line.strip
      @words_in_dict += 1
      @dict.push(word) if (5..12).include?(word.length)
    end
  end

  def random_word
    num = rand(0..@words_in_dict)
    num = rand(0..@words_in_dict) while @dict[num].nil?
    @word = @dict[num]
    @word_arr = Array.new(@word.length, '_')
  end

  def visualize_game
    puts "Attempts left #{@max_guesses}"
    puts "#{@wrong_letters.join(' ')}\n\n" if @wrong_letters != []
    puts @word_arr.join(' ')
  end

  def check_for_char(input)
    if @wrong_letters.include?(input) || @word_arr.include?(input)
      @max_guesses += 1
      puts('Use a unused character!')
    end
    return if @wrong_letters.include?(input) || @word_arr.include?(input)

    word_ary = @word.chars
    @exist = false
    return unless input.length == 1

    word_ary.each_with_index do |_value, i|
      if @word[i].include?(input)
        @word_arr[i] = input
        @exist = true
      end
    end
    if @exist == false
      @wrong_letters.append(input) unless @word_arr.include?(input)
    elsif @exist == true
      @max_guesses += 1
    end
  end

  def check_for_win
    @max_guesses -= 1
    if @word_arr.include?('_') == false
      puts('You won!')
      @game = false
      puts "The word was #{@word.upcase}"
    elsif @max_guesses == 0
      puts('You lost!')
      @game = false
      puts "The word was #{@word.upcase}"
    end
  end

  def menu_choices(value)
    if value == 'play'
      initialize
      space
      load_dict
      random_word
      play
    elsif value == 'load'
      space
      choose_save
      main_menu
    elsif value == 'clear'
      space
      clear_saves
      main_menu
    else
      exit
    end
  end

  def input_check(value)
    if value == 'menu'
      space
      main_menu
      @menu = true
    elsif value == 'save'
      save_game
      @game = false
    elsif value.count('a-zA-Z') > 0 == true and value.length == 1
      @error = false
      check_for_char(value)
    else
      @max_guesses += 1
      @error = true
      visualize_game
      puts 'Type in a letter from a-Z'
    end
  end

  def save_game
    time = Time.now.getlocal.strftime('%Y-%m-%d-%H-%M')
    CSV.open('saves.csv', 'ab') do |csv|
      csv << [time, @word, @wrong_letters.join(' '), @max_guesses, @word_arr.join(' ')]
    end
  end

  def load_game(value)
    numb = value.to_i - 1
    @word = CSV.readlines('saves.csv', headers: true)[numb][1]
    @wrong_letters = CSV.readlines('saves.csv', headers: true)[numb][2].split(' ')
    @max_guesses = CSV.readlines('saves.csv', headers: true)[numb][3].to_i
    @word_arr = CSV.readlines('saves.csv', headers: true)[numb][4].split(' ')
    play
  end

  def choose_save
    if CSV.readlines('saves.csv', headers: true)[0].nil?
      puts("You have no saves!\n\n\n")
    else
      @contents = CSV.open(
        'saves.csv',
        headers: true,
        header_converters: :symbol
      )
      @arr = []
      @contents.each_with_index do |row, i|
        i2 = i + 1
        @arr.append("#{i2}. #{row[:time]}")
      end
      puts @arr
      puts 'what save do you want?'
      load_game(gets.chomp.downcase)
    end
  end

  def clear_saves
    CSV.open('saves.csv', 'w') do |csv|
      csv << %w[time word wrong_letters max_guesses word_arr]
    end
    puts("Saves cleared!\n\n\n")
  end

  def play
    while @game == true && @menu == false
      visualize_game
      puts("Guess the word\n")
      input_check(gets.chomp.downcase)
      space
      check_for_win
    end
  end

  def main_menu
    puts('HangMan')
    puts('Commands:')
    puts('  load (load previous game)')
    puts('  save (save current game)')
    puts('  play (play a new game)')
    puts('  clear (clears all saves)')
    puts('  menu (goes back to menu)')
    menu_choices(gets.chomp.downcase)
  end
end
Game.new.main_menu
