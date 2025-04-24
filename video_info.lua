local page = 0
local total_pages = 5
local overlay = mp.create_osd_overlay("ass-events")
local update_timer = nil

-- Helper to style and add text
local function ass_format(lines)
    local ass = require 'mp.assdraw'
    local a = ass.ass_new()
    a:new_event()
    a:append("{\\fs20\\b1}") -- Bigger and bold
    for _, line in ipairs(lines) do
        a:append(line .. "\\N")
    end
    return a.text
end

local function format_duration(seconds)
    --local minutes = math.floor(seconds / 60)
    --local remaining_seconds = math.floor(seconds % 60)
    --return string.format("%02d:%02d", minutes, remaining_seconds)
    return string.format(seconds)
end

local function add(info, label, prop)
    local val = mp.get_property(prop)
    if val then
        if prop == "duration" then
            val = format_duration(val)
        elseif prop == "video-bitrate" or prop == "audio-bitrate" then
            val = tonumber(val)
            if val then
                val = string.format("%d kbps", math.floor(val / 1000))
            else
                val = "Unavailable"
            end
        end
        table.insert(info, string.format("%s: %s", label, val))
    else
        mp.msg.warn(string.format("Property %s is unavailable", prop))
    end
end

-- Info generators
local function get_video_info()
    local info = {"[Video]"}
    add(info, "File Format", "file-format")
    add(info, "Codec", "video-codec")
    add(info, "Pixel Format", "video-params/pixelformat")
    add(info, "Width", "width")
    add(info, "Height", "height")
    add(info, "Color Matrix", "video-params/colormatrix")
    add(info, "Primaries", "video-params/primaries")
    add(info, "Gamma", "video-params/gamma")
    add(info, "Display FPS", "container-fps")
    add(info, "Duration", "duration")
    add(info, "Bitrate", "video-bitrate")
    return info
end

local function get_audio_info()
    local info = {"[Audio]"}
    add(info, "Codec", "audio-codec")
    add(info, "Sample Rate", "audio-params/samplerate")
    add(info, "Channels", "audio-params/channel-count")
    add(info, "Format", "audio-params/format")
    add(info, "Bitrate", "audio-bitrate")
    return info
end

local function get_sub_info()
    local info = {"[Subtitles]"}
    local tracks_json = mp.get_property_native("track-list")

    if tracks_json then
        for _, track in ipairs(tracks_json) do
            if track.type == "sub" then
                local lang = track.lang or "und"
                local codec = track.codec or "unknown"
                local title = track.title or ""
                local id = track.id or "?"
                table.insert(info, string.format("Track %d [%s] - %s (%s)", id, lang, codec, title))
            end
        end
    else
        table.insert(info, "No subtitle tracks found.")
    end

    return info
end

local function get_overall_bitrate()
    local size_str = mp.get_property("file-size")
    local duration_str = mp.get_property("duration")

    if not size_str or not duration_str then
        return nil
    end

    local size = tonumber(size_str)
    local duration = tonumber(duration_str)

    if not size or not duration or duration <= 0 then
        return nil
    end

    local bitrate = math.floor((size * 8) / duration)
    return string.format("%d kbps", math.floor(bitrate / 1000))
end

local function get_dev_video_info()
    local info = {"[File]"}
    add(info, "File Path", "path")
    add(info, "File Size", "file-size")

    local avg_bitrate = get_overall_bitrate()
    if avg_bitrate then
        table.insert(info, string.format("Overall Bitrate: %s", avg_bitrate))
    end

    return info
end

-- Page router
local function show_page()
    if update_timer then
        update_timer:kill()
        update_timer = nil
    end

    if page == 5 then
        overlay:remove()
        return
    end

    local content
    if page == 1 then
        content = get_video_info()
    elseif page == 2 then
        content = get_audio_info()
    elseif page == 3 then
        content = get_dev_video_info()
    elseif page == 4 then
        content = get_sub_info()
    end

    overlay.data = ass_format(content)
    overlay:update()

    -- Start update loop if not off
  -- Get the current video framerate, fallback to 1 if unavailable
local fps = tonumber(mp.get_property("container-fps")) or 1
local interval = 1 / fps

update_timer = mp.add_timeout(interval, function()
    show_page() -- recursive trigger for periodic update
end)
end

-- TAB toggler
local function cycle_info()
    page = page + 1
    if page > total_pages then
        page = 1
    end
    show_page()
end

-- Bind TAB
mp.add_key_binding("TAB", "toggle_media_info", cycle_info)
