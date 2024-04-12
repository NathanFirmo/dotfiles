return {
  'L3MON4D3/LuaSnip',
  dependencies = { 'saadparwaiz1/cmp_luasnip' },

  config = function()
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
        trig = "s:ternary",
        docstring = "Ternary operator",
      },
      {
        i(1, "cond"), t(" ? "), i(2, "then"), t(" : "), i(3, "else")
      })
    })

    for index, value in ipairs({"go"}) do
      ls.add_snippets(value, {
        s({
          trig = "s:if",
          docstring = "if statement"
        }, {
          t("if "), i(1, "condition"), t({" {", "  "}),
          i(2, {"// Do something"}),
          t({ "", "}" }),
        })
      })

      ls.add_snippets(value, {
        s({
         trig = "s:else",
         docstring = "else statement"
        }, {
          t("else "), t({" {", "  "}),
          i(1, {"// Do something"}),
          t({ "", "}" }),
        })
      })

      ls.add_snippets(value, {
        s({
         trig = "s:else if",
         docstring = "else if statement"
        }, {
          t("else if "), i(1, "condition"), t({" {", "  "}),
          i(2, {"// Do something"}),
          t({ "", "}" }),
        })
      })
    end

    -- Snippets for JavaScript, TypeScript, Jsx and Tsx 

    for index, value in ipairs({"javascript", "javascriptreact", "typescript", "typescriptreact"}) do
      ls.add_snippets(value, {
        s({
          trig = "s:if",
          docstring = "if statement"
        }, {
          t("if ("), i(1, "condition"), t({") {", "  "}),
          i(2, {"// Do something"}),
          t({ "", "}" }),
        })
      })

      ls.add_snippets(value, {
        s({
         trig = "s:else",
         docstring = "else statement"
        }, {
          t("else "), t({"{", "  "}),
          i(2, {"// Do something"}),
          t({ "", "}" }),
        })
      })

      ls.add_snippets(value, {
        s({
         trig = "s:else if",
         docstring = "else if statement"
        }, {
          t("else if ("), i(1, "condition"), t({") {", "  "}),
          i(2, {"// Do something"}),
          t({ "", "}" }),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:test",
          docstring = "Generates an \"test\" block for Jest test"
        }, {
          t("test('"), i(1, "do something"), t({"', async () => {", "  "}),
          i(2, {"// Do something"}),
          t({ "", "})" }),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:test.todo",
          docstring = "Generates an \"test.todo\" block for Jest test"
        }, {
          t("test.todo('"), i(1, "do something"), t({"')"}),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:describe",
          docstring = "Generates an \"describe\" block for Jest test"
        }, {
          t("describe('"), i(1, "My test"), t({"', () => {", "  "}),
          i(2, {"// Do something"}),
          t({ "", "})" }),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:beforeAll",
          docstring = "Generates an \"beforeAll\" block for Jest test"
        }, {
          t("beforeAll("), t({"async () => {", "  "}),
          i(1, {"// Do something"}),
          t({ "", "})" }),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:beforeEach",
          docstring = "Generates an \"beforeEach\" block for Jest test"
        }, {
          t("beforeEach("), t({"async () => {", "  "}),
          i(1, {"// Do something"}),
          t({ "", "})" }),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:afterAll",
          docstring = "Generates an \"afterAll\" block for Jest test"
        }, {
          t("afterAll("), t({"async () => {", "  "}),
          i(1, {"// Do something"}),
          t({ "", "})" }),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:afterEach",
          docstring = "Generates an \"afterEach\" block for Jest test"
        }, {
          t("afterEach("), t({"async () => {", "  "}),
          i(1, {"// Do something"}),
          t({ "", "})" }),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:try/catch",
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
          trig = "s:function",
          docstring = "Generates an default JavaScript function"
        }, {
          t("function "), i(1, "name"), t("("), i(2), t({") {", "  "}),
          i(3, {"// Do something"}),
          t({ "", "}" }),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:function(async)",
          docstring = "Generates an default async JavaScript function"
        }, {
          t("async function "), i(1, "name"), t("("), i(2), t({") {", "  "}),
          i(3, {"// Do something"}),
          t({ "", "}" }),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:arrowFunction",
          docstring = "Generates an JavaScript arrow function"
        }, {
          t("const "), i(1, "name"), t({ " = (" }), i(2), t({") => {", "  "}),
          i(3, {"// Do something"}),
          t({ "", "}" }),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:arrowFunction(async)",
          docstring = "Generates an JavaScript async arrow function"
        }, {
          t("const "), i(1, "name"), t({ " = async (" }), i(2), t({") => {", "  "}),
          i(3, {"// Do something"}),
          t({ "", "}" }),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:callback",
          docstring = "Generates an JavaScript callback function"
        }, {
          t({ "(" }), i(1), t({") => {", "  "}),
          i(2, {"// Do something"}),
          t({ "", "}" }),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:callback(async)",
          docstring = "Generates an JavaScript async callback function"
        }, {
          t({ "async (" }), i(1), t({") => {", "  "}),
          i(2, {"// Do something"}),
          t({ "", "}" }),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:import",
          docstring = "TypeScript import statement",
        },
        {
          t("import {"), i(2), t("} from '"), i(1), t("'"),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:console.log",
          docstring = "JavaScript console.log() function",
        },
        {
          t("console.log("), i(1), t(")"),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:expect",
          docstring = "Creates a default expect block",
        },
        {
          t("expect(result).toEqual("), i(1), t(")"),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:anyString",
          docstring = "Expect any String",
        },
        {
          t("expect.any(String)"),
        })
      })
      
      ls.add_snippets(value, {
        s({
          trig = "s:anyNumber",
          docstring = "Expect any Number",
        },
        {
          t("expect.any(Number)"),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:anyDate",
          docstring = "Expect any Date",
        },
        {
          t("expect.any(Date)"),
        })
      })
      
      ls.add_snippets(value, {
        s({
          trig = "s:console.dir",
          docstring = "JavaScript console.dir() function",
        },
        {
          t("console.dir({ "), i(1), t(" }, { depth: null })"),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:expect.objectContaining",
          docstring = "Jest object assertion",
        },
        {
          t("expect.objectContaining("), i(1), t(")"),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:expect.arrayContaining",
          docstring = "Jest array assertion",
        },
        {
          t("expect.arrayContaining("), i(1), t(")"),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:parseISO",
          docstring = "date-fns parsing function",
        },
        {
          t("parseISO('"), i(1), t("')"),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:forof",
          docstring = "Generates an JavaScript for of loop"
        }, {
          t({ "for (const " }), i(1, "something"), t(" of "), i(2, "otherThing"), t({") {", "  "}),
          i(3, {"// Do something"}),
          t({ "", "}" }),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:forin",
          docstring = "Generates an JavaScript for in loop"
        }, {
          t({ "for (let pos" }), t(" in "), i(1, "something"), t({") {", "  "}),
          i(2, {"// Do something"}),
          t({ "", "}" }),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:forEach(short)",
          docstring = "Generates a short JavaScript forEach loop"
        }, {
          t({ "forEach((" }), i(1, "item"), t({") => "}), i(2), t(")"),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:forEach(long)",
          docstring = "Generates a long JavaScript forEach loop"
        }, {
          t({ "forEach((" }), i(1, "item"), t({") => {", "  "}),
          i(2, {"// Do something"}),
          t({ "", "})" }),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:map(short)",
          docstring = "Generates a short JavaScript map loop"
        }, {
          t({ "map((" }), i(1, "item"), t({") => "}), i(2), t(")"),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:map(long)",
          docstring = "Generates a long JavaScript map loop"
        }, {
          t({ "map((" }), i(1, "item"), t({") => {", "  "}),
          i(2, {"// Do something"}),
          t({ "", "})" }),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:find",
          docstring = "Generates an Array.find function"
        }, {
          t({ "find((" }), i(1, "item"), t({") => "}), i(2), t(")"),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:filter",
          docstring = "Generates an Array.filter function"
        }, {
          t({ "filter((" }), i(1, "item"), t({") => "}), i(2), t(")"),
        })
      })
      
      ls.add_snippets(value, {
        s({
          trig = "s:class",
          docstring = "Generates an javascript class"
        }, {
          t("class "), i(1, "name"), t({" {", "  "}),
          i(2, {"// Do something"}),
          t({ "", "}" }),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:constructor",
          docstring = "Generates a class constructor"
        }, {
          t("constructor "), t("("), i(1), t({") {", "  "}),
          i(2, {"// Do something"}),
          t({ "", "}" }),
        })
      })

      ls.add_snippets(value, {
        s({
          trig = "s:switch",
          docstring = "Generates a JavaScript switch"
        }, {
          t("switch ("), i(1, "prop"), t({") {", "  "}),
          t("case "), i(2, ""), t({":", "    "}),
          i(3, {"// Do something"}), t({"", "  "}),
          t("default:"), t({"", "    "}),
          i(4, {"// Do something"}),
          t({ "", "}" }),
        })
      })
    end
  end
}
