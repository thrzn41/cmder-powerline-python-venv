-- Python venv symbol. Used to indicate the name of a venv or CONDA environment.
-- Set a 'Cute' icon or character in your font.
if not plc_prompt_venvSymbol then
    plc_prompt_venvSymbol = "⌘"
end


-- Extracts only the folder name from the input Path
-- Ex: Input C:\Windows\System32 returns System32
---
local function get_folder_name(path)
    local reversePath = string.reverse(path)
    local slashIndex = string.find(reversePath, "\\")
    return string.sub(path, string.len(path) - slashIndex + 2)
end


-- * Segment object with these properties:
---- * isNeeded: sepcifies whether a segment should be added or not. For example: no Git segment is needed in a non-git folder
---- * text
---- * textColor: Use one of the color constants. Ex: colorWhite
---- * fillColor: Use one of the color constants. Ex: colorBlue
local segment = {
  isNeeded = false,
  text = "",
  textColor = colorWhite,
  fillColor = colorMagenta
}

---
-- Sets the properties of the Segment object, and prepares for a segment to be added
---
local function init()
  local envVal = clink.get_env("VIRTUAL_ENV")

  if envVal then
    envVal = get_folder_name(envVal)
  else
    envVal = clink.get_env("CONDA_DEFAULT_ENV")
  end

  if envVal then
    segment.text = " "..plc_prompt_venvSymbol..envVal.." "
    segment.isNeeded = true
  else
    segment.isNeeded = false
  end
end 

---
-- Uses the segment properties to add a new segment to the prompt
---
local function addAddonSegment()
  init()
  if segment.isNeeded then 
      addSegment(segment.text, segment.textColor, segment.fillColor)
  end 
end 

-- Register this addon with Clink
clink.prompt.register_filter(addAddonSegment, 57)
