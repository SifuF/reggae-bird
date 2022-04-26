-- Reggae Bird by SifuF
local physics = require("physics")
physics.start()
physics.setGravity( 0, 16 )
math.randomseed(os.time())

--global vars
local mainGame = false
local backgroundMusic = nil
local backgroundMusicChannel = nil
local coinSound = audio.loadSound("sound/coin.wav")
local punchSound = audio.loadSound("sound/punch.wav")
local flapSound = audio.loadSound("sound/flap.wav")
local laugh1Sound = audio.loadSound("sound/laugh1.wav")
local laugh2Sound = audio.loadSound("sound/laugh2.wav")
local laugh3Sound = audio.loadSound("sound/laugh3.wav")
local laugh4Sound = audio.loadSound("sound/laugh4.wav")
local laugh5Sound = audio.loadSound("sound/laugh5.wav")
local laugh6Sound = audio.loadSound("sound/die_laugh.wav")
local startSound = audio.loadSound("sound/start.wav")
local whoosh1Sound = audio.loadSound("sound/whoosh.wav")
local whoosh2Sound = audio.loadSound("sound/whoosh2.wav")
local whoosh3Sound = audio.loadSound("sound/whoosh2.wav")
local widthFix = 90
local alive = true
local died = false
local started = false
local coinGot3=false
local coinGot2=false
local coinGot1=false
local score = 0
local hiScore = 0
local myText = nil
local text = " "
local mbPassed1 = false
local mbPassed2 = false
local mbPassed3 = false
local targetCounter = 0
local targetMax = 50
local alpha = 0
local beta = -90
local gamma = 0
local fileName = "flappyKScore.txt"
local retryPossible = true
local dieBoard
local playButton
local quitButton
local hiText
local gap = 1.0
local gap2 = 2.5
local startLength = 300
local spacing = 150
local flaps = 0
local titleDone = false
local touchDone = false
local theta1 = 0
local touchFinished2 = nil
local transition1 = false
local transition2 = false
local transition3 = false

--functions
local onPlayButton = nil
local onQuitButton = nil 
local onPlayComplete = nil
local onQuitComplete = nil 
local saveScore = nil
local loadScore = nil  
local onEnterFrame = nil  
local reset = nil  
local retry = nil  
local playLaugh = nil  
local die = nil  
local retryPos = nil  
local onPlayButton = nil 
local onQuitButton = nil 
local onTouch = nil  
local onShake = nil  
local onCollision = nil  
local onKeyEvent = nil  
local saveScore = nil  
local loadScore = nil  
local main = nil
local titleScreen = nil
local titleFinished = nil
local touchFinished1 = nil
local touchFinished2 = nil
local listener = {}
local clearTitle = nil
local pauseFlap = nil
local createDieBoard = nil
local removeDieBoard = nil

--Objects
local bg_far = nil
local cloud = nil
local cloud2 = nil
local cloud3 = nil
local bg_mid_1 = nil
local bg_mid_2 = nil
local bg_close_1 = nil
local bg_close_2 = nil
local mb1 = nil
local titleBoard = nil
local jointHeight1 = nil
local joint1U = nil
local joint1D = nil
local jointHeight2 = nil
local joint2U = nil
local joint2D = nil
local jointHeight3 = nil
local joint3U = nil
local joint3D = nil
local scoreBoard = nil
local scoreBoard2 = nil
local tapSheetData = nil
local tapSheet = nil
local tapSequenceData = nil
local tapBoard = nil
local speech = nil
local sheetData = nil
local mySheet = nil
local sequenceData = nil
local sheetData2 = nil
local mySheet2 = nil
local sequenceData2 = nil
local player = nil
local flapHandle = nil
local whiteFade = nil
local whiteFade2 = nil
local whiteFade3 = nil
local gameOver = nil
local hitSprite = nil
local gameOverGroup = nil

local bg = nil
local bg2 = nil

local bgBorder = nil
local bgBorder2 = nil
local clearLogo = nil
local titleBoard = nil
local touchBoard = nil
local top = nil
local bottom = nil
local left = nil
local right = nil

local shapeU = {-25, 110  ,  -14, -13  ,  -30, -51  ,  -24.5, -100  ,  0, -140  ,  30, -50,  10, -20  ,  -10, 120}
local shapeD = {-10, 130  ,  -30, 50  ,  -10, 20  ,  10, -120  ,  20, -120  ,  15, 20,  30,60  ,  10, 135}

local testPointD1 = nil
local testPointD2 = nil
local testPointD3 = nil
local testPointD4 = nil
local testPointD5 = nil
local testPointD6 = nil
local testPointD7 = nil
local testPointD8 = nil

local testPointU1 = nil
local testPointU2 = nil
local testPointU3 = nil
local testPointU4 = nil
local testPointU5 = nil
local testPointU6 = nil
local testPointU7 = nil
local testPointU8 = nil

