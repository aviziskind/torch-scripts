sys.playSound = function(soundFileName, soundFileFolder)
    soundFileFolder =soundFileFolder or '/usr/share/sounds/ubuntu/stereo/'
    
    soundFileName = soundFileName or 'message.ogg'
    sys.execute('ogg123 ' .. soundFileFolder .. soundFileName)
   
end