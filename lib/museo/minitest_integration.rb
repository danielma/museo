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

            if Minitest::MuseoSnapshotReporter.active
              if Minitest::MuseoSnapshotReporter.pattern_match(self)
                update_snapshot
              else
                pass
              end
            else
              assert_snapshot
            end
          ensure
            _museo_teardown
          end
        end
      end
    end

    def update_snapshot
      Snapshot::Minitest.new(self).update
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
