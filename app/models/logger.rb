module Intrigue
  module Model
    class Logger
      include DataMapper::Resource

      property :id, Serial, :key => true
      property :full_log, Text, :length => 50000000, :default => ""
      belongs_to :project, :default => lambda { |r, p| Intrigue::Model::Project.first }

      def self.scope_by_project(name)
        all(:project => Intrigue::Model::Project.first(:name => name))
      end

      def log(message)
        _log "[#{@id}][ ] " << message
      end

      def log_debug(message)
        _log "[#{@id}][D] " << message
      end

      def log_good(message)
        _log "[#{@id}][+] " << message
      end

      def log_error(message)
        _log "[#{@id}][E] " << message
      end

      def log_warning(message)
        _log "[#{@id}][W] " << message
      end

      def log_fatal(message)
        _log "[#{@id}][F] " << message
      end

    private

      def _log(message)
        encoded_message = _encode_string(message)
        attribute_set(:full_log, "#{@full_log}\n#{encoded_message}")
      end

      def _encode_string(string)
        string.encode("UTF-8", :undef => :replace, :invalid => :replace, :replace => "?")
      end

    end
end
end
