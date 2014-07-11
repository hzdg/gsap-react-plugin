GSAP React Plugin
=================

A [GSAP] plugin for tweening [React.js] component state.

This plugin will handle tweening values on a prop called `state`. If the tween
target does not have a `setState` method, the plugin will not initialize.


Usage
-----

```javascript
React.createClass({
    getInitialState: function() {
        return {width: 0};
    },
    componentDidMount: function() {
        TweenLite.to(this, 1, {state: {width: 100}});
    },
    render: function() {
        return <div style={{width: this.state.width}}>Hello World!</div>
    }
});
```

[GSAP]: http://www.greensock.com/gsap-js/
[React.js]: http://facebook.github.io/react/