--------------------------------------------------------------------
main = function()

  bg_far = display.newImage("gfx/background_far.png")
  local w1 = bg_far.width
  local h1 = bg_far.height
  bg_far.width = display.contentWidth
  bg_far.height = h1*bg_far.width/w1
  bg_far.x = display.contentWidth/2
  bg_far.y = display.contentHeight/2
  
  cloud = display.newImage("gfx/cloud.png")
  cloud.x = 4*cloud.width
  cloud.y = display.contentHeight/3
  
  cloud2 = display.newImage("gfx/cloud.png")
  cloud2.x = display.contentWidth/2 + 2*cloud.width
  cloud2.y = display.contentHeight/4
  
  cloud3 = display.newImage("gfx/cloud.png")
  cloud3.x = display.contentWidth + 2*cloud.width
  cloud3.y = display.contentHeight/5

  bg_mid_1 = display.newImage("gfx/background_mid.png")
  bg_mid_1.width = display.contentWidth
  bg_mid_1.height = display.contentHeight
  bg_mid_1.x = display.contentWidth/2
  bg_mid_1.y = display.contentHeight/2

  bg_mid_2 = display.newImage("gfx/background_mid.png")
  bg_mid_2.width = display.contentWidth
  bg_mid_2.height = display.contentHeight
  bg_mid_2.x = display.contentWidth*1.5
  bg_mid_2.y = display.contentHeight/2

  bg_close_1 = display.newImage("gfx/background_close.png")
  bg_close_1.width = display.contentWidth
  --bg_close_1.height = display.contentHeight
  bg_close_1.x = display.contentWidth/2
  bg_close_1.y = display.contentHeight
  physics.addBody(bg_close_1, "static")

  bg_close_2 = display.newImage("gfx/background_close.png")
  bg_close_2.width = display.contentWidth
  --bg_close_2.height = display.contentHeight
  bg_close_2.x = display.contentWidth*1.5
  bg_close_2.y = display.contentHeight
  physics.addBody(bg_close_2, "static")

  sheetData2 = { width=64, height=58, numFrames=2, sheetContentWidth=128, sheetContentHeight=58 }
  mySheet2 = graphics.newImageSheet( "gfx/girl.png", sheetData )
  sequenceData2 = {{ name = "normalRun", start=1, count=2, time=500 }, { name="fastRun", start=1, count=2, time=100 },}
  mb1 = display.newSprite( mySheet2, sequenceData2 )
  mb1.x = display.contentWidth - 80
  mb1.y = display.contentHeight/2
  mb1:play()
  --mb1 = display.newImage("gfx/zoot2.png")
  --mb1.x = display.contentWidth - 80
  --mb1.y = display.contentHeight/2

  titleBoard = display.newImage("gfx/ready.png")
  titleBoard.width = display.contentWidth - 30
  titleBoard.x = display.contentWidth/2
  titleBoard.yDefault = display.contentWidth/4
  titleBoard.y = titleBoard.yDefault
  
  sheetData = { width=63, height=58, numFrames=2, sheetContentWidth=126, sheetContentHeight=58 }
  mySheet = graphics.newImageSheet( "gfx/koray.png", sheetData )
  sequenceData = {{ name = "normalRun", start=1, count=2, time=500 }, { name="fastRun", start=1, count=2, time=100 },}
  player = display.newSprite( mySheet, sequenceData )
  player.x = display.contentWidth/4  --center the sprite horizontally
  player.y = display.contentHeight/2  --center the sprite vertically
  player:play()
    
  jointHeight1 = display.contentHeight*2.5/3
  joint1U = display.newImage("gfx/joint.png")
  joint1U.x = display.contentWidth*2/3 + startLength
  joint1U.y = jointHeight1
  joint1U.width = display.contentWidth/5
  joint1U.height = display.contentHeight/2
  joint1D = display.newImage("gfx/joint2.png")
  joint1D.x = display.contentWidth*2/3 + startLength
  joint1D.y = jointHeight1 - (gap*joint1U.height + gap2*player.height)
  joint1D.width = display.contentWidth/5
  joint1D.height = display.contentHeight/2
  physics.addBody(joint1D, "static" ,{ shape=shapeD, bounce=0.6, friction=0.5 })
  physics.addBody(joint1U, "static" ,{ shape=shapeU, bounce=0.6, friction=0.5  })
  mb1.target = display.contentHeight - joint1U.height + jointHeight1 - (gap*joint1U.height + gap2*player.height) - mb1.height*1.5
  mb1.prevTarget = 0

  jointHeight2 = math.random(display.contentHeight/2,display.contentHeight)
  joint2U = display.newImage("gfx/joint.png")
  joint2U.x = display.contentWidth*2/3 + spacing + startLength
  joint2U.y = jointHeight2
  joint2U.width = display.contentWidth/5
  joint2U.height = display.contentHeight/2
  joint2D = display.newImage("gfx/joint2.png")
  joint2D.x = display.contentWidth*2/3 + spacing + startLength
  joint2D.y = jointHeight2 - (gap*joint1U.height + gap2*player.height)
  joint2D.width = display.contentWidth/5
  joint2D.height = display.contentHeight/2
  physics.addBody(joint2D, "static" ,{ shape=shapeD, bounce=0.6, friction=0.5  })
  physics.addBody(joint2U, "static" ,{ shape=shapeU, bounce=0.6, friction=0.5  })

  jointHeight3 = math.random(display.contentHeight/2,display.contentHeight)
  joint3U = display.newImage("gfx/joint.png")
  joint3U.x = display.contentWidth*2/3 + 2*spacing + startLength
  joint3U.y = jointHeight3
  joint3U.width = display.contentWidth/5
  joint3U.height = display.contentHeight/2
  joint3D = display.newImage("gfx/joint2.png")
  joint3D.x = display.contentWidth*2/3 + 2*spacing + startLength
  joint3D.y = jointHeight3 - (gap*joint1U.height + gap2*player.height)
  joint3D.width = display.contentWidth/5
  joint3D.height = display.contentHeight/2
  physics.addBody(joint3D, "static" ,{ shape=shapeD, bounce=0.6, friction=0.5  })
  physics.addBody(joint3U, "static" ,{ shape=shapeU, bounce=0.6, friction=0.5  })

  scoreBoard = display.newImage("gfx/score_board.png")
  scoreBoard.width = display.contentWidth
  scoreBoard.height = display.contentHeight/25
  --scoreBoard.x = display.contentWidth/2
  --scoreBoard.y = - scoreBoard.height + 2
  scoreBoard.x = display.contentWidth/2
  scoreBoard.y = scoreBoard.height
  --scoreBoard.alpha=0.0
  
  scoreBoard2 = display.newImage("gfx/score_board2.png")
  scoreBoard2.width = display.contentWidth
  scoreBoard2.height = display.contentHeight/25
  scoreBoard2.x = display.contentWidth/2
  scoreBoard2.y = scoreBoard.height
  scoreBoard2.alpha=0.0
  
  tapSheetData = { width=160, height=250, numFrames=2, sheetContentWidth=320, sheetContentHeight=250 }
  tapSheet = graphics.newImageSheet( "gfx/tap.png", tapSheetData )
  tapSequenceData = {{ name = "normalRun", start=1, count=2, time=600 },}
  tapBoard = display.newSprite( tapSheet, tapSequenceData )
  --local tapBoard = display.newImage("gfx/tap.png")
  tapBoard.width = display.contentWidth
  tapBoard.height = display.contentHeight/20
  tapBoard.x = display.contentWidth/2
  tapBoard.y = display.contentWidth*2.2/2
  tapBoard:play()

  gameOver = display.newImage("gfx/over.png")
  gameOver.width = display.contentWidth- 100
  gameOver.height = display.contentHeight/3
  gameOver.x = display.contentWidth/2
  gameOver.y = display.contentHeight/2
  gameOver.alpha = 0.0
  
  speech = display.newImage("gfx/speech.png")
  speech.width = speech.width/2
  speech.height = speech.height/2
  speech.x = -2*speech.width
  speech.y = 0

  
  
  hitSprite = display.newImage("gfx/hit.png")
  --hitSprite.width = speech.width/2
  --hitSprite.height = speech.height/2
  hitSprite.x = display.contentWidth/2
  hitSprite.y = display.contentWidth/2
  hitSprite.alpha=0.0
  
  whiteFade2 = display.newImage("gfx/fade.png")
  --whiteFade2.width = display.contentWidth
  --whiteFade2.height = display.contentHeight
  whiteFade2.x = display.contentWidth/2
  whiteFade2.y = display.contentHeight/2
  whiteFade2.alpha = 0
  
   whiteFade3 = display.newImage("gfx/fade2.png")
  --whiteFade3.width = display.contentWidth
  --whiteFade3.height = display.contentHeight
  whiteFade3.x = display.contentWidth/2
  whiteFade3.y = display.contentHeight/2
  whiteFade3.alpha = 0
  
  myText = display.newEmbossedText( text..tostring(score), scoreBoard.x*(1+0.15), scoreBoard.y, native.systemFont, scoreBoard.height )
  --myText.alpha=0.0
  audio.stop(backgroundMusicChannel)
  backgroundMusic = audio.loadStream("sound/song.ogg")
  backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=-1, fadein=10 }  )
  
  
  --joint4U = display.newImage("gfx/joint.png")
  --joint4U.x = display.contentWidth/2
  --joint4U.y = display.contentHeight/2
  --joint4U.width = display.contentWidth/5
  --joint4U.height = display.contentHeight/2
  --testPointU1 = display.newImage("gfx/hit2.png")
  --testPointU1.x = joint4U.x + shapeU[1]
  --testPointU1.y = joint4U.y + shapeU[2]
  --testPointU2 = display.newImage("gfx/hit2.png")
  --testPointU2.x = joint4U.x + shapeU[3]
  --testPointU2.y = joint4U.y + shapeU[4]
  --testPointU3 = display.newImage("gfx/hit2.png")
  --testPointU3.x = joint4U.x + shapeU[5]
  --testPointU3.y = joint4U.y + shapeU[6]
  --testPointU4 = display.newImage("gfx/hit2.png")
  --testPointU4.x = joint4U.x + shapeU[7]
  --testPointU4.y = joint4U.y + shapeU[8]
  --testPointU5 = display.newImage("gfx/hit2.png")
  --testPointU5.x = joint4U.x + shapeU[9]
  --testPointU5.y = joint4U.y + shapeU[10]
  --testPointU6 = display.newImage("gfx/hit2.png")
  --testPointU6.x = joint4U.x + shapeU[11]
  --testPointU6.y = joint4U.y + shapeU[12]
  --testPointU7 = display.newImage("gfx/hit2.png")
  --testPointU7.x = joint4U.x + shapeU[13]
  --testPointU7.y = joint4U.y + shapeU[14]
  --testPointU8 = display.newImage("gfx/hit2.png")
  --testPointU8.x = joint4U.x + shapeU[15]
  --testPointU8.y = joint4U.y + shapeU[16]
  
  --joint4D = display.newImage("gfx/joint2.png")
  --joint4D.x = display.contentWidth/2
  --joint4D.y = display.contentHeight/2
  --joint4D.width = display.contentWidth/5
  --joint4D.height = display.contentHeight/2
  --testPointD1 = display.newImage("gfx/hit2.png")
  --testPointD1.x = joint4D.x + shapeD[1]
  --testPointD1.y = joint4D.y + shapeD[2]
  --testPointD2 = display.newImage("gfx/hit2.png")
  --testPointD2.x = joint4D.x + shapeD[3]
  --testPointD2.y = joint4D.y + shapeD[4]
  --testPointD3 = display.newImage("gfx/hit2.png")
  --testPointD3.x = joint4D.x + shapeD[5]
  --testPointD3.y = joint4D.y + shapeD[6]
  --testPointD4 = display.newImage("gfx/hit2.png")
  --testPointD4.x = joint4D.x + shapeD[7]
  --testPointD4.y = joint4D.y + shapeD[8]
  --testPointD5 = display.newImage("gfx/hit2.png")
  --testPointD5.x = joint4D.x + shapeD[9]
  --testPointD5.y = joint4D.y + shapeD[10]
  --testPointD6 = display.newImage("gfx/hit2.png")
  --testPointD6.x = joint4D.x + shapeD[11]
  --testPointD6.y = joint4D.y + shapeD[12]
  --testPointD7 = display.newImage("gfx/hit2.png")
  --testPointD7.x = joint4D.x + shapeD[13]
  --testPointD7.y = joint4D.y + shapeD[14]
  --testPointD8 = display.newImage("gfx/hit2.png")
  --testPointD8.x = joint4D.x + shapeD[15]
  --testPointD8.y = joint4D.y + shapeD[16]

