local M = {}

local file = io.open("/home/geoseismal/.config/nvim/lua/custom/languages.json", "r")
local json = file:read("*a")
file:close()

-- Parse the JSON string
local data = vim.json.decode(json)

-- Regex match function for Lua
local function regex_match(str, pattern)
    return string.match(str, pattern)
end

-- Retrieve image and language values based on the provided filename
local function get_language_and_image(filename)
    -- Check if filename matches any KNOWN_EXTENSIONS regex patterns
    local image_name = nil
    for pattern, value in pairs(data.KNOWN_EXTENSIONS) do
        if regex_match(filename, pattern) then
            print(pattern)
            image_name = value.image
            break
        end
    end

    -- Check if filename matches any KNOWN_LANGUAGES
    for _, languageData in ipairs(data.KNOWN_LANGUAGES) do
        if languageData.image == image_name then
            return languageData.image, languageData.language
        end
    end

    return image_name, image_name  -- Return nil if no match is found
end


function M.initPresenceLoop()
    -- execute every 15 seconds
    vim.fn.timer_start(5000, function()
        M.updatePresence()
    end, {['repeat'] = -1})
end


function M.updatePresence()
    -- get current edited filename
    local filename = vim.fn.expand('%:t')

    -- get cursor positions
    local cursor = vim.api.nvim_win_get_cursor(0)

    -- get repository name
    local repo = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
    local image_name, language = get_language_and_image(filename)
    -- check if image_name is nil
    image_name = image_name or "unknown"
    language = language or "unknown"
    local config = {
      -- Your configuration data here
      details = "Tending " .. filename,
      state = "Workspace: " .. repo .. " | " ..cursor[1] .. ":" .. cursor[2] .. " | " .. vim.fn.mode(),
      large_text = "Editing " .. string.upper(language) .. " file",
      large_image = image_name,
      small_image = "default",
      small_text = "Catttty",
      last_updated = os.time()
    }

    local fileconfig = io.open('/tmp/lurifosterm/config.json', 'w')
    if fileconfig then
      fileconfig:write(vim.fn.json_encode(config))
      fileconfig:close()
      -- print('Config file written successfully.')
    else
      print('Failed to open config file.')
    end
end

return M
