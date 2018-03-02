# frozen_string_literal: true

module Capybara
  module Node
    module Pluginify
      def self.prepended(mod)
        mod.public_instance_methods.each do |method_name|
          define_method method_name do |*args, using: nil, **options|
            if using
              plugin = Capybara.plugins[using]
              raise ArgumentError, "Plugin not loaded: #{using}" unless plugin
              raise NoMethodError, "Action not implemented in plugin: #{using}:#{method_name}" unless plugin.respond_to?(method_name)
              plugin.send(method_name, self, *args, **options)
            else
              super(*args, **options)
            end
          end
        end
      end
    end
  end
end
