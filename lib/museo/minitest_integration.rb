module Museo
  module MinitestIntegration
    include TestIntegration

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def snapshot(description)
        test "snapshot: #{description}" do
          begin
            _museo_setup

            instance_eval(&Proc.new)

            assert_snapshot
          ensure
            _museo_teardown
          end
        end
      end
    end

    def assert_snapshot
      assert_equal(
        Snapshot::Minitest.new(self).body,
        Snapshot.sanitize_response(response.body),
        "Snapshot did not match",
      )
    end
  end
end
