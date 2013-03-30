#include "LuaTable.h"

std::vector<LuaTable> LuaTable::SubVector() const {
	std::vector<LuaTable> ret;
	lua_len(m_lua, m_index);
	int len = lua_tointeger(m_lua, -1);
	lua_pop(m_lua, 1);
	ret.reserve(len);
	for(int i = 1; i <= len; ++i) {
		LuaTable val;
		lua_rawgeti(m_lua, m_index, i);
		if (pi_lua_strict_pull(m_lua, -1, val))
			ret.push_back(val);
	}
    return ret;
}
