-- Slide classes from the UCL PowerPoint template:
--   # Heading              section divider (dark purple with stripes)
--   ## Heading             content slide (off-white)
--   ## Heading {.dark}     content slide in dark mode
--   ## Heading {.stripe}   narrow bright-purple band on the left
--   ## Heading {.divider}  divider layout at level 2
--   {.no-logo}             hide the logo
local dark_purple = "#361a54"

-- revealjs: set slide backgrounds (the CSS keys off the classes)
local function revealjs_header(el)
  if el.attributes["background-color"] then return nil end
  if el.level == 1 or el.classes:includes("dark") or el.classes:includes("divider") then
    el.attributes["background-color"] = dark_purple
    return el
  end
end

-- beamer: map classes to the theme's frame options
local beamer_options = {
  dark = "dark",
  stripe = "stripe",
  divider = "divider",
  ["no-logo"] = "nologo",
}

local function beamer_header(el)
  local opts = {}
  if el.attributes["frameoptions"] then
    table.insert(opts, el.attributes["frameoptions"])
  end
  if el.level == 1 and not el.classes:includes("divider") then
    table.insert(opts, "divider")
  end
  for cls, opt in pairs(beamer_options) do
    if el.classes:includes(cls) then table.insert(opts, opt) end
  end
  if #opts > 0 then
    el.attributes["frameoptions"] = table.concat(opts, ",")
  end
  return el
end

-- beamer: utility span classes shared with the revealjs CSS
local beamer_spans = {
  subheading = { "\\subheading{", "}" },
  small = { "{\\small ", "}" },
  accent = { "{\\color{uclbrightpurple}", "}" },
}

local function beamer_span(el)
  for cls, wrap in pairs(beamer_spans) do
    if el.classes:includes(cls) then
      local out = pandoc.List({ pandoc.RawInline("latex", wrap[1]) })
      out:extend(el.content)
      out:insert(pandoc.RawInline("latex", wrap[2]))
      return out
    end
  end
end

function Pandoc(doc)
  if quarto.doc.is_format("revealjs") then
    return doc:walk({ Header = revealjs_header })
  end
  if not quarto.doc.is_format("beamer") then return nil end

  local blocks = pandoc.Blocks({})
  for i, block in ipairs(doc.blocks) do
    if block.t == "Header" and block.level <= 2 then
      block = beamer_header(block)
    end
    blocks:insert(block)
    -- A section heading with no body of its own still needs a divider frame
    if block.t == "Header" and block.level == 1 then
      local nxt = doc.blocks[i + 1]
      if nxt == nil or (nxt.t == "Header" and nxt.level <= 2) then
        blocks:insert(pandoc.RawBlock("latex", ""))
      end
    end
  end
  doc.blocks = blocks:walk({ Span = beamer_span })

  -- Load the theme straight from the extension (no files copied next to the
  -- document). The path is relative to the document so spaces elsewhere in
  -- the absolute path don't matter.
  local dir = pandoc.path.make_relative(quarto.utils.resolve_path("beamer"),
                                        pandoc.system.get_working_directory(), true)
  dir = dir:gsub("\\", "/") .. "/"
  quarto.doc.include_text("in-header",
    "\\usepackage[path=" .. dir .. "]{" .. dir .. "beamerthemeucl2025}")

  -- Quarto doesn't pass author affiliations to beamer's \institute
  if not doc.meta["institute"] and doc.meta["by-affiliation"] then
    local names = {}
    for _, aff in ipairs(doc.meta["by-affiliation"]) do
      if aff.name then table.insert(names, pandoc.utils.stringify(aff.name)) end
    end
    if #names > 0 then
      doc.meta["institute"] = pandoc.MetaInlines({ pandoc.Str(table.concat(names, "; ")) })
    end
  end

  local footer = doc.meta["footer"]
  if footer then
    quarto.doc.include_text("in-header",
      "\\renewcommand{\\uclfooter}{" .. pandoc.utils.stringify(footer) .. "}")
  end
  return doc
end
