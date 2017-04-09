hs.hotkey.bind({"alt"}, "C", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)
hs.hotkey.bind({"command"}, "I", function() hs.eventtap.rightClick(hs.mouse.getAbsolutePosition()) end)
hs.hotkey.bind({"command"}, "J", function() hs.eventtap.scrollWheel({0, -50}, {}, "pixel") end, nil, function() hs.eventtap.scrollWheel({0, -50}, {}, "pixel") end)
hs.hotkey.bind({"command"}, "K", function() hs.eventtap.scrollWheel({0, 50}, {}, "pixel") end, nil, function() hs.eventtap.scrollWheel({0, 50}, {}, "pixel") end)
