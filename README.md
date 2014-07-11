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


Installation
------------

- Via [npm]: `npm install gsap-react-plugin`
- Via [bower]: `bower install gsap-react-plugin`
- Via file > save as: [gsap-react-plugin.js]

[GSAP]: http://www.greensock.com/gsap-js/
[React.js]: http://facebook.github.io/react/
[npm]: http://npmjs.org
[bower]: http://bower.io
[gsap-react-plugin.js]: https://raw.githubusercontent.com/hzdg/gsap-react-plugin/master/gsap-react-plugin.js
