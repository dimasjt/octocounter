require "commander"
require "fileutils"

require "octocounter/version"
require "octocounter/counter"

module Octocounter
  class CommandBuilder
    include Commander::Methods

    def run
      program :name, "octocounter"
      program :version, Octocounter::VERSION
      program :description, "Counter"

      default_command :run

      command :run do |c|
        c.action do |args|
          path = args.shift || abort("path directory required")

          counter = Octocounter::Counter.new(path)

          counter.print_to_screen
        end
      end

      run!
    end
  end
end