end  

titleScreen = function()
  
  bg = display.newImage("gfx/background_title.png")
  bg.width = display.contentWidth
  bg.height = display.contentHeight
  bg.x = display.contentWidth/2
  bg.y = display.contentHeight/2
  
  bg2 = display.newImage("gfx/background_title2.png")
  bg2.width = display.contentWidth
  bg2.height = display.contentHeight
  bg2.x = display.contentWidth/2
  bg2.y = display.contentHeight/2 - bg2.height
  
  bgBorder = display.newImage("gfx/background_border.png")
  bgBorder.width = display.contentWidth
  bgBorder.height = display.contentHeight/10
  bgBorder.x = display.contentWidth/2
  bgBorder.y = - bgBorder.height/2
  
  bgBorder2 = display.newImage("gfx/background_border.png")
  bgBorder2.width = display.contentWidth
  bgBorder2.height = display.contentHeight/10
  bgBorder2.x = display.contentWidth/2
  bgBorder2.y = display.contentHeight + bgBorder2.height/2

 
  
  clearLogo = display.newImage("gfx/clear2.png")
  clearLogo.width = display.contentWidth
  clearLogo.height = display.contentHeight
  clearLogo.x = display.contentWidth/2
  clearLogo.y = display.contentHeight/2
 
  titleBoard = display.newImage("gfx/flappy.png")
  titleBoard.width = display.contentWidth - 30
  --titleBoard.height = display.contentHeight/20
  titleBoard.x = display.contentWidth*2
  titleBoard.y = display.contentHeight/2
  titleBoard:toFront()

  touchBoard = display.newImage("gfx/touch.png")
  touchBoard.width = display.contentWidth - 30
  --titleBoard.height = display.contentHeight/20
  touchBoard.x = display.contentWidth/2
  touchBoard.y = display.contentHeight*(3/4)
  touchBoard.alpha=0

  top = display.newRect( display.contentWidth/2, 0, display.contentWidth, 0 )
  physics.addBody(top, "static", {bounce = 0.5, friction= 0.5})
  bottom = display.newRect( display.contentWidth/2, display.contentHeight, display.contentWidth, 0 )
  physics.addBody(bottom, "static", {bounce = 0.1, friction= 2})
  left = display.newRect( 0, display.contentHeight/2, 0, display.contentHeight )
  --physics.addBody(left, "static", {bounce = 0.5, friction= 2})
  right = display.newRect( display.contentWidth, display.contentHeight/2, 0, display.contentHeight)
  physics.addBody(right, "static", {bounce = 0.5, friction= 2})
  
  sheetData = { width=64, height=58, numFrames=2, sheetContentWidth=128, sheetContentHeight=58 }
  mySheet = graphics.newImageSheet( "gfx/koray.png", sheetData )
  sequenceData = {{ name = "normalRun", start=1, count=2, time=500 },}
  player = display.newSprite( mySheet, sequenceData )
  player.x = -player.width  --center the sprite horizontally
  player.y = display.contentHeight/2  --center the sprite vertically
  physics.addBody(player, "dynamic")
  player:play()
  
  topGuard = display.newRect( player.x, player.y - player.width/2 - 20 , math.abs(player.x), 0 )
  physics.addBody(topGuard, "static", {bounce = 0.0, friction= 0})
  bottomGuard = display.newRect( player.x, player.y + player.width/2 + 20 , math.abs(player.x), 0 )
  physics.addBody(bottomGuard, "static", {bounce = 0.0, friction= 0})
  
  flapHandle = timer.performWithDelay( 350, listener, 0 )
  
   whiteFade = display.newImage("gfx/fade.png")
  --whiteFade.width = display.contentWidth
  --whiteFade.height = display.contentHeight
  whiteFade.x = display.contentWidth/2
  whiteFade.y = display.contentHeight/2
  whiteFade.alpha = 0
  audio.stop()
  backgroundMusic = audio.loadStream("sound/title_song.ogg")
  backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=-1, fadein=10 }  )
  

