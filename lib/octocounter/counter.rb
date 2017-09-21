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
    end

    def calculate
      Dir.glob(path + "**/*").select { |f| File.file?(f) }.each do |file|
        file_path = File.path(file).sub(path, "")

        if matched = matched?(file)
          matched[:count] += 1
          matched[:files] = "#{matched[:files]}\n#{file_path}"
        else
          list.push(files: file_path, file: file, count: 1)
        end
      end
      list
    end

    def print_to_screen
      rows =
        if all
          calculate.map do |item|
            [item[:files], content(item), item[:count]]
          end
        else
          item = calculate.inject { |memo, i| memo && (memo[:count] > i[:count]) ? memo : i }
          [[item[:files], content(item), item[:count]]]
        end

      puts Terminal::Table.new headings: %w[Files Content Count], rows: rows, style: { all_separators: true }
    end

    private

    def matched?(file)
      list.find do |item|
        File.size(file) == File.size(item[:file]) &&
          FileUtils.compare_file(item[:file], file)
      end
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
