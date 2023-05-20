local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet

-- Snippets for all languages

ls.add_snippets("all", {
	s({
    trig = "ternary",
    docstring = "Ternary operator",
  },
  {
		i(1, "cond"), t(" ? "), i(2, "then"), t(" : "), i(3, "else")
	})
})

ls.add_snippets("all", {
	s({
    trig = "if",
    docstring = "if statement"
  }, {
		t("if ("), i(1, "condition"), t({") {", "  "}),
    i(2, {"// Do something"}),
    t({ "", "}" }),
	})
})

ls.add_snippets("all", {
	s({
   trig = "else",
   docstring = "else statement"
  }, {
		t("else ("), i(1, "condition"), t({") {", "  "}),
    i(2, {"// Do something"}),
    t({ "", "}" }),
	})
})

ls.add_snippets("all", {
	s({
   trig = "else if",
   docstring = "else if statement"
  }, {
		t("else if ("), i(1, "condition"), t({") {", "  "}),
    i(2, {"// Do something"}),
    t({ "", "}" }),
	})
})

-- Snippets for JavaScript, TypeScript, Jsx and Tsx 

for index, value in ipairs({"javascript", "javascriptreact", "typescript", "typescriptreact"}) do
  ls.add_snippets(value, {
    s({
      trig = "jest:test",
      docstring = "Generates an \"it\" block for Jest test"
    }, {
      t("it('"), i(1, "should be able to do something"), t({"', async () => {", "  "}),
      i(2, {"// Do something"}),
      t({ "", "})" }),
    })
  })

  ls.add_snippets(value, {
    s({
      trig = "jest:describe",
      docstring = "Generates an \"describe\" block for Jest test"
    }, {
      t("describe('"), i(1, "My test"), t({"', () => {", "  "}),
      i(2, {"// Do something"}),
      t({ "", "})" }),
    })
  })

  ls.add_snippets(value, {
    s({
      trig = "jest:beforeAll",
      docstring = "Generates an \"beforeAll\" block for Jest test"
    }, {
      t("beforeAll("), t({"async () => {", "  "}),
      i(1, {"// Do something"}),
      t({ "", "})" }),
    })
  })

  ls.add_snippets(value, {
    s({
      trig = "jest:beforeEach",
      docstring = "Generates an \"beforeEach\" block for Jest test"
    }, {
      t("beforeEach("), t({"async () => {", "  "}),
      i(1, {"// Do something"}),
      t({ "", "})" }),
    })
  })

  ls.add_snippets(value, {
    s({
      trig = "jest:afterAll",
      docstring = "Generates an \"afterAll\" block for Jest test"
    }, {
      t("afterAll("), t({"async () => {", "  "}),
      i(1, {"// Do something"}),
      t({ "", "})" }),
    })
  })

  ls.add_snippets(value, {
    s({
      trig = "jest:afterEach",
      docstring = "Generates an \"afterEach\" block for Jest test"
    }, {
      t("afterEach("), t({"async () => {", "  "}),
      i(1, {"// Do something"}),
      t({ "", "})" }),
    })
  })

  ls.add_snippets(value, {
    s({
      trig = "try/catch",
      docstring = "Generates an try/catch"
    }, {
      t({"try {", " "}),
      i(1, {"// Do something"}),
      t({ "", "} catch (err) {", " " }),
      i(2, {"// Do something"}),
      t({ "", "}" }),
    })
  })

  ls.add_snippets(value, {
    s({
      trig = "js:function",
      docstring = "Generates an default JavaScript function"
    }, {
      t("function "), i(1, "name"), t("("), i(2), t({") {", "  "}),
      i(3, {"// Do something"}),
      t({ "", "}" }),
    })
  })

  ls.add_snippets(value, {
    s({
      trig = "js:asyncFunction",
      docstring = "Generates an default async JavaScript function"
    }, {
      t("async function "), i(1, "name"), t("("), i(2), t({") {", "  "}),
      i(3, {"// Do something"}),
      t({ "", "}" }),
    })
  })

  ls.add_snippets(value, {
    s({
      trig = "js:arrowFunction",
      docstring = "Generates an JavaScript arrow function"
    }, {
      t("const "), i(1, "name"), t({ " = (" }), i(2), t({") => {", "  "}),
      i(3, {"// Do something"}),
      t({ "", "}" }),
    })
  })

  ls.add_snippets(value, {
    s({
      trig = "js:asyncArrowFunction",
      docstring = "Generates an JavaScript async arrow function"
    }, {
      t("const "), i(1, "name"), t({ " = async (" }), i(2), t({") => {", "  "}),
      i(3, {"// Do something"}),
      t({ "", "}" }),
    })
  })

  ls.add_snippets(value, {
    s({
      trig = "js:callback",
      docstring = "Generates an JavaScript callback function"
    }, {
      t({ "(" }), i(1), t({") => {", "  "}),
      i(2, {"// Do something"}),
      t({ "", "}" }),
    })
  })

  ls.add_snippets(value, {
    s({
      trig = "js:asyncCallback",
      docstring = "Generates an JavaScript async callback function"
    }, {
      t({ "async (" }), i(1), t({") => {", "  "}),
      i(2, {"// Do something"}),
      t({ "", "}" }),
    })
  })

  ls.add_snippets(value, {
    s({
      trig = "ts:import",
      docstring = "TypeScript import statement",
    },
    {
      t("import {"), i(2), t("} from '"), i(1), t("'"),
    })
  })
  
  ls.add_snippets(value, {
    s({
      trig = "js:console.dir",
      docstring = "JavaScript console.dir() function",
    },
    {
      t("console.dir({ "), i(1), t(" }, { depth: null })"),
    })
  })
end
