Class = require 'class'
push = require 'push'

require 'Paddle'
require 'Ball' 

WINDOW_WIDTH = 1280 --1280 640 800
WINDOW_HEIGHT = 720 --720 360 450

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200
--------------------------------------------------------------------------------
function love.load()

	-- for ball direction
	math.randomseed(os.time())

	love.window.setTitle('Pong')

	smallFont = love.graphics.newFont('font.ttf', 8)
	scoreFont = love.graphics.newFont('font.ttf', 32)
	love.graphics.setFont(smallFont)

	love.graphics.setDefaultFilter('nearest', 'nearest')

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })


	player1Score = 0
	player2Score = 0

	player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH-15, VIRTUAL_HEIGHT-30, 5, 20)

    ball = Ball(VIRTUAL_WIDTH/2 -2, VIRTUAL_HEIGHT/2 -2, 4, 4)

	gameState = 'start'
end
--------------------------------------------------------------------------------
function love.draw()
	push:apply('start')

	love.graphics.clear(40, 45, 52, 255)

	love.graphics.setFont(smallFont)
	love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')

	-- print scores
	love.graphics.setFont(scoreFont) -- change default font
	love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH/2 - 50, VIRTUAL_HEIGHT/3)
	love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH/2 + 30, VIRTUAL_HEIGHT/3)

	-- left paddle
	player1:render()

	-- right paddle
	player2:render()

	-- ball
	ball:render()

	-- render fps
	displayFPS()

	push:apply('end')
end
--------------------------------------------------------------------------------
function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
--------------------------------------------------------------------------------
function love.keypressed(key)

	if key == 'escape' then
		love.event.quit()

	elseif key == 'return' or key == 'enter' then

		if gameState == 'start' then
			gameState = 'play'
		else
			gameState = 'start'
			-- reset ball position
			ball:reset()
		end
	end
end
--------------------------------------------------------------------------------
function love.update(dt)

	if gameState == 'play' then
		if ball:collides(player1) then
			ball.dx = -ball.dx * 1.03 -- increase speed 3%
			ball.x = player1.x + 5

			if ball.dy < 0 then
				ball.dy = -math.random(10, 150)
			else
				ball.dy = math.random(10, 150)
			end
		end

		if ball:collides(player2) then
			ball.dx = -ball.dx * 1.03 -- increase speed 3%
			ball.x = player2.x - 4

			if ball.dy < 0 then
				ball.dy = -math.random(10, 150)
			else
				ball.dy = math.random(10, 150)
			end
		end
	end

	-- upper and lowe screen boundary
	if ball.y <= 0 then
		ball.y = 0
		ball.dy = -ball.dy
	end

	if ball.y >= VIRTUAL_HEIGHT -4 then
		ball.y = VIRTUAL_HEIGHT -4
		ball.dy = -ball.dy
	end

	-- player 1 movement
	if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
    	player1.dy = PADDLE_SPEED
    else
    	player1.dy = 0
    end

	-- player 2 movement
	if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    -- ball update
    if gameState == 'play' then
    	ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end
--------------------------------------------------------------------------------