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
      var end, p, start, _ref, _ref1, _ref2, _ref3;
      if (typeof target.setState !== 'function') {
        return false;
      }
      this._target = target;
      this._proxy = target._tweenState != null ? target._tweenState : target._tweenState = {};
      _ref = [{}, {}], this._start = _ref[0], this._end = _ref[1];
      for (p in value) {
        if (!__hasProp.call(value, p)) continue;
        this._end[p] = end = value[p];
        this._start[p] = start = (_ref1 = this._proxy[p]) != null ? _ref1 : this._proxy[p] = (_ref2 = (_ref3 = target.state) != null ? _ref3[p] : void 0) != null ? _ref2 : end;
        this._addTween(this._proxy, p, start, end, p);
      }
      return true;
    },
    set: function(ratio) {
      this._super.setRatio.call(this, ratio);
      return this._target.setState((function() {
        switch (ratio) {
          case 0:
            return this._start;
          case 1:
            return this._end;
          default:
            return this._proxy;
        }
      }).call(this));
    }
  });
});

if (window._gsDefine) {
  window._gsQueue.pop()();
}
