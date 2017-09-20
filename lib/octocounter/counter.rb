require "terminal-table"

module Octocounter
  class Counter
    include Commander::Methods

    REGEX_PATH = %r{/\/$/}

    attr_accessor :path, :list

    def initialize(path)
      path = "#{path}/" unless path =~ REGEX_PATH
      @path = path
      @list = []
    end

    def calculate
      Dir.glob(path + "**/*").select { |f| File.file?(f) }.each do |file|
        open_file = File.open(file)
        file_path = open_file.path.sub(path, '')
        open_file.close
        if matched = matched?(file)
          matched[:count] += 1
          matched[:files] = "#{matched[:files]}\n#{file_path}"
        else
          list.push(files: file_path, file: file, count: 1)
        end
      end
      list
    end

    def matched?(file)
      list.find do |item|
        file1, file2 = [File.open(file), File.open(item[:file])]
        size1, size2 = [file1.size, file2.size]
        file1.close
        file2.close

        size1 == size2 &&
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
      content.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')[0..50]
    end

    def print_to_screen
      rows = calculate.map do |item|
        [item[:files], content(item), item[:count]]
      end
      puts Terminal::Table.new headings: ["Files", "Content", "Count"], rows: rows, style: { all_separators: true }
    end
  end
end
