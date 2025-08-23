local M = {}

local config = require("neovim_tips.config")
local tips = require("neovim_tips.tips")
local utils = require("neovim_tips.utils")

local builtin_dir = config.options.builtin_dir
local user_file = config.options.user_file

local function parse_tip_blocks(content)
  local parsed_tips = {}
  local current = {}
  local body_lines = {}
  local titles_seen = {}

  for line in content:gmatch("([^\r\n]*)\r?\n?") do
    local title = line:match("^#%s*Title:%s*(.+)")
    local category = line:match("^#%s*Category:%s*(.+)")
    local tags = line:match("^#%s*Tags:%s*(.+)")

    if title then
      title = utils.trim(title)
      if titles_seen[title] then
        vim.notify("Duplicate tip title found: " .. title, vim.log.levels.WARN)
        current = {} -- Skip adding this duplicate tip
      else
        current.title = title
        titles_seen[title] = true
      end
    elseif category then
      current.category = utils.trim(category)
    elseif tags then
      local tags_table = vim.split(tags, ",%s*")
      local tags_table_trimmed = vim.tbl_map(utils.trim, tags_table)
      current.tags = vim.tbl_filter(function(t) return t ~= "" end, tags_table_trimmed)
    elseif line == "---" then
      body_lines = {}
    elseif line == "===" then
      current.description = utils.trim(table.concat(body_lines, "\n"))
      if current.title then -- Ensure tip has a title and wasn't skipped
        table.insert(parsed_tips, current)
      end
      current = {}
      body_lines = {}
    elseif current.title then
      table.insert(body_lines, line)
    end
  end

  return parsed_tips
end

local function read_tip_file(path)
  local fd = io.open(path, "r")
  if not fd then return {} end
  local content = fd:read("*a")
  fd:close()
  return parse_tip_blocks(content)
end

local function read_tips_from_directory(dir_path)
  local all_tips = {}
  local handle = vim.loop.fs_scandir(dir_path)
  if not handle then
    return all_tips
  end

  while true do
    local name, type = vim.loop.fs_scandir_next(handle)
    if not name then break end
    if type == "file" and name:match("%.md$") and name ~= "builtin_tips.md.backup" then
      local file_path = dir_path .. "/" .. name
      local moreTips = read_tip_file(file_path)
      vim.list_extend(all_tips, moreTips)
    end
  end

  return all_tips
end

function M.load()
  local builtin_tips = read_tips_from_directory(builtin_dir)
  local user_tips = read_tip_file(user_file)
  local all_tips = {}
  vim.list_extend(all_tips, builtin_tips)
  vim.list_extend(all_tips, user_tips)
  tips.set(all_tips)
end

return M

