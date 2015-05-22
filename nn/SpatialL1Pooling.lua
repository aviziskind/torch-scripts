require 'nn'

if not nn.SpatialL1Pooling then
    local SpatialL1Pooling, parent = torch.class('nn.SpatialL1Pooling', 'nn.Sequential')

    function SpatialL1Pooling:__init(nInputPlane, kW, kH, dW, dH)
       parent.__init(self)

       dW = dW or kW
       dH = dH or kH
       
       self.kW = kW
       self.kH = kH
       self.dW = dW
       self.dH = dH

       self.nInputPlane = nInputPlane

       self:add(nn.SpatialSubSampling(nInputPlane, kW, kH, dW, dH))

       self:get(1).bias:zero()
       self:get(1).weight:fill(1)
    end

    -- the module is a Sequential: by default, it'll try to learn the parameters
    -- of the sub sampler: we avoid that by redefining its methods.
    function SpatialL1Pooling:reset()
    end

    function SpatialL1Pooling:accGradParameters()
    end

    function SpatialL1Pooling:accUpdateGradParameters()
    end

    function SpatialL1Pooling:zeroGradParameters()
    end

    function SpatialL1Pooling:updateParameters()
    end
end