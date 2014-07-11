var __hasProp = {}.hasOwnProperty;

if (window._gsQueue == null) {
  window._gsQueue = [];
}

window._gsQueue.push(function() {
  return window._gsDefine.plugin({
    propName: 'state',
    API: 2,
    version: '1.0.0',
    init: function(target, value, tween) {
      var p, start;
      if (typeof target.setState !== 'function') {
        return false;
      }
      this._target = target;
      this._proxy = {};
      for (p in value) {
        if (!__hasProp.call(value, p)) continue;
        this._proxy[p] = start = target.state[p];
        this._addTween(this._proxy, p, start, value[p], p);
      }
      return true;
    },
    set: function(ratio) {
      this._super.setRatio.call(this, ratio);
      return this._target.setState(this._proxy);
    }
  });
});

if (window._gsDefine) {
  window._gsQueue.pop()();
}
