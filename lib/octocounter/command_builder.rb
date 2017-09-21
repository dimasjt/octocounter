require "octocounter/version"
require "octocounter/counter"

module Octocounter
  class CommandBuilder
    include Commander::Methods

    PATH_ARG = "
      Usage:
        octocounter path/to/directory
    "
    DESCRIPTION = "List files in directories to get count with same content"

    def run
      program :name, "Octocounter"
      program :version, Octocounter::VERSION
      program :description, DESCRIPTION

      default_command :run

      command :run do |c|
        c.syntax = "octocounter path/to/directory"
        c.description = DESCRIPTION
        c.option "--all", String, "Show all list"
        c.action do |args, options|
          path = args.shift || abort(PATH_ARG)

          counter = Octocounter::Counter.new(path, options.all)

          counter.print_to_screen
        end
      end

      run!
    end
  end
end
