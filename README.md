# celluloid-lua-plugins
Plugins for [Celluloid Player](https://github.com/celluloid-player/celluloid), powered by MPV and Lua.

## `video_info.lua`
Displays in-depth media information as on-screen text overlays (OSD) in a cycling format.  
Press `TAB` to toggle through different pages of detailed file info.

---

### 🔁 Pages of Information
Each press of `TAB` cycles to the next page. After the last page, pressing `TAB` again hides the overlay.

---
Example: Does not reflect information actually seen, depending on the file you may see more of less in some sections.
```
[Video]
File Format: mkv
Codec: H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10
Pixel Format: yuv420p
Width: 1280
Height: 720
Color Matrix: bt.709
Primaries: bt.709
Gamma: bt.1886
Color Levels: limited
Chroma Location: left
Display FPS: 23.976
Duration: 2705.560
Bitrate: 1147 kbps
Average-bits-per-pixel: 0.063
```
```
[Audio]
Codec: AAC (Advanced Audio Coding)
Sample Rate: 48000
Channels: 2
Format: floatp
Bitrate: 96 kbps
```
```
[File]
File Path: /your/files/path/examplevideo.mkv
File Size: 346240750
Overall Bitrate: 947 kbps
Hardware Decoding: yes
Storage Aspect Ratio: 16:9
Pixel Aspect Ratio: 1:1
Light Type: unknown
MinLuma: 0
MaxLuma: 255
Max-Content-Light-Level: 1000
Max-Frame-Average-LightLevel: 400
```
```
[Subtitles]
Track 1 [eng] - subrip (You have a subtitle track!)
Track 2 [und] - vtt (ruwoeruwoiriworwuior!)
```
```
[Frame]
Picture Type: I
Interlaced: no
Top-Field-First: unknown
GOP Timecode: 00:00:00:00
SMPTE Timecode: 00:00:00:00
```
```
[File Metadata]
title: Example Movie Title
artist: Some Artist
genre: Action
encoder: examplemetimbers45
```
That is all for now. No other plugins yet available here.
