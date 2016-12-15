module Museo
  class Snapshot
    class Rspec < Snapshot
      def initialize(example, metadata)
        super(
          klass: metadata[:described_class],
          test_name: metadata[:description],
          response: example.response,
        )
      end
    end
  end
end
