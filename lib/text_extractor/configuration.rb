module TextExtractor
  module Configuration
    @@config = nil

    class << self
      # Returns a configuration setting
      def [](name)
        load unless @@config
        @@config[name]
      end

      def load
        @@config = {}
        if Rails
          filename = File.join([Rails.root.to_s, 'config', 'text_extractor.yml'])
          if File.file?(filename)
            file_config = YAML::load(ERB.new(File.read(filename)).result)
            if file_config.is_a? Hash
              @@config = file_config
            else
              warn "#{filename} is not a valid TextExtractor configuration file, ignoring."
            end
          end
        end
      end
    end
  end
end