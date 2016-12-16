module Minitest
  def self.plugin_museo_options(opts, options)
    opts.on "--museo=PATTERN", "Museo" do |matcher|
      options[:museo] = matcher
      options[:filter] = "/^test_snapshot/"
    end
  end

  def self.plugin_museo_init(options)
    reporter.reporters = [MuseoSnapshotReporter.new(options)] if options[:museo]
  end

  class MuseoSnapshotReporter < AbstractReporter
    attr_accessor :results, :matcher

    class << self
      attr_accessor :matcher, :active

      @active = false

      def pattern_match(test_case)
        current_pattern = Museo.clean_name(test_case.class.to_s)

        matcher.each.with_index.all? do |part, index|
          current_pattern[index] == part
        end
      end
    end

    def initialize(options)
      self.class.matcher = Museo.clean_name(options[:museo])
      self.class.active = true
      @results = []
    end

    def record(result)
      @results << result unless result.passed? || result.skipped?
    end

    def report
      @results.each do |result|
        puts result
      end
    end
  end
end
