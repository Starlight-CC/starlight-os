-- SPDX-FileCopyrightText: 2023 The CC: Tweaked Developers
--
-- SPDX-License-Identifier: MPL-2.0

--[[- Internal tools for working with errors.

:::warning
This is an internal module and SHOULD NOT be used in your own code. It may
be removed or changed at any time.
:::

@local
]]

local expect = dofile("/sys/modules/cc/expect.lua").expect
local error_printer = dofile("/sys/modules/cc/internal/error_printer.lua")

local function find_frame(thread, file, line)
    -- Scan the first 16 frames for something interesting.
    for offset = 0, 15 do
        local frame = debug.getinfo(thread, offset, "Sl")
        if not frame then break end

        if frame.short_src == file and frame.what ~= "C" and frame.currentline == line then
            return frame
        end
    end
end

--[[- Check whether this error is an exception.

Currently we don't provide a stable API for throwing (and propogating) rich
errors, like those supported by this module. In lieu of that, we describe the
exception protocol, which may be used by user-written coroutine managers to
throw exceptions which are pretty-printed by the shell:

An exception is any table with:
 - The `"exception"` type
 - A string `message` field,
 - And a coroutine `thread` fields.

To throw such an exception, the inner loop of your coroutine manager may look
something like this:

```lua
local ok, result = coroutine.resume(co, table.unpack(event, 1, event.n))
if not ok then
    -- Rethrow non-string errors directly
    if type(result) ~= "string" then error(result, 0) end
    -- Otherwise, wrap it into an exception.
    error(setmetatable({ message = result, thread = co }, {
        __name = "exception",
        __tostring = function(self) return self.message end,
    }))
end
```

@param exn Some error object
@treturn boolean Whether this error is an exception.
]]
local function is_exception(exn)
    if type(exn) ~= "table" then return false end

    local mt = getmetatable(exn)
    return mt and mt.__name == "exception" and type(rawget(exn, "message")) == "string" and type(rawget(exn, "thread")) == "thread"
end

--[[- Attempt to call the provided function `func` with the provided arguments.

@tparam function func The function to call.
@param ... Arguments to this function.

@treturn[1] true If the function ran successfully.
@return[1] ... The return values of the function.

@treturn[2] false If the function failed.
@return[2] The error message
@treturn[2] coroutine The thread where the error occurred.
]]
local function try(func, ...)
    expect(1, func, "function")

    local co = coroutine.create(func)
    local result = table.pack(coroutine.resume(co, ...))

    while coroutine.status(co) ~= "dead" do
        local event = table.pack(kernel.pullEventRaw(result[2]))
        if result[2] == nil or event[1] == result[2] or event[1] == "terminate" then
            result = table.pack(coroutine.resume(co, table.unpack(event, 1, event.n)))
        end
    end

    if result[1] then
        return table.unpack(result, 1, result.n)
    elseif is_exception(result[2]) then
        local exn = result[2]
        return false, rawget(exn, "message"), rawget(exn, "thread")
    else
        return false, result[2], co
    end
end

--[[- Report additional context about an error.

@param err The error to report.
@tparam coroutine thread The coroutine where the error occurred.
@tparam[opt] { [string] = string } source_map Map of chunk names to their contents.
]]
local function report(err, thread, source_map)
    expect(2, thread, "thread")
    expect(3, source_map, "table", "nil")

    if type(err) ~= "string" then return end

    local file, line = err:match("^([^:]+):(%d+):")
    if not file then return end
    line = tonumber(line)

    local frame = find_frame(thread, file, line)
    if not frame or not frame.currentcolumn then return end

    local column = frame.currentcolumn
    local line_contents
    if source_map and source_map[frame.source] then
        -- File exists in the source map.
        local pos, contents = 1, source_map[frame.source]
        -- Try to remap our position. The interface for this only makes sense
        -- for single line sources, but that's sufficient for where we need it
        -- (the REPL).
        if type(contents) == "table" then
            column = column - contents.offset
            contents = contents.contents
        end

        for _ = 1, line - 1 do
            local next_pos = contents:find("\n", pos)
            if not next_pos then return end
            pos = next_pos + 1
        end

        local end_pos = contents:find("\n", pos)
        line_contents = contents:sub(pos, end_pos and end_pos - 1 or #contents)

    elseif frame.source:sub(1, 2) == "@/" then
        -- Read the file from disk.
        local handle = fs.open(frame.source:sub(3), "r")
        if not handle then return end
        for _ = 1, line - 1 do handle.readLine() end

        line_contents = handle.readLine()
    end

    -- Could not determine the line. Bail.
    if not line_contents or #line_contents == "" then return end

    error_printer({
        get_pos = function() return line, column end,
        get_line = function() return line_contents end,
    }, {
        { tag = "annotate", start_pos = column, end_pos = column, msg = "" },
    })
end


return {
    try = try,
    report = report,
}
