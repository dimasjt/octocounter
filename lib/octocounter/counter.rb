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
        content = File.open(item[:file]).read.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')[0..100]
        [item[:files], content, item[:count]]
      end
      puts Terminal::Table.new headings: ["Files", "Content", "Count"], rows: rows, style: { all_separators: true }
    end
  end
end
