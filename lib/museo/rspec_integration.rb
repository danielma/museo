module Museo
  module RspecIntegration
    def self.included(base)
      base.render_views
      base.extend(ClassMethods)
    end

    module ClassMethods
      def snapshot(description)
        it "matches snapshot: #{description}" do |example|
          begin
            _add_snapshot_helper_methods
            _redefine_render_with_snapshot_layout

            instance_exec(example, &Proc.new)

            expect_matching_snapshot(example)
          ensure
            _remove_snapshot_helper_methods
          end
        end
      end
    end

    def expect_matching_snapshot(example)
      expect(Snapshot::Rspec.new(self, example.metadata).body).to(
        eq(Snapshot.sanitize_response(response.body)),
        "Snapshot did not match",
      )
    end

    def _add_snapshot_helper_methods
      @controller.class.helper do
        Snapshot.stubbed_methods.each do |method_name, callable|
          alias_method("_original_#{method_name}", method_name) if method_defined?(method_name)

          define_method(method_name) do |*args, &block|
            output = callable.respond_to?(:call) ? instance_exec(*args, block, &callable) : callable

            [
              "<!--",
              "Stubbed method call: #{method_name}",
              Snapshot.formatter.format(output),
              "-->",
              "",
            ].join("\n").html_safe
          end
        end
      end
    end

    def _remove_snapshot_helper_methods
      @controller.class.helper do
        Snapshot.stubbed_methods.each do |method_name, _callable|
          remove_method method_name

          if method_defined?("_original_#{method_name}")
            alias_method method_name, "_original_#{method_name}"
          end
        end
      end
    end

    def _redefine_render_with_snapshot_layout
      @controller.define_singleton_method(:render) do |*args|
        options = args.length > 1 ? args.last : {}
        super(*args[1..-2], options.merge(layout: "museo/snapshot"))
      end
    end
  end
end
