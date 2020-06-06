-- Sample from
-- http://www.troubleshooters.com/codecorn/lua/lua_c_calls_lua.htm

io.write("This is coming from lua.\n")

function tellme()
	io.write("This is coming from lua.tellme.\n")
end

function tellthat(word)
	io.write("This is from lua.tellthat, telling ")
	io.write(tostring(word))
	io.write("\n")
	chost.call(word)
end
