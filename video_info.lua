local page = 0
local total_pages = 5
local display_duration = 3600 -- long enough to manually clear

-- Helper function with debug
local function add(info, label, prop)
    local val = mp.get_property(prop)
    if val then
        table.insert(info, string.format("%s: %s", label, val))
    else
        mp.msg.warn(string.format("Property %s is unavailable", prop)) -- Debug log
    end
end

-- Basic Video info
local function get_video_info()
    local info = {"[Video]"}
    add(info, "File Format", "file-format")
    add(info, "Codec", "video-codec")
    add(info, "Width", "width")
    add(info, "Height", "height")
    add(info, "Container", "file-format")
    add(info, "Color Matrix", "video-params/colormatrix")
    add(info, "Primaries", "video-params/primaries")
    add(info, "Display FPS", "container-fps")
    add(info, "Duration", "duration")  
    return table.concat(info, "\n")
end

-- Dev-grade Video info
local function get_dev_video_info()
    local info = {"[File]"}
    add(info, "File Path", "path")
    add(info, "File Size", "file-size")
    return table.concat(info, "\n")
end

-- Audio info
local function get_audio_info()
    local info = {"[Audio]"}
    add(info, "Codec", "audio-codec")
    add(info, "Sample Rate", "audio-params/samplerate")
    add(info, "Channels", "audio-params/channel-count")
    add(info, "Format", "audio-params/format")
    add(info, "Bitrate", "audio-bitrate")
    return table.concat(info, "\n")
end

-- Subtitles info
local function get_sub_info()
    local info = {"[Subtitles]"}
    add(info, "Subtitle Language", "current-tracks/sub/lang")
    return table.concat(info, "\n")
end

-- Page router
local function show_page()
    if page == 1 then
        mp.osd_message(get_video_info(), display_duration)
    elseif page == 2 then
        mp.osd_message(get_audio_info(), display_duration)
    elseif page == 3 then
        mp.osd_message(get_dev_video_info(), display_duration)
    elseif page == 4 then
        mp.osd_message(get_sub_info(), display_duration)
    elseif page == 5 then
        mp.osd_message("", 0) -- clear screen
    end
end

-- F2 to cycle through info
local function cycle_info()
    page = page + 1
    if page > total_pages then
        page = 1
    end
    show_page()
end

-- Bind F2
mp.add_key_binding("F2", "toggle_media_info", cycle_info)