end

titleFinished = function(event)
  player:applyLinearImpulse( 4, 0, player.x+2, player.y+5 )
  audio.play(punchSound)
end

touchFinished1 = function(event)
  transition.to( touchBoard, { time=500, alpha=0, x=display.contentWidth/2, y=display.contentHeight*(3/4), onComplete=touchFinished2 })
end

touchFinished2 = function(event)
  transition.to( touchBoard, { time=500, alpha=1, x=display.contentWidth/2, y=display.contentHeight*(3/4), onComplete=touchFinished1 })
end

onEnterFrame = function( event )
  
  if mainGame == true then
    cloud.x = cloud.x - 0.2
	cloud2.x = cloud2.x - 0.1
	cloud3.x = cloud3.x - 0.5
    if cloud.x < -2*cloud.width then
      cloud.x = display.contentWidth + 2*cloud.width
	  cloud.y = math.random(display.contentHeight/2.5 , display.contentHeight/1.8)
    end
	if cloud2.x < -2*cloud.width then
      cloud2.x = display.contentWidth + 2*cloud.width
	  cloud2.y = math.random(display.contentHeight/2.5 , display.contentHeight/1.8)
    end
	if cloud3.x < -2*cloud.width then
      cloud3.x = display.contentWidth + 2*cloud.width
	  cloud3.y = math.random(display.contentHeight/2.5 , display.contentHeight/1.8)
    end
   
    mb1.rotation = 10*math.sin(beta)
    mb1.y = mb1.prevTarget + (mb1.target - mb1.prevTarget)*targetCounter/targetMax + 10*math.sin(alpha)
   
    if started == true then
      mb1.x = mb1.x + 2*math.sin(gamma)
    end
   
    speech.x = mb1.x - 40
    speech.y = mb1.y - 48
    --speech.x = mb1.x + 5
    --speech.y = mb1.y - 30
   
    if titleBoard ~= nil then
      titleBoard.y = titleBoard.yDefault + 2*math.sin(alpha/2)
	  titleBoard:toFront()
    end
   
    targetCounter = targetCounter + 1
    alpha = alpha + 0.2
    beta = beta + 0.1
    gamma = gamma + 0.05
   
    if targetCounter > targetMax then
      targetCounter = targetMax
    end
   
    if alpha > 360 then
      alpha = 0
    end
   
    if beta > 90 then
      beta = -90
    end
   
    if gamma > 180 then
      gamma = 0
    end
   
    if alive then
      bg_mid_1.x =  bg_mid_1.x - 1
      bg_mid_2.x =  bg_mid_2.x - 1
   
      if bg_mid_1.x < -display.contentWidth/2 then
        bg_mid_1.x = display.contentWidth*1.5 - 2
      end
   
      if bg_mid_2.x < -display.contentWidth/2 then
        bg_mid_2.x = display.contentWidth*1.5 - 2
      end
   
      bg_close_1.x =  bg_close_1.x - 2
      bg_close_2.x =  bg_close_2.x - 2
   
      if bg_close_1.x < -display.contentWidth/2 then
        bg_close_1.x = display.contentWidth*1.5 - 2 
      end
   
      if bg_close_2.x < -display.contentWidth/2 then
        bg_close_2.x = display.contentWidth*1.5 - 2
      end
     
	  if started == true then
        local vx, vy = 1,1
	    if player ~= nil then
	      vx, vy = player:getLinearVelocity()
        end
	    player.angularVelocity = 0
        --player:rotate(0.01*vy)
	    player.rotation = 0.05*vy
      
	    joint1U.x = joint1U.x - 2
        joint1D.x = joint1D.x - 2
        joint2U.x = joint2U.x - 2
        joint2D.x = joint2D.x - 2
        joint3U.x = joint3U.x - 2
        joint3D.x = joint3D.x - 2
      end
   
      if joint1D.x < -joint1U.width then
        jointHeight1 = math.random(display.contentHeight/2,display.contentHeight)
	    joint1U.x = display.contentWidth*2/3 + startLength
        joint1U.y = jointHeight1
        joint1U.width = display.contentWidth/5
        joint1U.height = display.contentHeight/2
        joint1D.x = display.contentWidth*2/3 + startLength
        joint1D.y = jointHeight1 - (gap*joint1U.height + gap2*player.height)
        joint1D.width = display.contentWidth/5
        joint1D.height = display.contentHeight/2
	    joint1U.x = display.contentWidth + spacing/2
        joint1D.x = display.contentWidth + spacing/2
	    coinGot1=false
	    mbPassed1 = false
      end
   
      if joint2D.x < -joint2U.width then
	    jointHeight2 = math.random(display.contentHeight/2,display.contentHeight)
	    joint2U.x = display.contentWidth*2/3 + startLength
        joint2U.y = jointHeight2
        joint2U.width = display.contentWidth/5
        joint2U.height = display.contentHeight/2
        joint2D.x = display.contentWidth*2/3 + startLength
        joint2D.y = jointHeight2 - (gap*joint1U.height + gap2*player.height)
        joint2D.width = display.contentWidth/5
        joint2D.height = display.contentHeight/2
        joint2U.x = display.contentWidth + spacing/2
        joint2D.x = display.contentWidth + spacing/2
	    coinGot2=false
	    mbPassed2 = false
      end
   
      if joint3D.x < -joint3U.width then
	    jointHeight3 = math.random(display.contentHeight/2,display.contentHeight)
	    joint3U.x = display.contentWidth*2/3 + startLength
        joint3U.y = jointHeight3
        joint3U.width = display.contentWidth/5
        joint3U.height = display.contentHeight/2
        joint3D.x = display.contentWidth*2/3 + startLength
        joint3D.y = jointHeight3 - (gap*joint1U.height + gap2*player.height)
        joint3D.width = display.contentWidth/5
        joint3D.height = display.contentHeight/2
        joint3U.x = display.contentWidth + spacing/2
        joint3D.x = display.contentWidth + spacing/2
	    coinGot3=false
	    mbPassed3 = false
      end
	 
	  --pipes collision
	  if player.x > joint1D.x and not coinGot1 then
	    audio.play( coinSound )
	    score = score + 1
	    coinGot1=true
	    myText:removeSelf()
	     myText = display.newEmbossedText( text..tostring(score), scoreBoard.x*(1+0.15), scoreBoard.y, native.systemFont, scoreBoard.height )
	  end
	 
	  if player.x > joint2D.x and not coinGot2 then
	    audio.play( coinSound )
	    score = score + 1
	    coinGot2=true
	    myText:removeSelf()
	     myText = display.newEmbossedText( text..tostring(score), scoreBoard.x*(1+0.15), scoreBoard.y, native.systemFont, scoreBoard.height )
	  end
	 
	  if player.x > joint3D.x and not coinGot3 then
	    audio.play( coinSound )
	    score = score + 1
	    coinGot3=true
	    myText:removeSelf()
	    myText = display.newEmbossedText( text..tostring(score), scoreBoard.x*(1+0.15), scoreBoard.y, native.systemFont, scoreBoard.height )
	  end
	 
	  --chase item collision
	  if mb1.x > joint1D.x + joint1D.width and not mbPassed1 then
	    mb1.prevTarget = mb1.target
	    mb1.target = display.contentHeight - joint1U.height + jointHeight2 - (gap*joint1U.height + gap2*player.height) - mb1.height*1.5
	    mbPassed1 = true
	    targetCounter = 0
	  end
	 
	  if mb1.x > joint2D.x + joint2D.width and not mbPassed2 then
	    mb1.prevTarget = mb1.target
	    mb1.target = display.contentHeight - joint2U.height + jointHeight3 - (gap*joint1U.height + gap2*player.height) - mb1.height*1.5
	    mbPassed2 = true
	    targetCounter = 0
	  end
	 
	  if mb1.x > joint3D.x + joint3D.width and not mbPassed3 then
	    mb1.prevTarget = mb1.target
	    mb1.target = display.contentHeight - joint3U.height + jointHeight1 - (gap*joint1U.height + gap2*player.height) - mb1.height*1.5
	    mbPassed3 = true
	    targetCounter = 0
	  end
	 
    else
      mb1.x = mb1.x +2
    end
  
  else  --title screen
    
	bg.y = bg.y + 1
	bg2.y = bg2.y + 1
	
	if bg.y > bg.height*3/2 then
	  bg.y = display.contentHeight/2 - bg.height + 1
	end
	
	if bg2.y > bg2.height*3/2 then
	  bg2.y = display.contentHeight/2 - bg2.height +1
	end
	--bgBorder:toFront()
	--bgBorder2:toFront()
	--titleBoard:toFront()
	--player:toFront()
	
	if flaps > 18 then
      titleBoard.y = titleBoard.y + 0.3*math.sin(theta1)
      theta1 = theta1 + 0.2
      if theta1 > 360 then
        theta1 = 0
      end
	  if not touchDone then
	    transition.to( touchBoard, { time=300, alpha=1, x=display.contentWidth/2, y=display.contentHeight*(3/4), onComplete=touchFinished1 })
	    Runtime:addEventListener( "touch", onTouch )
	    touchDone = true
	  end
    end
  
    if flaps> 10 then
      if not titleDone then
	    physics.addBody(left, "static", {bounce = 0.5, friction= 2})
	    transition.to( titleBoard, { time=300, alpha=1, x=display.contentWidth/2, y=player.y+titleBoard.height/2, onComplete=titleFinished })
        titleDone = true
	  end
    else
      player.x = player.x +1
	  player.rotation = 0
    end
  
  end
   
