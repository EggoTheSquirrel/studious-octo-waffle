Player = {}

Player.body = love.physics.newBody(world, 100, 100, 'dynamic')
Player.shape = love.physics.newRectangleShape(50, 50)
Player.fixture = love.physics.newFixture(Player.body, Player.shape)
Player.colliding = {
    ['up'] = false,
    ['down'] = false,
    ['left'] = false,
    ['right'] = false
}

Player.flight = false
Player.speed = 200 --Force that is applied to the player upon movement
Player.jumpSpeed = 300 --Same but vertical
Player.gravity = 50 --Vertical but inverse
Player.friction = 0.7 --Multiplied regardless of anything
Player.airResistance = 0.5 --Multiplied when the player is in the air

function Player:reset(x, y, speed)
    Player.body:setPosition(x, y)
    Player.body:setFixedRotation(true)

    Player.speed = speed
end

function Player:update(dt)
    Player.body:setAngularVelocity(0)
    Player.body:setAngle(0)
    
    Player:checkCollision()

    local velX, velY = 0, 0

    if not Player.colliding['up'] and not Player.flight then
        velY = velY + Player.gravity
    end
    
    if love.keyboard.isDown('w') and Player.colliding['up'] then
        velY = velY + -Player.jumpSpeed
    end if love.keyboard.isDown('a') then
        velX = velX + -Player.speed
    end if love.keyboard.isDown('d') then
        velX = velX + Player.speed
    end

    if Player.flight then
        if love.keyboard.isDown('w') then
            velY = velY + -Player.speed
        end if love.keyboard.isDown('s') then
            velY = velY + Player.speed
        end
    end

    if not Player.colliding['up'] and not Player.flight then
        velX = velX * Player.airResistance
    end
    
    local x, y = Player.body:getLinearVelocity()
    Player.body:setLinearVelocity(x * Player.friction + velX, y * Player.friction + velY)
end

function Player:draw()
    love.graphics.polygon('fill', Player.body:getWorldPoints(self.shape:getPoints()))
end

function Player:checkCollision() 
    Player.colliding = {
        ['up'] = false,
        ['down'] = false,
        ['left'] = false,
        ['right'] = false
    }
    for i, v in pairs(Player.body:getContacts()) do
        local norX, norY = v:getNormal()
        
        if norY == 1 then
            Player.colliding['up'] = true
        elseif norY == -1 then
            Player.colliding['down'] = true
        elseif norX == 1 then
            Player.colliding['left'] = true
        elseif norX == -1 then
            Player.colliding['right'] = true
        end

    end
end

return Player