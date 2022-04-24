---@diagnostic disable: undefined-global

local quote_char = "'"

local function concat(t1, t2)
	for i = 1, #t2 do
		t1[#t1 + 1] = t2[i]
	end
	return t1
end

local function test(s)
	local res = {
		t({ "test(" .. quote_char }),
		i(1, "description"),
		t({ quote_char .. ") => {" }),
	}
	concat(res, s)
	concat(res, { t("}") })
	return res
end

return {
	s({ trig = "f" }, {
		t("("),
		i(2),
		t(") => "),
		i(3),
	}),
	-- s({ trig = 'function' }, {
	--   t 'function ',
	--   i(1, 'name'),
	--   t '(',
	--   i(2),
	--   t ') {',
	--   t { '', '  ' },
	--   i(3),
	--   t { '', '}', '' },
	-- }),

	s({ trig = "i" }, {
		t("if ("),
		i(1, "false"),
		t({ ") {", "\t " }),
		i(2, "// block"),
		t({ "", "}" }),
	}),
	s({ trig = "k" }, {
		i(1, "name"),
		t("("),
		i(2),
		t(")"),
	}),
	s({ trig = "r" }, { t("return ") }),
	s({ trig = "w" }, {
		t("while ("),
		i(1, "true"),
		t({ ") {", "\t" }),
		i(2, "// block"),
		t({ "", "}" }),
	}),
	-- FIXME: indentation
	s({ trig = "e" }, {
		c(1, {
			sn(1, { t({ "} else {", "\t" }), i(1, "// block") }),
			sn(1, { t("} else if ("), i(1, "true"), t({ ") {", "\t" }), i(2, "// block") }),
		}),
	}),
	s({ trig = "else if" }, {
		c(1, {
			sn(1, { t("} else if ("), i(1, "true"), t({ ") {", "\t" }), i(2, "// block") }),
			sn(1, { t({ "} else {", "\t" }), i(1, "// block") }),
		}),
	}),
	s({
		trig = "shebang",
	}, {
		t("#!/usr/bin/env node"),
		f(function()
			vim.cmd("Chmod +x")
			return ""
		end, {}),
		t({ "", "" }),
	}),
	s({ trig = "test" }, test({ t("test") })),
}
