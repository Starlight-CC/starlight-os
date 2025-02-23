--[[
Made for use in StarlightOS
filed under GNU General Public License.
    Copyright (C) 2025  StarlightOS

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>

    contacts-
      <https://raw.githubusercontent.com/ASTRONAND/Starlight-OS/refs/heads/main/legal/contacts.md>
]]
term.setPaletteColor(colors.red,0xff0000)
term.setPaletteColor(colors.green,0x00ff00)
term.setPaletteColor(colors.blue,0x0000ff)
local pullEvent = os.pullEvent
local txt = textutils
os.pullEvent = os.pullEventRaw
local VER = "src"
local Copyright = http.get("https://raw.githubusercontent.com/ASTRONAND/Starlight-OS/refs/heads/main/"..VER.."/install/TOSPrint.txt")
local API = "https://api.github.com/repos/ASTRONAND/Starlight-OS/contents/"
local json = load(http.get("https://raw.githubusercontent.com/Starlight-CC/Starlight-OS/refs/heads/main/src/root/lib/sys/json.la").readAll())()
-- PrimeUI by JackMacWindows
-- Public domain/CC0

local expect = require "cc.expect".expect

-- PrimeUI by JackMacWindows
-- Public domain/CC0

local expect = require "cc.expect".expect

-- Initialization code
local PrimeUI = {}
do
    local coros = {}
    local restoreCursor

    --- Adds a task to run in the main loop.
    ---@param func function The function to run, usually an `os.pullEvent` loop
    function PrimeUI.addTask(func)
        expect(1, func, "function")
        local t = {coro = coroutine.create(func)}
        coros[#coros+1] = t
        _, t.filter = coroutine.resume(t.coro)
    end

    --- Sends the provided arguments to the run loop, where they will be returned.
    ---@param ... any The parameters to send
    function PrimeUI.resolve(...)
        coroutine.yield(coros, ...)
    end

    --- Clears the screen and resets all components. Do not use any previously
    --- created components after calling this function.
    function PrimeUI.clear()
        -- Reset the screen.
        term.setCursorPos(1, 1)
        term.setCursorBlink(false)
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white)
        term.clear()
        -- Reset the task list and cursor restore function.
        coros = {}
        restoreCursor = nil
    end

    --- Sets or clears the window that holds where the cursor should be.
    ---@param win window|nil The window to set as the active window
    function PrimeUI.setCursorWindow(win)
        expect(1, win, "table", "nil")
        restoreCursor = win and win.restoreCursor
    end

    --- Gets the absolute position of a coordinate relative to a window.
    ---@param win window The window to check
    ---@param x number The relative X position of the point
    ---@param y number The relative Y position of the point
    ---@return number x The absolute X position of the window
    ---@return number y The absolute Y position of the window
    function PrimeUI.getWindowPos(win, x, y)
        if win == term then return x, y end
        while win ~= term.native() and win ~= term.current() do
            if not win.getPosition then return x, y end
            local wx, wy = win.getPosition()
            x, y = x + wx - 1, y + wy - 1
            _, win = debug.getupvalue(select(2, debug.getupvalue(win.isColor, 1)), 1) -- gets the parent window through an upvalue
        end
        return x, y
    end

    --- Runs the main loop, returning information on an action.
    ---@return any ... The result of the coroutine that exited
    function PrimeUI.run()
        while true do
            -- Restore the cursor and wait for the next event.
            if restoreCursor then restoreCursor() end
            local ev = table.pack(os.pullEvent())
            -- Run all coroutines.
            for _, v in ipairs(coros) do
                if v.filter == nil or v.filter == ev[1] then
                    -- Resume the coroutine, passing the current event.
                    local res = table.pack(coroutine.resume(v.coro, table.unpack(ev, 1, ev.n)))
                    -- If the call failed, bail out. Coroutines should never exit.
                    if not res[1] then error(res[2], 2) end
                    -- If the coroutine resolved, return its values.
                    if res[2] == coros then return table.unpack(res, 3, res.n) end
                    -- Set the next event filter.
                    v.filter = res[2]
                end
            end
        end
    end
end

