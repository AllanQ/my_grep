require 'find'
require 'zlib'

class Grep
  
  def initialize(all_args)
    @all_args = []
    @all_args = all_args
    @option_A3 = @all_args[0]
    @option_e  = @all_args[1]
    @option_r  = @all_args[2]
    @option_z  = @all_args[3]
    @pattern_string = String.new(all_args[4])
    @pattern_regexp = Regexp.new(/#{all_args[4]}/)
    @files_args = Array.new(all_args[5])
    @j = -1
    @array_of_lines = [[]]
  end

  def process
    read_lines_in_files

    find_and_print_lines
  end

  private

  def read_lines_from_gzipped_file(gzip_file_name)
    lines = []
    if gzip_file_name[-3..-1] == '.gz'
      Zlib::GzipReader.open(gzip_file_name) {|gz| lines = gz.readlines}
    else
      lines = File.readlines(gzip_file_name)
    end
    return lines
  end

  def read_lines_from_files_in_directory(directory_name)
    if File.directory?(directory_name)
      Find.find(directory_name) do |file_or_directory|
        if File.file?(file_or_directory)
          @j += 1
          @array_of_lines[@j] = File.readlines(file_or_directory)
        end
      end
    else
      @j += 1
      @array_of_lines[@j] = File.readlines(directory_name)
    end
  end

  def read_lines_from_files_in_directory_with_gzipped_files(directory_name)
    if File.directory?(directory_name)
      Find.find(directory_name) do |file_or_directory|
        if File.file?(file_or_directory)
          @j += 1
          @array_of_lines[@j] = read_lines_from_gzipped_file(file_or_directory)
        end
      end
    else
      @j += 1
      @array_of_lines[@j] = read_lines_from_gzipped_file(directory_name)
    end
  end

  def read_lines_in_files
    0.upto(@files_args.length - 1) do |i|
      if @option_r == false
        @j += 1
        if @option_z == false
          @array_of_lines[@j] = File.readlines(@files_args[i])
        else
          @array_of_lines[@j] = read_lines_from_gzipped_file(@files_args[i])
        end
      elsif @option_z == false
        read_lines_from_files_in_directory(@files_args[i])
      elsif @option_z == true
        read_lines_from_files_in_directory_with_gzipped_files(@files_args[i])
      end
    end
  end

  def find_and_print_lines
    0.upto(@array_of_lines.length-1) do |i|
      0.upto(@array_of_lines[i].length-1) do |j|
        if (j != 0) && ( (@option_A3 == true &&
           ( (@option_e == false && @array_of_lines[i][j].match(@pattern_string.strip)) ||
             (@option_e == true  && @pattern_regexp.match(@array_of_lines[i][j]))) ) )
          puts @array_of_lines[i][j - 1]
        end

        if (@option_e == false && @array_of_lines[i][j].match(@pattern_string.strip)) ||
           (@option_e == true  && @pattern_regexp.match(@array_of_lines[i][j]))
          puts @array_of_lines[i][j]
        end

        if (j != @array_of_lines[i].length - 1) && ( (@option_A3 == true &&
           ( (@option_e == false && @array_of_lines[i][j].match(@pattern_string.strip)) ||
             (@option_e == true  && @pattern_regexp.match(@array_of_lines[i][j]))) ) )
          puts @array_of_lines[i][j + 1]
        end
      end
    end
  end
end
