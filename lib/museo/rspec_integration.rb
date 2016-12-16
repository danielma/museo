module Museo
  module RSpecIntegration
    include TestIntegration

    def self.included(base)
      base.render_views
      base.extend(ClassMethods)
    end

    module ClassMethods
      def snapshot(description)
        it "matches snapshot: #{description}" do |example|
          begin
            _museo_setup

            instance_exec(example, &Proc.new)

            expect_matching_snapshot(example)
          ensure
            _museo_teardown
          end
        end
      end
    end

    def expect_matching_snapshot(example)
      snapshot = Snapshot::Rspec.new(self, example.metadata)
      response_body = Snapshot.sanitize_response(response.body)

      expect(response_body).to eq(snapshot.body), "Snapshot did not match"
    end
  end
end
