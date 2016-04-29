-- Sample from
-- http://www.troubleshooters.com/codecorn/lua/lua_c_calls_lua.htm

io.write("This is coming from lua.\n")

function tellme()
	io.write("This is coming from lua.tellme.\n")
end
