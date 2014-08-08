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
    version: '1.0.2'
    init: (target, value, tween) ->
      # If the target doesn't look like a React component, don't initialize.
      return false unless typeof target.setState is 'function'
      # We create a synchronous state proxy (if it doesn't already exist) so
      # that multiple tweens on the same target can change state props
      # independently of the React render loop.
      target._tweenState ?= {}
      # We tween an internal proxy for state and synchronize its values with the
      # shared state (target._tweenState and target.state) on update.
      @_tween = {}
      # For each state prop being tweened...
      for own p of value
        # Figure out the start and end values.
        end = value[p]
        start = target.state?[p] ? target._tweenState[p] ? end
        # Add a tween for this prop.
        @_tween[p] = start
        @_addTween @_tween, p, start, end, p
      # Keep a reference to the target so we can call `setState()` on update.
      @_target = target
      true
    set: (ratio) ->
      # Call super set to make sure the internal proxy tweens update.
      @_super.setRatio.call this, ratio
      # Update our shared synchronous state proxy on our target component.
      @_target._tweenState[k] = v for k, v of @_tween
      # Call `setState()` on our target component.
      @_target.setState @_tween

if window._gsDefine then window._gsQueue.pop()()

globals = -> (window.GreenSockGlobals || window)
getTweenClass = ->
  {TweenMax, TweenLite} = globals()
  TweenMax or TweenLite
getTimelineClass = ->
  {TimelineMax, TimelineLite} = globals()
  TimelineMax or TimelineLite

mod =
  TweenMixin:
    createTimeline: (args...) ->
      cls = getTimelineClass()
      new cls args...
    createTween: (args...) ->
      cls = getTweenClass()
      new cls args...
    tweenTo: (args...) -> getTweenClass().to this, args...; this
    tweenFrom: (args...) -> getTweenClass().from this, args...; this
    tweenFromTo: (args...) -> getTweenClass().fromTo this, args...; this
    componentWillUnmount: -> getTweenClass().killTweensOf this; this

if typeof define is 'function' and define.amd
  define => @gsapReactPlugin = mod
else if typeof module is 'object' and module.exports
  module.exports = mod
else
  @gsapReactPlugin = mod
