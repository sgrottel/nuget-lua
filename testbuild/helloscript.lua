-- Sample from
-- http://www.troubleshooters.com/codecorn/lua/lua_c_calls_lua.htm

--io.write("This is coming from lua.\n")

function tellme()
	io.write("This is coming from lua.tellme.\n")
end

function tellthat(word)
	io.write("This is from lua.tellthat, telling ")
	io.write(tostring(word))
	io.write("\n")
	chost.call(word)
end


io.write("Start\n")
mo = MyObject.new()
io.write("mo = ", mo:get(), "\n")
mo:set(12)
io.write("mo = ", mo:get(), "\n")
print(mo)
mo = MyObject.new()

collectgarbage()

io.write("mo = ", mo:get(), "\n")
print(mo)

