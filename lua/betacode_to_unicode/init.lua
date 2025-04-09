-- lua/betacode_to_unicode/init.lua
-- Betacode to Unicode conversion plugin for Neovim
-- Original script by Mihail Radu Solcan (GPL)
-- Enhanced for full buffer and visual selection support

local M = {}

-- Core conversion function
local function convert_betacode_to_unicode(lines)
  local modified = false

  -- Lowercase the text
  for i, line in ipairs(lines) do
    lines[i] = line:lower()
  end

  -- Swap stars with following non-lowercase characters
  for i, line in ipairs(lines) do
    local new_line = line:gsub("%*([^a-z]*)([a-z])", function(capt1, capt2)
      return capt2:upper() .. capt1
    end)
    if new_line ~= line then
      lines[i] = new_line
      modified = true
    end
  end

  -- Define Betacode to Unicode substitutions, split by length
  local subs_4 = {
    ["a)\\|"] = "ᾂ",
    ["a(\\|"] = "ᾃ",
    ["a)/|"] = "ᾄ",
    ["a(/|"] = "ᾅ",
    ["a)=|"] = "ᾆ",
    ["a(=|"] = "ᾇ",
    ["A)\\|"] = "ᾊ",
    ["A(\\|"] = "ᾋ",
    ["A)/|"] = "ᾌ",
    ["A(/|"] = "ᾍ",
    ["A)=|"] = "ᾎ",
    ["A(=|"] = "ᾏ",
    ["h)\\|"] = "ᾒ",
    ["h(\\|"] = "ᾓ",
    ["h)/|"] = "ᾔ",
    ["h(/|"] = "ᾕ",
    ["h)=|"] = "ᾖ",
    ["h(=|"] = "ᾗ",
    ["H)\\|"] = "ᾚ",
    ["H(\\|"] = "ᾛ",
    ["H)/|"] = "ᾜ",
    ["H(/|"] = "ᾝ",
    ["H)=|"] = "ᾞ",
    ["H(=|"] = "ᾟ",
    ["w)\\|"] = "ᾢ",
    ["w(\\|"] = "ᾣ",
    ["w)/|"] = "ᾤ",
    ["w(/|"] = "ᾥ",
    ["w)=|"] = "ᾦ",
    ["w(=|"] = "ᾧ",
    ["W)\\|"] = "ᾪ",
    ["W(\\|"] = "ᾫ",
    ["W)/|"] = "ᾬ",
    ["W(/|"] = "ᾭ",
    ["W)=|"] = "ᾮ",
    ["W(=|"] = "ᾯ",
    ["a%27"] = "ᾰ",
    ["a%26"] = "ᾱ",
    ["A%27"] = "Ᾰ",
    ["A%26"] = "Ᾱ",
    ["i%27"] = "ῐ",
    ["i%26"] = "ῑ",
    ["I%27"] = "Ῐ",
    ["I%26"] = "Ῑ",
    ["u%27"] = "ῠ",
    ["u%26"] = "ῡ",
    ["U%27"] = "Ῠ",
    ["U%26"] = "Ῡ",
  }

  local subs_3 = {
    ["a)\\"] = "ἂ",
    ["a(\\"] = "ἃ",
    ["a)/"] = "ἄ",
    ["a(/"] = "ἅ",
    ["a)="] = "ἆ",
    ["a(="] = "ἇ",
    ["A)\\"] = "Ἂ",
    ["A(\\"] = "Ἃ",
    ["A)/"] = "Ἄ",
    ["A(/"] = "Ἅ",
    ["A)="] = "Ἆ",
    ["A(="] = "Ἇ",
    ["e)\\"] = "ἒ",
    ["e(\\"] = "ἓ",
    ["e)/"] = "ἔ",
    ["e(/"] = "ἕ",
    ["E)\\"] = "Ἒ",
    ["E(\\"] = "Ἓ",
    ["E)/"] = "Ἔ",
    ["E(/"] = "Ἕ",
    ["h)\\"] = "ἢ",
    ["h(\\"] = "ἣ",
    ["h)/"] = "ἤ",
    ["h(/"] = "ἥ",
    ["h)="] = "ἦ",
    ["h(="] = "ἧ",
    ["H)\\"] = "Ἢ",
    ["H(\\"] = "Ἣ",
    ["H)/"] = "Ἤ",
    ["H(/"] = "Ἥ",
    ["H)="] = "Ἦ",
    ["H(="] = "Ἧ",
    ["i)\\"] = "ἲ",
    ["i(\\"] = "ἳ",
    ["i)/"] = "ἴ",
    ["i(/"] = "ἵ",
    ["i)="] = "ἶ",
    ["i(="] = "ἷ",
    ["I)\\"] = "Ἲ",
    ["I(\\"] = "Ἳ",
    ["I)/"] = "Ἴ",
    ["I(/"] = "Ἵ",
    ["I(="] = "Ἷ",
    ["o)\\"] = "ὂ",
    ["o(\\"] = "ὃ",
    ["o)/"] = "ὄ",
    ["o(/"] = "ὅ",
    ["O)\\"] = "Ὂ",
    ["O)/"] = "Ὄ",
    ["O(/"] = "Ὅ",
    ["u)\\"] = "ὒ",
    ["u(\\"] = "ὓ",
    ["u)/"] = "ὔ",
    ["u(/"] = "ὕ",
    ["u)="] = "ὖ",
    ["u(="] = "ὗ",
    ["U(\\"] = "Ὓ",
    ["U(/"] = "Ὕ",
    ["U(="] = "Ὗ",
    ["w)\\"] = "ὢ",
    ["w(\\"] = "ὣ",
    ["w)/"] = "ὤ",
    ["w(/"] = "ὥ",
    ["w)="] = "ὦ",
    ["w(="] = "ὧ",
    ["W)\\"] = "Ὢ",
    ["W(\\"] = "Ὣ",
    ["W)/"] = "Ὤ",
    ["W(/"] = "Ὥ",
    ["W)="] = "Ὦ",
    ["W(="] = "Ὧ",
    ["a)|"] = "ᾀ",
    ["a(|"] = "ᾁ",
    ["A)|"] = "ᾈ",
    ["A(|"] = "ᾉ",
    ["h)|"] = "ᾐ",
    ["h(|"] = "ᾑ",
    ["H)|"] = "ᾘ",
    ["H(|"] = "ᾙ",
    ["w)|"] = "ᾠ",
    ["w(|"] = "ᾡ",
    ["W)|"] = "ᾨ",
    ["W(|"] = "ᾩ",
    ["a\\|"] = "ᾲ",
    ["a/|"] = "ᾴ",
    ["a=|"] = "ᾷ",
    ["h\\|"] = "ῂ",
    ["h/|"] = "ῄ",
    ["h=|"] = "ῇ",
    ["i\\+"] = "ῒ",
    ["i/+"] = "ΐ",
    ["i=+"] = "ῗ",
    ["u\\+"] = "ῢ",
    ["u/+"] = "ΰ",
    ["u=+"] = "ῧ",
    ["w\\|"] = "ῲ",
    ["w/|"] = "ῴ",
    ["w=|"] = "ῷ",
  }

  local subs_2 = {
    ["S3"] = "Ϲ",
    ["s2"] = "ς",
    ["s3"] = "ϲ",
    ["i+"] = "ϊ",
    ["u+"] = "ϋ",
    ["a)"] = "ἀ",
    ["a("] = "ἁ",
    ["A)"] = "Ἀ",
    ["A("] = "Ἁ",
    ["e)"] = "ἐ",
    ["e("] = "ἑ",
    ["E)"] = "Ἐ",
    ["E("] = "Ἑ",
    ["h)"] = "ἠ",
    ["h("] = "ἡ",
    ["H)"] = "Ἠ",
    ["H("] = "Ἡ",
    ["i)"] = "ἰ",
    ["i("] = "ἱ",
    ["I)"] = "Ἰ",
    ["I("] = "Ἱ",
    ["o)"] = "ὀ",
    ["o("] = "ὁ",
    ["O)"] = "Ὀ",
    ["O("] = "Ὁ",
    ["u)"] = "ὐ",
    ["u("] = "ὑ",
    ["U("] = "Ὑ",
    ["w)"] = "ὠ",
    ["w("] = "ὡ",
    ["W)"] = "Ὠ",
    ["W("] = "Ὡ",
    ["a\\"] = "ὰ",
    ["a/"] = "ά",
    ["e\\"] = "ὲ",
    ["e/"] = "έ",
    ["h\\"] = "ὴ",
    ["h/"] = "ή",
    ["i\\"] = "ὶ",
    ["i/"] = "ί",
    ["o\\"] = "ὸ",
    ["o/"] = "ό",
    ["u\\"] = "ὺ",
    ["u/"] = "ύ",
    ["w\\"] = "ὼ",
    ["w/"] = "ώ",
    ["a|"] = "ᾳ",
    ["a="] = "ᾶ",
    ["A\\"] = "Ὰ",
    ["A/"] = "Ά",
    ["A|"] = "ᾼ",
    ["h|"] = "ῃ",
    ["h="] = "ῆ",
    ["E\\"] = "Ὲ",
    ["E/"] = "Έ",
    ["H\\"] = "Ὴ",
    ["H/"] = "Ή",
    ["H|"] = "ῌ",
    ["i="] = "ῖ",
    ["I\\"] = "Ὶ",
    ["I/"] = "Ί",
    ["r)"] = "ῤ",
    ["r("] = "ῥ",
    ["u="] = "ῦ",
    ["U\\"] = "Ὺ",
    ["U/"] = "Ύ",
    ["R("] = "Ῥ",
    ["w|"] = "ῳ",
    ["w="] = "ῶ",
    ["O\\"] = "Ὸ",
    ["O/"] = "Ό",
    ["W\\"] = "Ὼ",
    ["W/"] = "Ώ",
    ["W|"] = "ῼ",
    -- Macrons and breves
    ["a&"] = "ᾱ",
    ["A&"] = "Ᾱ",
    ["a'"] = "ᾰ",
    ["A'"] = "Ᾰ",
    ["e&"] = "ε",
    ["E&"] = "Ε",
    ["e'"] = "ε",
    ["E'"] = "Ε",
    ["h&"] = "η",
    ["H&"] = "Η",
    ["h'"] = "η",
    ["H'"] = "Η",
    ["i&"] = "ῑ",
    ["I&"] = "Ῑ",
    ["i'"] = "ῐ",
    ["I'"] = "Ῐ",
    ["o&"] = "ο",
    ["O&"] = "Ο",
    ["o'"] = "ο",
    ["O'"] = "Ο",
    ["u&"] = "ῡ",
    ["U&"] = "Ῡ",
    ["u'"] = "ῠ",
    ["U'"] = "Ῠ",
    ["w&"] = "ω",
    ["W&"] = "Ω",
    ["w'"] = "ω",
    ["W'"] = "Ω",
  }

  local subs_1 = {
    ["A"] = "Α",
    ["B"] = "Β",
    ["G"] = "Γ",
    ["D"] = "Δ",
    ["E"] = "Ε",
    ["Z"] = "Ζ",
    ["H"] = "Η",
    ["Q"] = "Θ",
    ["I"] = "Ι",
    ["K"] = "Κ",
    ["L"] = "Λ",
    ["M"] = "Μ",
    ["N"] = "Ν",
    ["C"] = "Ξ",
    ["O"] = "Ο",
    ["P"] = "Π",
    ["R"] = "Ρ",
    ["S"] = "Σ",
    ["T"] = "Τ",
    ["U"] = "Υ",
    ["F"] = "Φ",
    ["X"] = "Χ",
    ["Y"] = "Ψ",
    ["W"] = "Ω",
    ["a"] = "α",
    ["b"] = "β",
    ["g"] = "γ",
    ["d"] = "δ",
    ["e"] = "ε",
    ["z"] = "ζ",
    ["h"] = "η",
    ["q"] = "θ",
    ["i"] = "ι",
    ["k"] = "κ",
    ["l"] = "λ",
    ["m"] = "μ",
    ["n"] = "ν",
    ["c"] = "ξ",
    ["o"] = "ο",
    ["p"] = "π",
    ["r"] = "ρ",
    ["j"] = "ς",
    ["s"] = "σ",
    ["t"] = "τ",
    ["u"] = "υ",
    ["f"] = "φ",
    ["x"] = "χ",
    ["y"] = "ψ",
    ["w"] = "ω",
  }

  -- Apply substitutions in order: 4, 3, 2, 1
  for i, line in ipairs(lines) do
    local new_line = line
    for betacode, unicode in pairs(subs_4) do
      local escaped_betacode = betacode:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")
      new_line = new_line:gsub(escaped_betacode, unicode)
    end
    for betacode, unicode in pairs(subs_3) do
      local escaped_betacode = betacode:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")
      new_line = new_line:gsub(escaped_betacode, unicode)
    end
    for betacode, unicode in pairs(subs_2) do
      local escaped_betacode = betacode:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")
      new_line = new_line:gsub(escaped_betacode, unicode)
    end
    for betacode, unicode in pairs(subs_1) do
      local escaped_betacode = betacode:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")
      new_line = new_line:gsub(escaped_betacode, unicode)
    end
    if new_line ~= line then
      lines[i] = new_line
      modified = true
    end
  end

  -- Final sigma pass
  for i, line in ipairs(lines) do
    local new_line = line:gsub("σ([%s,.:;>%]%c])", "ς%1"):gsub("σ$", "ς")
    if new_line ~= line then
      lines[i] = new_line
      modified = true
    end
  end

  return lines, modified
