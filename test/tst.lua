M = {}
M["a"] = 1
M["b"] = "foo"
M["c"] = false
M["d"] = "ddd"

function add(a, b)
  local res = a + b
  print("[LUA]: add("..a..", "..b..") called")
  return res
end

function get_key(k)
  print("[LUA]: get_key("..k..") called")
  return M[k]
end

function call_host(a, b)
  print("[LUA]: call_host("..a..", "..b..") called")
  local res = hostfunc(a, b)
  print("[LUA]: => " .. res)
  return res
end
