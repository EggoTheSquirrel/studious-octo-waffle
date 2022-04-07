function love.load()
    world = love.physics.newWorld(0, 0)
    world:setCallbacks(nil, nil, nil, checkCollision)

    player = require('src/Player')
    player.flight = true
    camera = require('src/camera')
    camera:setFocus(player)
    camera:setBounds(20, 20)

    stage1 = require('src/stages/stage_1')
    stage = loadStage(stage1)
end

function love.update(dt)
    world:update(dt)

    player:update(dt)

    camera:update(dt)
end

function love.draw()
    love.graphics.push()
        camera:center()

        for i, v in pairs(stage.objects) do        
            love.graphics.push()
                love.graphics.translate(5, 5)
                
                love.graphics.setColor(0.5, 0.5, 0.5)
                love.graphics.polygon('fill', v.body:getWorldPoints(v.shape:getPoints()))
            love.graphics.pop()
            
            love.graphics.setColor(1, 1, 1)
            love.graphics.polygon('fill', v.body:getWorldPoints(v.shape:getPoints()))
        end

        love.graphics.setColor(1, 1, 1)
        player:draw()
    love.graphics.pop()

    camera:draw(true, true)
end

function loadStage(file)
    local objects = {}
    for i, v in pairs(file.objects) do
        objects[i] = {
            body = love.physics.newBody(world, v.x, v.y),
            shape = love.physics.newRectangleShape(v.width, v.height),
        }
        objects[i].fixture = love.physics.newFixture(objects[i].body, objects[i].shape)
    end
    return {objects = objects}
end