end


reset = function()
  gameOverGroup:remove( hiText )
  gameOverGroup:remove( quitButton )
  gameOverGroup:remove( playButton )
  gameOverGroup:remove( dieBoard )
  dieBoard:removeSelf()
  playButton:removeSelf()
  quitButton:removeSelf()
  hiText:removeSelf()
  gameOverGroup:removeSelf()
  physics.removeBody( player )
  score = 0
  myText:removeSelf()
  myText = display.newEmbossedText( text..tostring(score), scoreBoard.x*(1+0.15), scoreBoard.y, native.systemFont, scoreBoard.height )
  alive = true
  died = false
  coinGot3=false
  coinGot2=false
  coinGot1=false
  player.x = display.contentWidth/4 
  player.y = display.contentHeight/2  
  player.rotation = 0
  player:setSequence( "normalRun" )
  player:play()
  mb1.x = display.contentWidth - 80
  mbPassed1 = false
  mbPassed2 = false
  mbPassed3 = false
  jointHeight1 = display.contentHeight*2.5/3
  joint1U.x = display.contentWidth*2/3 + startLength
  joint1U.y = jointHeight1
  joint1U.width = display.contentWidth/5
  joint1U.height = display.contentHeight/2
  joint1D.x = display.contentWidth*2/3 + startLength
  joint1D.y = jointHeight1 - (gap*joint1U.height + gap2*player.height)
  joint1D.width = display.contentWidth/5
  joint1D.height = display.contentHeight/2
  mb1.prevTarget = 0
  mb1.target = display.contentHeight - joint1U.height + jointHeight1 - (gap*joint1U.height + gap2*player.height) - mb1.height*1.5
  jointHeight2 = math.random(display.contentHeight/2,display.contentHeight)
  joint2U.x = display.contentWidth*2/3 + spacing + startLength
  joint2U.y = jointHeight2
  joint2U.width = display.contentWidth/5
  joint2U.height = display.contentHeight/2
  joint2D.x = display.contentWidth*2/3 + spacing + startLength
  joint2D.y = jointHeight2 - (gap*joint1U.height + gap2*player.height)
  joint2D.width = display.contentWidth/5
  joint2D.height = display.contentHeight/2
  jointHeight3 = math.random(display.contentHeight/2,display.contentHeight)
  joint3U.x = display.contentWidth*2/3 + 2*spacing + startLength
  joint3U.y = jointHeight3
  joint3U.width = display.contentWidth/5
  joint3U.height = display.contentHeight/2
  joint3D.x = display.contentWidth*2/3 + 2*spacing + startLength
  joint3D.y = jointHeight3 - (gap*joint1U.height + gap2*player.height)
  joint3D.width = display.contentWidth/5
  joint3D.height = display.contentHeight/2
  tapBoard = display.newSprite( tapSheet, tapSequenceData )
  tapBoard.width = display.contentWidth
  tapBoard.height = display.contentHeight/20
  tapBoard.x = display.contentWidth/2
  tapBoard.y = display.contentWidth*2.2/2
  tapBoard:play()
  titleBoard = display.newImage("gfx/ready.png")
  titleBoard.width = display.contentWidth - 30
  titleBoard.x = display.contentWidth/2
  titleBoard.yDefault = display.contentWidth/4
  titleBoard.y = titleBoard.yDefault

