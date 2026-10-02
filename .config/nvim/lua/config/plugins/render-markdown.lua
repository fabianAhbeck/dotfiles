-- Grayscale palette (gruvbox fg/bg shades) for everything render-markdown draws.
local function grayscale_highlights()
  local hl = vim.api.nvim_set_hl
  local fg0, fg, fg4, gray = "#fbf1c7", "#ebdbb2", "#a89984", "#928374"
  local bg1, bg2, bg3 = "#3c3836", "#504945", "#665c54"

  hl(0, "RenderMarkdownH1", { fg = fg0, bold = true })
  hl(0, "RenderMarkdownH2", { fg = fg0, bold = true })
  hl(0, "RenderMarkdownH3", { fg = fg, bold = true })
  hl(0, "RenderMarkdownH4", { fg = fg, bold = true })
  hl(0, "RenderMarkdownH5", { fg = fg4, bold = true })
  hl(0, "RenderMarkdownH6", { fg = fg4, bold = true, italic = true })
  hl(0, "RenderMarkdownH1Bg", { fg = fg0, bg = bg2, bold = true })
  hl(0, "RenderMarkdownH2Bg", { fg = fg0, bg = bg1, bold = true })
  for i = 3, 6 do
    hl(0, "RenderMarkdownH" .. i .. "Bg", {})
  end

  hl(0, "RenderMarkdownCode", { bg = bg1 })
  hl(0, "RenderMarkdownCodeInline", { fg = fg, bg = bg1 })
  hl(0, "RenderMarkdownCodeBorder", { fg = bg1 })
  hl(0, "RenderMarkdownTableHead", { fg = gray })
  hl(0, "RenderMarkdownTableRow", { fg = bg3 })
  for _, group in ipairs({
    "RenderMarkdownBullet", "RenderMarkdownDash", "RenderMarkdownQuote",
    "RenderMarkdownLink", "RenderMarkdownWikiLink", "RenderMarkdownUnchecked",
    "RenderMarkdownChecked", "RenderMarkdownTodo", "RenderMarkdownSign",
    "RenderMarkdownInfo", "RenderMarkdownSuccess", "RenderMarkdownHint",
    "RenderMarkdownWarn", "RenderMarkdownError",
  }) do
    hl(0, group, { fg = gray })
  end

  -- Markdown syntax colours from the colorscheme (scoped to markdown only).
  for _, group in ipairs({
    "@markup.heading.markdown", "@markup.link.markdown_inline",
    "@markup.link.label.markdown_inline", "@markup.link.url.markdown_inline",
    "@markup.raw.markdown_inline", "@markup.list.markdown",
    "@markup.list.checked.markdown", "@markup.list.unchecked.markdown",
    "@markup.quote.markdown", "@punctuation.special.markdown",
  }) do
    hl(0, group, { fg = fg4 })
  end
  for i = 1, 6 do
    hl(0, "@markup.heading." .. i .. ".markdown", { link = "RenderMarkdownH" .. i })
  end
  hl(0, "@markup.strong.markdown_inline", { fg = fg0, bold = true })
  hl(0, "@markup.italic.markdown_inline", { fg = fg, italic = true })
end

-- render-markdown only draws a line under the table header. Copy that line
-- below every body row (except the last) so each row gets a separator.
local rm_ns = vim.api.nvim_create_namespace("render-markdown.nvim")
local row_ns = vim.api.nvim_create_namespace("render-markdown-row-lines")

local function add_row_lines(ctx)
  local buf = ctx.buf
  vim.api.nvim_buf_clear_namespace(buf, row_ns, 0, -1)
  local marks = vim.api.nvim_buf_get_extmarks(buf, rm_ns, 0, -1, { details = true })
  for _, mark in ipairs(marks) do
    local row, col, details = mark[2], mark[3], mark[4]
    local chunk = details.virt_text and details.virt_text[1]
    if details.virt_text_pos == "overlay" and chunk and vim.startswith(chunk[1], "├") then
      -- '━' marks column alignment on the header line; plain lines between rows.
      local line = string.rep(" ", col) .. chunk[1]:gsub("━", "─")
      local last = vim.api.nvim_buf_line_count(buf) - 1
      local r = row + 1
      while r < last do
        local next_line = vim.api.nvim_buf_get_lines(buf, r + 1, r + 2, false)[1]
        if not next_line:match("^%s*|") then
          break
        end
        vim.api.nvim_buf_set_extmark(buf, row_ns, r, 0, {
          virt_lines = { { { line, "RenderMarkdownTableRow" } } },
        })
        r = r + 1
      end
    end
  end
end

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- Keep lines rendered under the cursor so tables stay aligned while
      -- moving around; raw markdown only shows in insert mode.
      anti_conceal = { enabled = false },
      -- No icons in the sign column.
      sign = { enabled = false },
      -- Hide the '#'s and style headings by level: H1 gets a bar with a border,
      -- H2 a lighter bar, H3+ are bold text.
      heading = {
        icons = { "" },
        position = "inline",
        width = { "full", "full", "block" },
        border = { true, false },
        left_pad = { 1, 1, 0 },
      },
      -- Code blocks keep a subtle background but drop the language banner.
      code = {
        style = "normal",
        border = "thin",
        width = "block",
        left_pad = 1,
        right_pad = 2,
      },
      pipe_table = { preset = "round" },
      on = {
        render = add_row_lines,
        clear = function(ctx)
          vim.api.nvim_buf_clear_namespace(ctx.buf, row_ns, 0, -1)
        end,
      },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      grayscale_highlights()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = grayscale_highlights })
    end,
  }
}
