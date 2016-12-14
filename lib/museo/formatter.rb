module Museo
  class Formatter
    def initialize(options = {})
      @indent = options.delete(:indent) || "  ".freeze
    end

    def format(object, indent_level = 0)
      case object
      when Hash
        format_hash(object, indent_level)
      when Array
        format_array(object, indent_level)
      else
        format_value(object)
      end
    end

    private

    attr_reader :indent

    def format_hash(hash, indent_level)
      [
        "{",
        hash.map do |key, value|
          "#{indent * (indent_level + 1)}#{format(key)} => #{format(value, indent_level + 1)},"
        end,
        "#{indent * indent_level}}",
      ].join("\n")
    end

    def format_array(array, indent_level)
      [
        "[",
        array.map do |value|
          "#{indent * (indent_level + 1)}#{format(value, indent_level + 1)},"
        end,
        "#{indent * indent_level}]",
      ].join("\n")
    end

    def format_value(value)
      case value
      when Symbol
        value.inspect
      else
        value.to_s
      end
    end
  end
end
