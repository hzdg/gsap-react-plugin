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
      # We actually tween properties on a proxy for component state.
      @_proxy = {}
      # For each state prop being tweened...
      for own p of value
        # Populate our proxy object with the initial value for this state prop.
        @_proxy[p] = start = target.state[p]
        # Create a tween on our proxy for this state prop.
        @_addTween @_proxy, p, start, value[p], p
      true
    set: (ratio) ->
      # Call the super set to make sure our proxy tweens update.
      @_super.setRatio.call this, ratio
      # Call `setState()` on our target component.
      @_target.setState @_proxy

if window._gsDefine then window._gsQueue.pop()()
