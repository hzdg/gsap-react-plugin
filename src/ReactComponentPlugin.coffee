# A GSAP plugin for tweening React.js component state.
#
# This plugin will handle tweening values on a prop called `state`. If the tween
# target does not have a `setState` method, the plugin will not initialize.
#
# Example usage:
#
#   React.createClass({
#     getInitialState: function() {
#       return {width: 0};
#     },
#     componentDidMount: function() {
#       TweenLite.to(this, 1, {state: {width: 100}});
#     },
#     render: function() {
#       return <div style={{width: this.state.width}}>Hello World!</div>
#     }
#   });
window._gsQueue ?= []
window._gsQueue.push ->
  window._gsDefine.plugin
    propName: 'state'
    API: 2
    version: '1.0.0'
    init: (target, value, tween) ->
      # If the target doesn't look like a React component, don't initialize.
      return false unless typeof target.setState is 'function'
      # Keep a reference to the target so we can call `setState()` on update.
      @_target = target
      # We tween a proxy so that multiple tweens on the same target can
      # change state props independently of the React render loop.
      @_proxy = target._tweenState ?= {}
      # Store start and end values.
      [@_start, @_end] = [{}, {}]
      # For each state prop being tweened...
      for own p of value
        # Populate the proxy, start and end stores.
        @_end[p] = end = value[p]
        @_start[p] = start = @_proxy[p] ? @_proxy[p] = target.state?[p] ? end
        # Add a tween to the proxy for this prop.
        @_addTween @_proxy, p, start, end, p
      true
    set: (ratio) ->
      # Call super set to make sure the proxy tweens are updated.
      @_super.setRatio.call this, ratio
      # Call `setState()` on our target component.
      @_target.setState switch ratio
        when 0 then @_start
        when 1 then @_end
        else @_proxy

if window._gsDefine then window._gsQueue.pop()()