end


createDieBoard = function()
  
  audio.play( whoosh1Sound )
  
  dieBoard = display.newImage("gfx/retry_board.png")
  dieBoard.width = display.contentWidth- 100
  dieBoard.height = display.contentHeight/3
  dieBoard.x = display.contentWidth/2
  dieBoard.y = display.contentHeight/2
  playButton = display.newImage("gfx/play.png")
  playButton.width = dieBoard.width/2.5
  playButton.height = dieBoard.height/2.5
  playButton.x = dieBoard.x - dieBoard.width/4.5
  playButton.y = dieBoard.y + dieBoard.height/6
  playButton:addEventListener( "touch", onPlayButton )
  quitButton = display.newImage("gfx/quit.png")
  quitButton.width = dieBoard.width/2.5
  quitButton.height = dieBoard.height/2.5
  quitButton.x = dieBoard.x + dieBoard.width/4.5
  quitButton.y = dieBoard.y + dieBoard.height/6
  quitButton:addEventListener( "touch", onQuitButton )
  hiText = display.newEmbossedText( tostring(hiScore), dieBoard.x, dieBoard.y - dieBoard.width/8, native.systemFont, 35 )
  retry()
end

removeDieBoard = function()
  gameOver.alpha = 0.0
end

retry = function()
  gameOverGroup = display.newGroup()
  gameOverGroup.width = display.contentWidth- 100
  gameOverGroup.height = display.contentHeight/3  
  gameOverGroup.x = display.contentWidth/2
  gameOverGroup.y = display.contentHeight/2
  gameOverGroup:insert( dieBoard )
  gameOverGroup:insert( playButton )
  gameOverGroup:insert( quitButton )
  gameOverGroup:insert( hiText )
  --gameOverGroup.alpha = 0
  transition.to( gameOverGroup, { time=200, alpha=1, x=0, y=0, onComplete=removeDieBoard})
