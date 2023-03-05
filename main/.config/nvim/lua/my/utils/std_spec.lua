local M = require 'my.utils.std'

describe('should merge recursively', function()
  it('description', function()
    assert.are.same(
      { a = { b = 2, c = 3 } },
      M.deep_merge({ a = { b = 2 } }, { a = { c = 3 } })
    )
  end)
end)

describe('should concatenate arrays', function()
  it('description', function()
    assert.are.same(
      { a = { 5, 6, 7, 8 } },
      M.deep_merge({ a = { 5, 6 } }, { a = { 7, 8 } })
    )
  end)
end)
