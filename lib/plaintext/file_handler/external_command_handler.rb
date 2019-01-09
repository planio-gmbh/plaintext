# frozen_string_literal: true

require 'pathname'

module Plaintext
  class ExternalCommandHandler < FileHandler
    # TODO: Extract this to a proper module
    # Executes the given command through IO.popen and yields an IO object
    # representing STDIN / STDOUT
    #
    # Due to how popen works the command will be executed directly without
    # involving the shell if cmd is an array.
    require 'fileutils'
    def shellout(cmd, options = {}, &block)
      mode = "r+"
      IO.popen(cmd, mode) do |io|
        io.set_encoding("ASCII-8BIT") if io.respond_to?(:set_encoding)
        io.close_write unless options[:write_stdin]
        block.call(io) if block_given?
      end
    end

    FILE_PLACEHOLDER = '__FILE__'.freeze

    def text(file, options = {})
      cmd = @command.dup
      cmd[cmd.index(FILE_PLACEHOLDER)] = Pathname(file).to_s
      shellout(cmd){ |io| read io, options[:max_size] }.to_s
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

    def read(io, max_size = nil)
      Plaintext::CodesetUtil.to_utf8 io.read(max_size), "ASCII-8BIT"
    end
  end
end
