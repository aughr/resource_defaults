module ResourceDefaults
  class Railtie < Rails::Railtie
    initializer 'resource_defaults.load', :before => 'action_dispatch.prepare_dispatcher' do
      ActionDispatch::Routing::Mapper.send :include, ResourceDefaults
    end
  end

  def initialize(*args)
    super
    @scope[:resource_defaults] = {}
    @scope[:resource_defaults_in_progress] = []
  end

  def resource_defaults(*args, &block)
    options = args.extract_options!
    target = args.first
    raise ArgumentError, 'must provide a resource to apply default actions' if target.blank?
    @scope[:resource_defaults][target] = options.merge(:block => block)
  end

  def scope(*args)
    old_resource_defaults = @scope[:resource_defaults].dup
    super
  ensure
    @scope[:resource_defaults] = old_resource_defaults
  end

  private

  def apply_common_behavior_for(method, resources, options, &block)
    return true if super

    resource = resources.first
    if !@scope[:resource_defaults_in_progress].include?(resource) && @scope[:resource_defaults][resource]
      defaults = @scope[:resource_defaults][resource].dup
      scope :resource_defaults_in_progress => resource do
        default_block = defaults.delete(:block)
        send method, resource, options do
          instance_exec &default_block if default_block
          instance_exec &block if block
        end
      end
      return true
    end

    false
  end

  def merge_resource_defaults_in_progress_scope(parent, child)
    (parent || []) + [child]
  end
end
