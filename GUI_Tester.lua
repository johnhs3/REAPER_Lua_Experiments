-- Script generated by Lokasenna's GUI Builder


local lib_path = reaper.GetExtState("Lokasenna_GUI", "lib_path_v2")
if not lib_path or lib_path == "" then
    reaper.MB("Couldn't load the Lokasenna_GUI library. Please install 'Lokasenna's GUI library v2 for Lua', available on ReaPack, then run the 'Set Lokasenna_GUI v2 library path.lua' script in your Action List.", "Whoops!", 0)
    return
end
loadfile(lib_path .. "Core.lua")()




GUI.req("Classes/Class - Label.lua")()
GUI.req("Classes/Class - Button.lua")()
GUI.req("Classes/Class - Frame.lua")()
-- If any of the requested libraries weren't found, abort the script.
if missing_lib then return 0 end



GUI.name = "BIG Play and Stop Button (GUI TEST)"
GUI.x, GUI.y, GUI.w, GUI.h = 0, 0, 320, 128
GUI.anchor, GUI.corner = "mouse", "C"

button_PLAY = 0
-------------------------------------------------------------------------------------------------------------
function play()
reaper.Main_OnCommandEx( 1007, 0, 0 ) --PLAY
end

function stop()
reaper.Main_OnCommandEx( 1016, 0, 0 ) --STOP
  end
--------------------------------------------------------------------------------------------------------------
GUI.New("Button1", "Button", {
    z = 11,
    x = 32,
    y = 80,
    w = 48,
    h = 24,
    caption = "PLAY",
    font = 3,
    col_txt = "txt",
    col_fill = "elm_frame",
    func = play
})

GUI.New("Button2", "Button", {
    z = 11,
    x = 96,
    y = 80,
    w = 48,
    h = 24,
    caption = "STOP",
    font = 3,
    col_txt = "txt",
    col_fill = "elm_frame",
    func = stop
})

GUI.New("Label2", "Label", {
    z = 11,
    x = 80,
    y = 0,
    caption = "BIG Transport Controls",
    font = 2,
    color = "txt",
    bg = "wnd_bg",
    shadow = true
})

GUI.New("Button3", "Button", {
    z = 11,
    x = 176,
    y = 80,
    w = 128,
    h = 24,
    caption = "Literally nothing",
    font = 3,
    col_txt = "txt",
    col_fill = "elm_frame"
})

GUI.New("Label3", "Label", {
    z = 11,
    x = 4,
    y = 108,
    caption = "(c) Xcribe",
    font = 3,
    color = "txt",
    bg = "wnd_bg",
    shadow = false
})

GUI.New("Label1", "Label", {
    z = 11,
    x = 48,
    y = 32,
    caption = "(mostly proof of concept for GUI build)",
    font = 4,
    color = "txt",
    bg = "wnd_bg",
    shadow = false
})




GUI.New("Frame1", "Frame", {
    z = 12.0,
    x = 0,
    y = 0,
    w = 320,
    h = 128,
    shadow = false,
    fill = false,
    color = "elm_frame",
    bg = "wnd_bg",
    round = 0,
    text = "",
    txt_indent = 0,
    txt_pad = 0,
    pad = 4,
    font = 4,
    col_txt = "txt"
})







GUI.Init()
GUI.Main()