end


playLaugh = function() 
  
  local rand = math.random(0,6)
  
  if rand < 1 then
    audio.play(laugh1Sound)
  elseif rand < 2 then
    audio.play(laugh2Sound)
  elseif rand < 3 then
    audio.play(laugh3Sound)
  elseif rand < 4 then
    audio.play(laugh4Sound)
  elseif rand < 5 then
    audio.play(laugh5Sound)
  else
    audio.play(laugh6Sound)
  end

end  


die = function()
  gameOver.alpha = 1.0
  gameOver:toFront()
  playLaugh()
  retryPossible = false
  if score > hiScore then
    hiScore = score
	saveScore()
  end
  alive = false
  started = false
  player:pause()
  timer.performWithDelay( 3000, createDieBoard )
  
end


retryPos = function()
  retryPossible = true  
end

onPlayComplete = function(event)
  transition.cancel()
  whiteFade2.alpha = 0
  reset()
  timer.performWithDelay( 100, retryPos )
  transition2 = false
  scoreBoard2.alpha=0.0
end

onQuitComplete = function(event)
  Runtime:removeEventListener( "collision", onCollision )
  transition.cancel()
  whiteFade3.alpha = 0
  physics.removeBody( player )
  score = 0
  myText:removeSelf()
  mainGame = false
  alive = true
  died = false
  myText=nil
  started = false
  coinGot3=false
  coinGot2=false
  coinGot1=false
  score = 0
  mbPassed1 = false
  mbPassed2 = false
  mbPassed3 = false
  targetCounter = 0
  retryPossible = true
  flaps = 0
  titleDone = false
  touchDone = false
  theta1 = 0
  

  flaps = 0
  titleDone = false
  touchDone = false
  clearMain()
  Runtime:removeEventListener( "touch", onTouch )
  titleScreen()

  --timer.performWithDelay( 100, retryPos )
  transition1 = false
  transition2 = false
  transition3 = false
end

onPlayButton = function(event)
  if event.phase == "ended" and transition2 == false then
    audio.play( whoosh2Sound )
	quitButton:removeEventListener( "touch", onQuitButton )
    playButton:removeEventListener( "touch", onPlayButton )
	whiteFade2:toFront()
	transition.to( whiteFade2, { time=250, delay=0, alpha=1.0, onComplete=onPlayComplete} )
	transition2 = true
  end
end

onQuitButton = function(event)
  if event.phase == "ended" and transition3 == false then
    audio.play( whoosh3Sound )
	--audio.fadeOut( { channel=1, time=400 } )
	quitButton:removeEventListener( "touch", onQuitButton )
    playButton:removeEventListener( "touch", onPlayButton )
	whiteFade3:toFront()
    transition.to( whiteFade3, { time=500, delay=0, alpha=1.0, onComplete=onQuitComplete} )
	transition3 = true
  end
end

pauseFlap = function()
  player:pause()
end

