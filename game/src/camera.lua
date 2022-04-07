Camera = {}

Camera.focus = nil
Camera.focX, Camera.focY = 0, 0
Camera.difX, Camera.difY = 0, 0
Camera.translateX, Camera.translateY = 0, 0
Camera.boundX, Camera.boundY = 0, 0

function Camera:setFocus(object)
    Camera.focus = object.body
end

function Camera:setBounds(boundX, boundY)
    Camera.boundX, Camera.boundY = boundX, boundY
end

function Camera:center()
    love.graphics.translate(Camera.translateX + love.graphics.getWidth() / 2, Camera.translateY + love.graphics.getHeight() / 2)
end

function Camera:update(dt)
    if self.focus ~= nil then 
        self.focX, self.focY = self.focus:getPosition()
    end

    self.difX = Camera.focX + -Camera.translateX 
    self.difY = Camera.focY + -Camera.translateY

    if self.difX > self.boundX then
        self.translateX = self.translateX + self.boundX
    elseif self.difX < -self.boundX then
    end

    if Camera.focY > Camera.translateY + Camera.boundY then
        Camera.translateY = -Camera.focY + -Camera.boundY
    elseif Camera.focY < Camera.translateY + -Camera.boundY then
        Camera.translateY = Camera.focY + Camera.boundY
    end
end

function Camera:draw(bounds, debugInfo)
    if bounds then
        love.graphics.polygon('line', 
            Camera.boundX, Camera.boundY, 
            love.graphics.getWidth() + -Camera.boundX, Camera.boundY, 
            love.graphics.getWidth() + -Camera.boundX, love.graphics.getHeight() + -Camera.boundY,
            Camera.boundX, love.graphics.getHeight() + -Camera.boundY
        )
    end
    if debugInfo then
        love.graphics.print('translate: '..Camera.translateX..', '..Camera.translateY..'\n'
            ..'focus body position: '..Camera.focX..', '..Camera.focY..'\n'
            ..'difference: '..self.difX..', '..self.difY,
            0, love.graphics.getHeight() + -60
        )
    end
end

return Camera