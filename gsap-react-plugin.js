var __hasProp = {}.hasOwnProperty;

if (window._gsQueue == null) {
  window._gsQueue = [];
}

window._gsQueue.push(function() {
  return window._gsDefine.plugin({
    propName: 'state',
    API: 2,
    version: '1.0.2',
    init: function(target, value, tween) {
      var end, p, start, _ref, _ref1, _ref2;
      if (typeof target.setState !== 'function') {
        return false;
      }
      if (target._tweenState == null) {
        target._tweenState = {};
      }
      this._tween = {};
      for (p in value) {
        if (!__hasProp.call(value, p)) continue;
        end = value[p];
        start = (_ref = (_ref1 = (_ref2 = target.state) != null ? _ref2[p] : void 0) != null ? _ref1 : target._tweenState[p]) != null ? _ref : end;
        this._tween[p] = start;
        this._addTween(this._tween, p, start, end, p);
      }
      this._target = target;
      return true;
    },
    set: function(ratio) {
      var k, v, _ref;
      this._super.setRatio.call(this, ratio);
      _ref = this._tween;
      for (k in _ref) {
        v = _ref[k];
        this._target._tweenState[k] = v;
      }
      return this._target.setState(this._tween);
    }
  });
});

if (window._gsDefine) {
  window._gsQueue.pop()();
}
