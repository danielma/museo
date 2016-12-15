module Museo
  class Snapshot
    class Minitest < Snapshot
      def initialize(test_case)
        super(
          klass: test_case.class,
          test_name: test_case.name,
          response: test_case.response,
        )
      end
    end
  end
end
