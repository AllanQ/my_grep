class ParametersParsing
  def initialize(arguments)
    @arguments = arguments

    help

    check_and_parsing
  end

  def all_args
    @all_args
  end

  private

  def help
    if @arguments.include?('-h')
      puts File.readlines('lib/README')
      exit
    end
  end

  def check_and_parsing
    if @arguments.length < 2
      p 'Usage: ./my_grep.rb [OPTIONS] PATTERN FILES'
      exit
    else
      parsing
    end
  end

  def parsing
    option_A3 = @arguments.include?('-A3') ? true : false
    option_e  = @arguments.include?('-e')  ? true : false
    option_r  = @arguments.include?('-R')  ? true : false
    option_z  = @arguments.include?('-z')  ? true : false
    pattern_string = (@arguments - ['-A3', '-e', '-R', '-z']).first
    files_args     = (@arguments - ['-A3', '-e', '-R', '-z']) - [pattern_string]
    @all_args = [option_A3, option_e, option_r, option_z, pattern_string, files_args]
  end
end