--- Draws a block of text inside a window with word wrapping, optionally resizing the window to fit.
---@param win window The window to draw in
---@param text string The text to draw
---@param resizeToFit boolean|nil Whether to resize the window to fit the text (defaults to false). This is useful for scroll boxes.
---@param fgColor color|nil The color of the text (defaults to white)
---@param bgColor color|nil The color of the background (defaults to black)
---@return number lines The total number of lines drawn
function PrimeUI.drawText(win, text, resizeToFit, fgColor, bgColor)
    expect(1, win, "table")
    expect(2, text, "string")
    expect(3, resizeToFit, "boolean", "nil")
    fgColor = expect(4, fgColor, "number", "nil") or colors.white
    bgColor = expect(5, bgColor, "number", "nil") or colors.black
    -- Set colors.
    win.setBackgroundColor(bgColor)
    win.setTextColor(fgColor)
    -- Redirect to the window to use print on it.
    local old = term.redirect(win)
    -- Draw the text using print().
    local lines = print(text)
    -- Redirect back to the original terminal.
    term.redirect(old)
    -- Resize the window if desired.
    if resizeToFit then
        -- Get original parameters.
        local x, y = win.getPosition()
        local w = win.getSize()
        -- Resize the window.
        win.reposition(x, y, w, lines)
    end
    return lines
end

--- Creates a scrollable window, which allows drawing large content in a small area.
---@param win window The parent window of the scroll box
---@param x number The X position of the box
---@param y number The Y position of the box
---@param width number The width of the box
---@param height number The height of the outer box
---@param innerHeight number The height of the inner scroll area
---@param allowArrowKeys boolean|nil Whether to allow arrow keys to scroll the box (defaults to true)
---@param showScrollIndicators boolean|nil Whether to show arrow indicators on the right side when scrolling is available, which reduces the inner width by 1 (defaults to false)
---@param fgColor number|nil The color of scroll indicators (defaults to white)
---@param bgColor color|nil The color of the background (defaults to black)
---@return window inner The inner window to draw inside
---@return fun(pos:number) scroll A function to manually set the scroll position of the window
function PrimeUI.scrollBox(win, x, y, width, height, innerHeight, allowArrowKeys, showScrollIndicators, fgColor, bgColor)
    expect(1, win, "table")
    expect(2, x, "number")
    expect(3, y, "number")
    expect(4, width, "number")
    expect(5, height, "number")
    expect(6, innerHeight, "number")
    expect(7, allowArrowKeys, "boolean", "nil")
    expect(8, showScrollIndicators, "boolean", "nil")
    fgColor = expect(9, fgColor, "number", "nil") or colors.white
    bgColor = expect(10, bgColor, "number", "nil") or colors.black
    if allowArrowKeys == nil then allowArrowKeys = true end
    -- Create the outer container box.
    local outer = window.create(win == term and term.current() or win, x, y, width, height)
    outer.setBackgroundColor(bgColor)
    outer.clear()
    -- Create the inner scrolling box.
    local inner = window.create(outer, 1, 1, width - (showScrollIndicators and 1 or 0), innerHeight)
    inner.setBackgroundColor(bgColor)
    inner.clear()
    -- Draw scroll indicators if desired.
    if showScrollIndicators then
        outer.setBackgroundColor(bgColor)
        outer.setTextColor(fgColor)
        outer.setCursorPos(width, height)
        outer.write(innerHeight > height and "\31" or " ")
    end
    -- Get the absolute position of the window.
    x, y = PrimeUI.getWindowPos(win, x, y)
    -- Add the scroll handler.
    local scrollPos = 1
    PrimeUI.addTask(function()
        while true do
            -- Wait for next event.
            local ev = table.pack(os.pullEvent())
            -- Update inner height in case it changed.
            innerHeight = select(2, inner.getSize())
            -- Check for scroll events and set direction.
            local dir
            if ev[1] == "key" and allowArrowKeys then
                if ev[2] == keys.up then dir = -1
                elseif ev[2] == keys.down then dir = 1 end
            elseif ev[1] == "mouse_scroll" and ev[3] >= x and ev[3] < x + width and ev[4] >= y and ev[4] < y + height then
                dir = ev[2]
            end
            -- If there's a scroll event, move the window vertically.
            if dir and (scrollPos + dir >= 1 and scrollPos + dir <= innerHeight - height) then
                scrollPos = scrollPos + dir
                inner.reposition(1, 2 - scrollPos)
            end
            -- Redraw scroll indicators if desired.
            if showScrollIndicators then
                outer.setBackgroundColor(bgColor)
                outer.setTextColor(fgColor)
                outer.setCursorPos(width, 1)
                outer.write(scrollPos > 1 and "\30" or " ")
                outer.setCursorPos(width, height)
                outer.write(scrollPos < innerHeight - height and "\31" or " ")
            end
        end
    end)
    -- Make a function to allow external scrolling.
    local function scroll(pos)
        expect(1, pos, "number")
        pos = math.floor(pos)
        expect.range(pos, 1, innerHeight - height)
        -- Scroll the window.
        scrollPos = pos
        inner.reposition(1, 2 - scrollPos)
        -- Redraw scroll indicators if desired.
        if showScrollIndicators then
            outer.setBackgroundColor(bgColor)
            outer.setTextColor(fgColor)
            outer.setCursorPos(width, 1)
            outer.write(scrollPos > 1 and "\30" or " ")
            outer.setCursorPos(width, height)
            outer.write(scrollPos < innerHeight - height and "\31" or " ")
        end
    end
    return inner, scroll
