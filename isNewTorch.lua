isNewTorch = function()
  
    local isOldTorch = (paths.install_bin and string.find(paths.install_bin, 'torch7_old') )
    return not isOldTorch
  
end