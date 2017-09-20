require "terminal-table"

module Octocounter
  class Counter
    include Commander::Methods
    attr_accessor :path

    def initialize(path)
      path = "#{path}/" unless path.match(/\/$/)
      @path = path
    end

    def calculate
      list = []
      Dir.glob(path + "**/*").select { |f| File.file?(f) }.each do |file|
        if matched = list.find { |item| FileUtils.compare_file(item[:file], file) }
          matched[:count] += 1
          matched[:files] = "#{matched[:files]}\n#{File.open(file).path}"
        else
          list.push(files: File.open(file).path, file: file, count: 1)
        end
      end
      list
    end

    def print_to_screen
      rows = calculate.map do |item|
        [item[:files], File.open(item[:file]).read[1..100], item[:count]]
      end
      puts Terminal::Table.new headings: ["Files", "Content", "Count"], rows: rows, style: { all_separators: true }
    end
  end
end