end

-- Full buffer conversion
local function betacode_to_unicode_full()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local new_lines, modified = convert_betacode_to_unicode(lines)
  if modified then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
  end
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
end

-- Visual selection conversion
local function betacode_to_unicode_visual()
  local start_pos = vim.api.nvim_buf_get_mark(0, "<")
  local end_pos = vim.api.nvim_buf_get_mark(0, ">")
  local start_line, start_col = start_pos[1] - 1, start_pos[2]
  local end_line, end_col = end_pos[1] - 1, end_pos[2]

  local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line + 1, false)
  if #lines == 1 then
    lines[1] = lines[1]:sub(start_col + 1, end_col + 1)
  else
    lines[1] = lines[1]:sub(start_col + 1)
    lines[#lines] = lines[#lines]:sub(1, end_col + 1)
  end

  local new_lines, modified = convert_betacode_to_unicode(lines)
  if not modified then
    return
  end

  if #new_lines == 1 then
    local orig_line = vim.api.nvim_buf_get_lines(0, start_line, start_line + 1, false)[1]
    local before = orig_line:sub(1, start_col)
    local after = orig_line:sub(end_col + 2)
    new_lines[1] = before .. new_lines[1] .. after
    vim.api.nvim_buf_set_lines(0, start_line, start_line + 1, false, new_lines)
  else
    local orig_first = vim.api.nvim_buf_get_lines(0, start_line, start_line + 1, false)[1]
    local orig_last = vim.api.nvim_buf_get_lines(0, end_line, end_line + 1, false)[1]
    new_lines[1] = orig_first:sub(1, start_col) .. new_lines[1]
    new_lines[#new_lines] = new_lines[#new_lines] .. orig_last:sub(end_col + 2)
    vim.api.nvim_buf_set_lines(0, start_line, end_line + 1, false, new_lines)
  end
end

-- Setup function for plugin initialization
function M.setup()
  vim.api.nvim_create_user_command("BetacodeToUnicode", betacode_to_unicode_full, {})
  vim.api.nvim_create_user_command("BetacodeToUnicodeVisual", betacode_to_unicode_visual, { range = true })
end

-- Automatically setup on load
M.setup()

return M
