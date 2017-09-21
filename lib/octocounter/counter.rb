require "terminal-table"

module Octocounter
  class Counter
    include Commander::Methods

    REGEX_PATH = %r{/\/$/}

    attr_reader :path, :list, :all

    def initialize(path, all)
      path = "#{path}/" unless path =~ REGEX_PATH
      @path = path
      @list = []
      @all = all
      initialize_log
    end

    def calculate
      Dir.glob(path + "**/*").select { |f| File.file?(f) }.each do |file|
        # file_path = File.path(file)

        if matched = matched?(file)
          modify_item(matched: matched)
          # matched[:count] += 1
          # matched[:files] = "#{matched[:files]}\n#{file_path}"
        else
          add_item(file: file, count: 1)
          # list.push(files: file_path, file: file, count: 1)
        end
      end
      # list
    end

    def print_to_screen
      # rows =
      #   if all
      #     calculate.map do |item|
      #       [item[:files], content(item), item[:count]]
      #     end
      #   else
      #     item = calculate.inject { |memo, i| memo && (memo[:count] > i[:count]) ? memo : i }
      #     [[item[:files], content(item), item[:count]]]
      #   end
      #
      # puts Terminal::Table.new headings: %w[Files Content Count], rows: rows, style: { all_separators: true }
      calculate
      puts File.read("octocounter.log")
    end

    private

    def add_item(file:, count:)
      File.open("octocounter.log", "a") do |out|
        out << "#{file}         #{count}\n"
      end
    end

    def modify_item(matched:)
      lines = File.foreach("octocounter.log").to_a

      File.open("octocounter.log", "w") do |out|
        lines.each do |line|
          parsed = matched.split(/\s{9,}/)
          file_name = parsed[0]
          reg_name = Regexp.new(Regexp.quote(file_name))
          count = parsed[1].to_i

          if line =~ reg_name
            out << "#{file_name}         #{count + 1}\n"
          else
            out << line
          end
        end
      end
    end

    def initialize_log
      FileUtils.rm("octocounter.log")
      FileUtils.touch("octocounter.log")
    end

    def matched?(file)
      File.foreach("octocounter.log").find do |line|
        parsed = line.split(/\s{9,}/)
        file_name = parsed[0]

        File.size(file) == File.size(file_name) &&
          FileUtils.compare_file(file, file_name)
      end
      # list.find do |item|
      #   File.size(file) == File.size(item[:file]) &&
      #     FileUtils.compare_file(item[:file], file)
      # end
    end

    def content(item)
      content = ""
      index = 0
      IO.foreach(item[:file]) do |line|
        content += line
        index += 1
        break if index == 10
      end
      # force encode into UTF-8
      content.encode("UTF-8", "binary", invalid: :replace, undef: :replace, replace: "")[0..50]
    end
  end
end