end

local pgk_env = setmetatable({}, { __index = _ENV })
pgk_env.require = dofile("rom/modules/main/cc/require.lua").make(pgk_env, "rom/modules/main")
local require = pgk_env.require

local expect = require("cc.expect")
local expect, field = expect.expect, expect.field
local wrap = require("cc.strings").wrap

function go(s)
    term.blit("[ DO ] ","77ee777","bbbbbbb")
    print(s)
end
function ok(s)
    term.blit("[ OK ] ","7755777","bbbbbbb")
    print(s)
end
function getFolder(a,dir)
    local con = json.decode(http.get(a..dir).readAll())
    for i,v in ipairs(con) do
        if v["type"] == "file" then
            go(string.sub(v["path"],#VER+7))
            local file = http.get(v["download_url"])
            local fh = fs.open(string.sub(v["path"],#VER+7), "w")
            fh.write(file.readAll())
            fh.close()
            ok(string.sub(v["path"],#VER+7))
        elseif v["type"] == "dir" then
            getFolder(API,v["path"])
        else
            error("Install ERROR",0)
        end
    end
end
local function deleteFiles(directory, exceptions)
    for _, entry in ipairs(fs.list(directory)) do
      local fullPath = fs.combine(directory, entry)
      if fs.isDir(fullPath) then
        if not exceptions[entry] then
          deleteFiles(fullPath, exceptions)
          fs.delete(fullPath) -- Delete the folder after deleting its contents
          print("Deleted "..fullPath)
        end
      elseif not exceptions[entry] then
        fs.delete(fullPath) -- Delete the file
        print("Deleted "..fullPath)
      end
    end
  end
  
  local exceptions = {
    ["rom"] = true,
    ["sbin/SLInstall.lua"] = true,
    ["sbin"] = true
  }

term.setTextColor(colors.white)
print("Connecting to "..API)
sleep(1.5)
term.setBackgroundColor(colors.blue)
PrimeUI.clear()
local scroller = PrimeUI.scrollBox(term.current(), 4, 6, 40, 10, 9000, true, true, colors.white, colors.blue)
PrimeUI.drawText(scroller, Copyright.readAll(), true)
print("")
print("(Y/N)")
while true do
    local _,k,_ = os.pullEvent("key")
    if k == keys.y then
        break
    elseif k == keys.n then
        term.setBackgroundColor(colors.blue)
        term.clear()
        term.setCursorPos(1,1)
        os.pullEvent = pullEvent
        fs.delete("sbin/SLInstall.lua")
        error("Install terminated",0)
    else
    end
end
term.clear()
term.setCursorPos(1,1)
term.setTextColor(colors.white)
print("This will delete EVERYTHING on / are you sure you want to install")
print("(Y/N)")
while true do
    local _,k,_ = os.pullEvent("key")
    if k == keys.y then
        break
    elseif k == keys.n then
        term.setBackgroundColor(colors.blue)
        term.clear()
        term.setCursorPos(1,1)
        os.pullEvent = pullEvent
        fs.delete("sbin/SLInstall.lua")
        error("Install terminated",0)
    else
    end
end
term.setTextColor(colors.purple)
print("cleaning drive")
deleteFiles("/",exceptions)
term.setTextColor(colors.white)
print("Installing")
getFolder(API,VER.."/root/")
term.setTextColor(colors.gray)
shell.run("tmp/shellSet.lua")
print("Rebooting ...")
sleep(1)
term.setTextColor(colors.green)
print("SL.reboot service started")
shell.run("sys/serv/reboot.lua")