require "commander"
require "fileutils"

require "octocounter/version"
require "octocounter/counter"

PATH_ARG = "
  Usage:
    octocounter path/to/directory
"

DESCRIPTION = "List files in directories to get count with same content"

module Octocounter
  class CommandBuilder
    include Commander::Methods

    def run
      program :name, "Octocounter"
      program :version, Octocounter::VERSION
      program :description, DESCRIPTION

      default_command :run

      command :run do |c|
        c.syntax = "octocounter path/to/directory"
        c.description = DESCRIPTION
        c.action do |args|
          path = args.shift || abort(PATH_ARG)

          counter = Octocounter::Counter.new(path)

          counter.print_to_screen
        end
      end

      run!
    end
  end
end