onTouch = function( event )
  if mainGame == true then
    if retryPossible == true then
      if alive == true then
        if started == true then
	      if event.phase == "began" and alive == true then
	        if player.y>0 then
		      player:applyLinearImpulse( 0, -0.2, player.x, player.y )
			  player:setSequence( "fastRun" )
			  player:play({endFrame=0})
			  timer.performWithDelay( 300, pauseFlap )
		      audio.play( flapSound )
		    end
	      end    
        else
          display.remove(tapBoard)
	      display.remove(titleBoard)
		  scoreBoard2.alpha=1.0
	      titleBoard=nil
	      physics.addBody(player, "dynamic", { density=0.01, friction=0.3, bounce=0.2, radius=20.0 })
	      started = true
	      if alive == true then
	        if player.y>0 then
		      player:applyLinearImpulse( 0, -0.2, player.x, player.y )
			  player:setSequence( "fastRun" )
			  player:play({endFrame=0})
			  timer.performWithDelay( 300, pauseFlap )
		      audio.play( flapSound )
		    end
	      end
	    end
	  end
    end
  else
    if event.phase == "ended" and transition1 == false then
	  --audio.fadeOut( { channel=1, time=500 } )
	  audio.stop()
	  audio.play( startSound )
	  transition.to( whiteFade, { time=2000, alpha=1, x=whiteFade.x, y=whiteFade.y, onComplete=clearTitle })
	  transition1 = true
	  
	end
  end
end

clearTitle = function(event)
  transition.cancel()
  whiteFade.alpha = 0
  audio.setVolume( 1.0, { channel=1 } )
  timer.cancel( flapHandle )
  titleBoard:removeSelf()
  touchBoard:removeSelf()
  physics.removeBody(top)
  top:removeSelf()
  physics.removeBody(bottom)
  bottom:removeSelf()
  physics.removeBody(left)
  left:removeSelf()
  physics.removeBody(right)
  right:removeSelf()
  bg:removeSelf()
  bg2:removeSelf()
  bgBorder:removeSelf()
  bgBorder2:removeSelf()
  clearLogo:removeSelf()
  physics.removeBody(player)
  player:removeSelf()
  main()
  mainGame=true
  Runtime:addEventListener( "collision", onCollision )
  
end

clearMain = function(event)
  bg_far:removeSelf() 
  cloud:removeSelf() 
  cloud2:removeSelf() 
  cloud3:removeSelf() 
  bg_mid_1:removeSelf() 
  bg_mid_2:removeSelf() 
  bg_close_1:removeSelf() 
  bg_close_2:removeSelf() 
  mb1:removeSelf()  
  physics.removeBody(joint1D, "static")
  physics.removeBody(joint1U, "static")
  joint1U:removeSelf() 
  joint1D:removeSelf() 
  physics.removeBody(joint2D, "static")
  physics.removeBody(joint2U, "static")
  joint2U:removeSelf() 
  joint2D:removeSelf() 
  physics.removeBody(joint3D, "static")
  physics.removeBody(joint3U, "static")
  joint3U:removeSelf() 
  joint3D:removeSelf() 
  scoreBoard:removeSelf() 
  scoreBoard2:removeSelf() 
  speech:removeSelf() 
  hitSprite:removeSelf()
  player:removeSelf() 
  whiteFade2:removeSelf() 
  whiteFade3:removeSelf() 
  --backgroundMusic = audio.loadStream("sound/song.ogg")
  --backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=-1, fadein=5000 }  )
end


onShake = function(event)
    if event.isShake then
        
    end
end


onCollision = function(event)

    if event.object1==scoreBoard or event.object2==scoreBoard  then
	  return
	end

    if ( event.phase == "began" ) then
        if died == true then
		  --
		else 
		  hitSprite:toFront()
		  hitSprite.x = player.x + 20
		  hitSprite.y = player.y
		  hitSprite.alpha = 1.0
		  transition.to( hitSprite, { time=500, alpha=0,})
		  audio.play( punchSound )
          die()
          died = true		  
        end
		
    elseif ( event.phase == "ended" ) then

    end
end


onKeyEvent = function( event )
    -- Print which key was pressed down/up to the log.
    local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
    print( message )

    -- If the "back" key was pressed on Android, then prevent it from backing out of your app.
    if (event.keyName == "back") and (system.getInfo("platformName") == "Android") then
        return true
    end

    -- Return false to indicate that this app is *not* overriding the received key.
    -- This lets the operating system execute its default handling of this key.
    return false
end


saveScore = function()
   local path = system.pathForFile( fileName, system.DocumentsDirectory )
   local file = io.open(path, "w")
   if ( file ) then
      local contents = tostring( hiScore )
      file:write( contents )
      io.close( file )
      
   else
      print( "Error: could not read ", fileName, "." )
      
   end
end


loadScore = function()
   local path = system.pathForFile( fileName, system.DocumentsDirectory )
   local contents = ""
   local file = io.open( path, "r" )
   if ( file ) then
      -- read all contents of file into a string
      local contents = file:read( "*a" )
      local score = tonumber(contents);
      io.close( file )
      hiScore = score
   else
      print( "Error: could not read scores from ", fileName, "." )
   end
   
end


function listener:timer( event )
	player:applyLinearImpulse( 0, -0.3, player.x, player.y )
	audio.play(flapSound)
	flaps = flaps + 1
end



display.setStatusBar( display.HiddenStatusBar )
loadScore()
Runtime:addEventListener( "key", onKeyEvent );
Runtime:addEventListener( "enterFrame", onEnterFrame )
Runtime:addEventListener("accelerometer", onShake)
if mainGame == true then
  main()
  Runtime:addEventListener( "touch", onTouch )
  Runtime:addEventListener( "collision", onCollision )
else
  titleScreen()
end



