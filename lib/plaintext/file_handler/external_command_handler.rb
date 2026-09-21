# frozen_string_literal: true

require 'pathname'

module Plaintext
  # Raised when an extraction command exits with a non-zero status. Whatever
  # the command wrote to STDOUT before failing is discarded.
  class CommandFailed < StandardError; end

  class ExternalCommandHandler < FileHandler
    # TODO: Extract this to a proper module
    # Executes the given command through IO.popen and yields an IO object
    # representing STDIN / STDOUT
    #
    # Due to how popen works the command will be executed directly without
    # involving the shell if cmd is an array.
    require 'fileutils'

    FILE_PLACEHOLDER = '__FILE__'.freeze

    def shellout(cmd, options = {}, &block)
      mode = "r+"
      result = IO.popen(cmd, mode) do |io|
        io.binmode
        io.close_write unless options[:write_stdin]
        block.call(io) if block_given?
      end
      raise CommandFailed, "#{cmd.join(' ')} failed: #{$?}" unless $?.success?
      result
    end

    def text(file, options = {})
      cmd = @command.dup
      cmd[cmd.index(FILE_PLACEHOLDER)] = Pathname(file).to_s
      shellout(cmd) { |io| read io, options[:max_size] }.to_s
    end


    def accept?(content_type)
      super and available?
    end

    def available?
      @command.present? and File.executable?(@command[0])
    end

    def self.available?
      new.available?
    end

    private

    # Encoding the command writes its output in. Commands that can be told to
    # produce UTF-8 are configured to do so (see plaintext.yml.example), the
    # output of those that cannot is converted by #read.
    def output_encoding
      'UTF-8'
    end

    def read(io, max_size = nil)
      Plaintext::CodesetUtil.to_utf8 io.read(max_size), output_encoding
    end
  end
end
