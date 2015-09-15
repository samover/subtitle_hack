require 'time'

DICT            = "/usr/share/dict/words"
PROF_LIST       = "/profanity-list.txt"
FILENAME        = "/skyfall_en.srt"
REGEXP          = /(^.*\d+)\n([\d:,]+)\s-->\s([\d:,]+)\n(.+||.+\n.+||.+\n.+\n.+)\n\n/

def create_data_set 
  puts "Creating dataset ..."
  IO.read(__dir__ + FILENAME)
    .gsub(/\r/, '')
    .scan(REGEXP)       
end

def join_text_again(srt)
  srt.map { |element| 
    "#{element[0]}\n#{element[1]} --> #{element[2]}\n#{element[3]}\n\n"
  }.join
end

def modify_time(srt, lag)
  puts "Modifying the time lag and saving it in a new SRT file ..."
  srt.each do |n|
    n[1] = (Time.parse(n[1]) + lag).strftime('%H:%M:%S,%L')
    n[2] = (Time.parse(n[2]) + lag).strftime('%H:%M:%S,%L')
  end   
  
  IO.write( __dir__ + FILENMAME.gsub(/.srt/, '_new.srt') , join_text_again(srt) )
end

def check_typos(srt)
  puts "Checking for typos and putting them in potential_typos.txt ..."
  word_list = IO.read(DICT)
  typos = Hash.new
  
  srt.each do |n| 
    n[3].gsub(/'.\s/, ' ').scan(/['\w]+/).each do |word|
      unless (word_list.include?(word) || word_list.include?(word.downcase))
        typos.has_key?(word) ? typos[word] << n[1] : typos[word] = [n[1]] 
      end
    end
  end
  
  string = String.new
  typos.sort.each { |key, value| string << "#{key}: #{value.join(', ')}\n" }
  IO.write(__dir__ + "/potential_typos.txt", string)
end

def profanity_filter(srt)
  puts "Checking for profanities and listing them CENSORED in profanity.txt ..."
  profanity = Array.new
  swear_list = IO.read(__dir__ + PROF_LIST).split
  
  srt.each do |n| 
    n[3].gsub(/'.\s/, ' ').scan(/['\w]+/).each do |word|
      if swear_list.include?(word) 
        n[3] = n[3].gsub(word, 'CENSORED')
        profanity.push(n) 
      end
    end
  end
  
  IO.write(__dir__ + "/profanity.txt", join_text_again(profanity))
end
  
srt_data_set = create_data_set
modify_time(srt_data_set, 2.500)
check_typos(srt_data_set)
profanity_filter(srt_data_set)
