---@diagnostic disable: undefined-global

local M = {}
--[[
      "describe('$1', () => {",
      "\tit('renders correctly', () => {",
      "\t\tconst tree = renderer.create(<$2 />).toJSON();",
      "\t\texpect(tree).toMatchSnapshot();",
      "\t});",
      "});"
]]

local quote_char = "'"

table.insert(
	M,
	s("__ test snapshot", {
		c(1, {
			sn(nil, {
				t("describe(") .. quote_char,
				t({ quote_char .. ", () => {" }),
				t("<"),
				r(1, "tag"),
				t(" "),
				r(2, "attrs"),
				t(" />"),
			}),
			sn(nil, {
				t("<"),
				r(1, "tag"),
				t(" "),
				r(2, "attrs"),
				t(" >"),
				r(3, "children"),
				t("</"),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				t(">"),
			}),
		}),
	}, {
		stored = {
			tag = i(1, "tag"),
			attrs = i(1, ""),
			children = i(1, ""), -- probably useless
		},
	})
)

table.insert(M, s("__ test snapshot", {}))

local function quote(str)
	return quote_char .. str .. quote_char
end

table.insert(
	M,
	s("__ test snapshot", {
		t({ "describe(" .. quote_char }),
		i(1, "description"),
		t({ quote_char .. ", () => {" }),
		t({ "\tit(" .. quote_char }),
		i(2, "description"),
		t({ quote_char .. ", () => {" }),
		c(1, {
			sn(nil, {
				t("<"),
				r(1, "tag"),
				t(" "),
				r(2, "attrs"),
				t(" />"),
			}),
			sn(nil, {
				t("<"),
				r(1, "tag"),
				t(" "),
				r(2, "attrs"),
				t(" >"),
				r(3, "children"),
				t("</"),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				t(">"),
			}),
		}),
		t("}"),
		t("}"),
	}, {
		stored = {
			tag = i(1, "tag"),
			attrs = i(1, ""),
			children = i(1, ""), -- probably useless
		},
	})
)

return M
