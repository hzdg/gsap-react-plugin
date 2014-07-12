assert = chai.assert
# A simple spy function that expects a single argument. An optional `original`
# function may be passed to the `spy` factory. Whenever the spy is called, it
# will be called with the argument passed to the spy, and its return value will
# be passed through.
spy = (original) ->
  fn = (opts) ->
    fn.calls.push opts
    original? opts
  fn.calls = []
  fn.callCount = -> fn.calls.length
  # Asserts whether or not the spy was ever called with the provided argument.
  # If it can't match the argument by value, it will attempt to compare it to
  # spy calls as an 'options' object, checking to see if any of the provided
  # options were in a set of options passed to a spy call.
  fn.calledWith = (opts) ->
    for callOpts in fn.calls
      break if match = opts is callOpts
      for opt of opts
        break if not match = opt of callOpts and opts[opt] is callOpts[opt]
    match
  fn


describe 'gsap-react-plugin', ->
  component = null

  assertStartState = (expected) ->
    assert.deepEqual component._tweenState, expected
    assert component.setState.calledWith expected

  assertEndState = (expected, done) ->
    assert.deepEqual component._tweenState, expected
    assert component.setState.calledWith expected
    done()

  beforeEach -> component = setState: spy()

  it 'calls setState on a React component', (done) ->
    TweenLite.set component, state: test: 1
    assertEndState test: 1, done

  it 'uses current state as initial value', (done) ->
    component.state = test: 0
    TweenLite.to component, 0.01,
      state: {test: 1}
      immediateRender: true
      onStart: -> assertStartState test: 0
      onComplete: -> assertEndState test: 1, done

  it 'tweens from a state to a state', (done) ->
    TweenLite.fromTo component, 0.01, {state: test: 0},
      state: {test: 1}
      onStart: -> assertStartState test: 0
      onComplete: -> assertEndState test: 1, done
