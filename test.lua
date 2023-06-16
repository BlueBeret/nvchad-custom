
-- Read the JSON file
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

local M = {
  get_language_and_image = get_language_and_image
}

return M

