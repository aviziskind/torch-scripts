require 'image'
image.batchScale = function(img_batch, ...)
    local arg = {...}
    local nImages = img_batch:size(1)

    local applyScaleFunction = function(im)
        while #im:size() > 3  and im:size(1) == 1 do
            im = im[1]
        end
        return image.scale(im, unpack(arg))
    end

    local sampleOutput = applyScaleFunction(img_batch[1])
    
    local batch_output = torch.Tensor( torch.concat(nImages, sampleOutput:size() ) )
    for i = 1, nImages do
        batch_output[i] = applyScaleFunction(img_batch[i])
    end
    return batch_output
    
end
