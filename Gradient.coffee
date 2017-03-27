###
	# USING THE GRADIENT MODULE
	
	# Require the module
	gradient = require "Gradient"
	
	# Apply a gradient
	layerA.style.background = gradient.top("yellow", "red")
	layerA.style.background = gradient.bottom("yellow", "red")
	layerA.style.background = gradient.left("yellow", "red")
	layerA.style.background = gradient.right("yellow", "red")
	layerA.style.background = gradient.angle("yellow", "red", -60)
	
	# Three-color gradient syntax
	layerA.style.background = gradient.topThreeColor("yellow", "red", "green")
	layerA.style.background = gradient.bottomThreeColor("yellow", "red", "green")
	layerA.style.background = gradient.leftThreeColor("yellow", "red", "green")
	layerA.style.background = gradient.rightThreeColor("yellow", "red", "green")
	layerA.style.background = gradient.angleThreeColor("yellow", "red", "green", -60)
	
	# Radial gradients
	layerA.style.background = gradient.radial("yellow", "red")
	layerA.style.background = gradient.radialThreeColor("yellow", "red", "green")
	
	# Reshape a radial gradient
	layerA.style.background = gradient.radial("yellow", "red", originX: 0.5, originY: 0, scaleX: 2, scaleY: 1)
	
	# originX, originY, scaleX and scaleY are percentages.
	# An originX,originY of 0,0 centers the gradient in the upper left while
	# 1,1 centers it in the lower right. 0.5,0.5 is the default center.
	
	# Optionally set the gradient's spread
	layerA.style.background = gradient.top("yellow", "red", spread: 0.5) # 1 is default, 0 is no transition between colors
	
	# Optionally set the gradient's offset (linear gradients only)
	layerA.style.background = gradient.top("yellow", "red", offset: 10) # 0 is no offset, 100 will push the gradient out of view
	
	# Optionally change the CSS prefix
	layerA.style.background = gradient.top("yellow", "red", prefix: "moz") # webkit is default, hyphens are added for you
	
	# GRADIENT LAYERS
	# While a gradient can be applied to any existing layer, for convenience it is
	# possible to create two types of gradient layers. If you wish to animate your
	# gradients you will need to do so using one of these classes.
	
	layerA = new gradient.Layer
		firstColor: <string> (hex or rgba or named color)
		secondColor: <string> (hex or rgba or named color)
		thirdColor: <string> (hex or rgba or named color)
		direction: <string> ("top" || "bottom" || "left" || "right") or <number> (in degrees)
		prefix: <string> (hyphens are added for you)
		spread: <number> (0 is no transition)
		offset: <number>
	
	layerA = new gradient.RadialLayer
		firstColor: <string> (hex or rgba or named color)
		secondColor: <string> (hex or rgba or named color)
		thirdColor: <string> (hex or rgba or named color)
		prefix: <string> (hyphens are added for you)
		spread: <number> (0 is no transition)
		offset: <number>
		gradientOriginX: <number> (0 is left, 1 is right)
		gradientOriginY: <number> (0 is top, 1 is bottom)
		gradientScaleX: <number> (percentage, 1 is 100% scale)
		gradientScaleY: <number> (percentage, 1 is 100% scale)
		
	# ANIMATING GRADIENTS
	
	layerA.animateGradient(<arguments>)
	
	# Arguments
	firstColor: <string> (hex or rgba or named color)
	secondColor: <string> (hex or rgba or named color)
	thirdColor: <string> (hex or rgba or named color)
	direction: <string> ("top" || "bottom" || "left" || "right") or <number> (in degrees)
	spread: <number>
	offset: <number>
	time: <number>
	curve: <string> ("linear" || "ease-in" || "ease-out" || "ease-in-out" )
	
	# Arguments for radial gradient animation
	originX: <number> (0 is left, 1 is right)
	originY: <number> (0 is top, 1 is bottom)
	scaleX: <number> (percentage, 1 is 100% scale)
	scaleY: <number> (percentage, 1 is 100% scale)
	
	# Examples
	layerA.animateGradient(direction: -60, spread: 2, offset: 0, time: 2)
	layerA.animateGradient(offset: -50, curve: "ease-in-out")
	layerA.animateGradient(secondColor: "blue", spread: 0.5, scaleX: 2, originY: 1)
###

# string generators
makeGradientString = ({direction, firstColor, secondColor, prefix, spread, offset, angle}) ->
	angle ?= false
	if angle == true
		direction = direction + "deg"
	return "#{prefix}linear-gradient(#{direction}, #{firstColor} #{Utils.modulate(spread, [1, 0], [0, 50], false) + offset}%, #{secondColor} #{Utils.modulate(spread, [1, 0], [100, 50], false) + offset}%)"

makeGradientThreeColorString = ({direction, firstColor, secondColor, thirdColor, prefix, spread, offset, angle}) ->
	angle ?= false
	if angle == true
		direction = direction + "deg"
	return "#{prefix}linear-gradient(#{direction}, #{firstColor} #{Utils.modulate(spread, [1, 0], [0, 50], false) + offset}%, #{secondColor} #{50 + offset}%, #{thirdColor} #{Utils.modulate(spread, [1, 0], [100, 50], false) + offset}%)"

makeRadialGradientString = ({firstColor, secondColor, prefix, spread, ellipseX, ellipseY, ellipseWidth, ellipseHeight}) ->
	return "#{prefix}radial-gradient(#{ellipseX}% #{ellipseY}%, #{ellipseWidth}% #{ellipseHeight}%, #{firstColor} #{Utils.modulate(spread, [1, 0], [0, 50], false)}%, #{secondColor} #{Utils.modulate(spread, [1, 0], [100, 50], false)}%)"

makeRadialGradientThreeColorString = ({firstColor, secondColor, thirdColor, prefix, spread, ellipseX, ellipseY, ellipseWidth, ellipseHeight}) ->
	return "#{prefix}radial-gradient(#{ellipseX}% #{ellipseY}%, #{ellipseWidth}% #{ellipseHeight}%, #{firstColor} #{Utils.modulate(spread, [1, 0], [0, 50], false)}%, #{secondColor} 50%, #{thirdColor} #{Utils.modulate(spread, [1, 0], [100, 50], false)}%)"

# animation curves
linear = (t) ->
	return t

easeIn = (t) ->
	# quad function
	return t*t

easeOut = (t) ->
	# quad function
	return t*(2-t)
	
easeInOut = (t) ->
	# cubic function
	if t < .5
		return 4 * t * t * t
	else
		return (t - 1) * (2 * t - 2) * (2 * t - 2) + 1

# gradient directions
exports.top = (firstColor = "white", secondColor = "black", {prefix, spread, offset} = {}) ->
	prefix ?= "webkit"
	spread ?= 1
	offset ?= 0
	if prefix != ""
		prefix = "-" + prefix + "-"
	return makeGradientString(direction: "top", firstColor: firstColor, secondColor: secondColor, prefix: prefix, spread: spread, offset: offset)

exports.topThreeColor = (firstColor = "white", secondColor = "gray", thirdColor = "black", {prefix, spread, offset} = {}) ->
	prefix ?= "webkit"
	spread ?= 1
	offset ?= 0
	if prefix != ""
		prefix = "-" + prefix + "-"
	return makeGradientThreeColorString(direction: "top", firstColor: firstColor, secondColor: secondColor, thirdColor: thirdColor, prefix: prefix, spread: spread, offset: offset)

exports.bottom = (firstColor = "white", secondColor = "black", {prefix, spread, offset} = {}) ->
	prefix ?= "webkit"
	spread ?= 1
	offset ?= 0
	if prefix != ""
		prefix = "-" + prefix + "-"
	return makeGradientString(direction: "bottom", firstColor: firstColor, secondColor: secondColor, prefix: prefix, spread: spread, offset: offset)
	
exports.bottomThreeColor = (firstColor = "white", secondColor = "gray", thirdColor = "black", {prefix, spread, offset} = {}) ->
	prefix ?= "webkit"
	spread ?= 1
	offset ?= 0
	if prefix != ""
		prefix = "-" + prefix + "-"
	return makeGradientThreeColorString(direction: "bottom", firstColor: firstColor, secondColor: secondColor, thirdColor: thirdColor, prefix: prefix, spread: spread, offset: offset)

exports.left = (firstColor = "white", secondColor = "black", {prefix, spread, offset} = {}) ->
	prefix ?= "webkit"
	spread ?= 1
	offset ?= 0
	if prefix != ""
		prefix = "-" + prefix + "-"
	return makeGradientString(direction: "left", firstColor: firstColor, secondColor: secondColor, prefix: prefix, spread: spread, offset: offset)

exports.leftThreeColor = (firstColor = "white", secondColor = "gray", thirdColor = "black", {prefix, spread, offset} = {}) ->
	prefix ?= "webkit"
	spread ?= 1
	offset ?= 0
	if prefix != ""
		prefix = "-" + prefix + "-"
	return makeGradientThreeColorString(direction: "left", firstColor: firstColor, secondColor: secondColor, thirdColor: thirdColor, prefix: prefix, spread: spread, offset: offset)
	
exports.right = (firstColor = "white", secondColor = "black", {prefix, spread, offset} = {}) ->
	prefix ?= "webkit"
	spread ?= 1
	offset ?= 0
	if prefix != ""
		prefix = "-" + prefix + "-"
	return makeGradientString(direction: "right", firstColor: firstColor, secondColor: secondColor, prefix: prefix, spread: spread, offset: offset)
	
exports.rightThreeColor = (firstColor = "white", secondColor = "gray", thirdColor = "black", {prefix, spread, offset} = {}) ->
	prefix ?= "webkit"
	spread ?= 1
	offset ?= 0
	if prefix != ""
		prefix = "-" + prefix + "-"
	return makeGradientThreeColorString(direction: "right", firstColor: firstColor, secondColor: secondColor, thirdColor: thirdColor, prefix: prefix, spread: spread, offset: offset)

exports.angle = (firstColor = "white", secondColor = "black", degrees = 135, {prefix, spread, offset} = {}) ->
	prefix ?= "webkit"
	spread ?= 1
	offset ?= 0
	if prefix != ""
		prefix = "-" + prefix + "-"
	return makeGradientString(direction: degrees, firstColor: firstColor, secondColor: secondColor, prefix: prefix, spread: spread, offset: offset, angle: true)

exports.angleThreeColor = (firstColor = "white", secondColor = "gray", thirdColor = "black", degrees = 135, {prefix, spread, offset} = {}) ->
	prefix ?= "webkit"
	spread ?= 1
	offset ?= 0
	if prefix != ""
		prefix = "-" + prefix + "-"
	return makeGradientThreeColorString(direction: degrees, firstColor: firstColor, secondColor: secondColor, thirdColor: thirdColor, prefix: prefix, spread: spread, offset: offset, angle: true)

exports.radial = (firstColor = "white", secondColor = "black", {prefix, spread, originX, originY, scaleX, scaleY} = {}) ->
	prefix ?= "webkit"
	spread ?= 1
	originX ?= 0.5
	originY ?= 0.5
	originX = originX * 100
	originY = originY * 100
	scaleX ?= 1
	scaleY ?= 1
	scaleX = Utils.modulate(scaleX, [0, 100], [0, 70]) * 100
	scaleY = Utils.modulate(scaleY, [0, 100], [0, 70]) * 100
	if prefix != ""
		prefix = "-" + prefix + "-"
	return makeRadialGradientString(firstColor: firstColor, secondColor: secondColor, prefix: prefix, spread: spread, ellipseX: originX, ellipseY: originY, ellipseWidth: scaleX, ellipseHeight: scaleY)

defaults =
	direction: "top"
	firstColor: "white"
	secondColor: "black"
	thirdColor: ""
	prefix: "webkit"
	spread: 1
	offset: 0
	angle: false
	gradientOriginX: 0.5
	gradientOriginY: 0.5
	gradientScaleX: 1
	gradientScaleY: 1
	
exports.radialThreeColor = (firstColor = "white", secondColor = "gray", thirdColor = "black", {prefix, spread, originX, originY, scaleX, scaleY} = {}) ->
	prefix ?= "webkit"
	spread ?= 1
	originX ?= 0.5
	originY ?= 0.5
	originX = originX * 100
	originY = originY * 100
	scaleX ?= 1
	scaleY ?= 1
	scaleX = Utils.modulate(scaleX, [0, 100], [0, 70]) * 100
	scaleY = Utils.modulate(scaleY, [0, 100], [0, 70]) * 100
	if prefix != ""
		prefix = "-" + prefix + "-"
	return makeRadialGradientThreeColorString(firstColor: firstColor, secondColor: secondColor, thirdColor: thirdColor, prefix: prefix, spread: spread, ellipseX: originX, ellipseY: originY, ellipseWidth: scaleX, ellipseHeight: scaleY)

# gradient layers
class exports.Layer extends Layer
	constructor: (@options={}) ->
		@options = _.assign({}, defaults, @options)
		super @options
		if @options.prefix != ""
			@options.prefix = "-" + @options.prefix + "-"
		if typeof @options.direction is "number"
			@options.angle = true
		gradient = ""
		if @options.thirdColor == ""
			gradient = makeGradientString(direction: @options.direction, firstColor: @options.firstColor, secondColor: @options.secondColor, prefix: @options.prefix, spread: @options.spread, offset: @options.offset, angle: @options.angle)
		else
			gradient = makeGradientThreeColorString(direction: @options.direction, firstColor: @options.firstColor, secondColor: @options.secondColor, thirdColor: @options.thirdColor, prefix: @options.prefix, spread: @options.spread, offset: @options.offset, angle: @options.angle)
		@.style.background = gradient
	
	animateGradient: ({firstColor, secondColor, thirdColor, spread, offset, direction, time, curve} = {}, frame = 0) ->
		firstColor ?= @options.firstColor
		secondColor ?= @options.secondColor
		thirdColor ?= @options.thirdColor
		spread ?= @options.spread
		offset ?= @options.offset 
		direction ?= @options.direction
		time ?= Framer.Defaults.Animation.time
		curve ?= "ease-out"
		totalFrames = time / Framer.Loop.delta
		if typeof @options.direction is "string"
			switch @options.direction
				when "top"
					startDirection = -90
				when "bottom"
					startDirection = 90
				when "left"
					startDirection = 0
				when "right"
					startDirection = 180
		else
			startDirection = @options.direction
		if typeof direction is "string"
			switch direction
				when "top"
					targetDirection = -90
				when "bottom"
					targetDirection = 90
				when "left"
					targetDirection = 0
				when "right"
					targetDirection = 180
		else
			targetDirection = direction
		if frame < totalFrames
			switch curve
				when "linear"
					easedFrame = linear(frame/totalFrames)
				when "ease-in"
					easedFrame = easeIn(frame/totalFrames)
				when "ease-out"
					easedFrame = easeOut(frame/totalFrames)
				when "ease-in-out"
					easedFrame = easeInOut(frame/totalFrames)
				else
					easedFrame = linear(frame/totalFrames)
			frameFirstColor = Color.mix(@options.firstColor, firstColor, easedFrame)
			frameSecondColor = Color.mix(@options.secondColor, secondColor, easedFrame)
			if @options.thirdColor != ""
				frameThirdColor = Color.mix(@options.thirdColor, thirdColor, easedFrame)
			frameSpread = Utils.modulate(easedFrame, [0, 1], [@options.spread, spread])
			frameOffset = Utils.modulate(easedFrame, [0, 1], [@options.offset, offset])
			frameDirection = Utils.modulate(easedFrame, [0, 1], [startDirection, targetDirection])
			if @options.thirdColor == ""
				gradient = makeGradientString(direction: frameDirection, firstColor: frameFirstColor, secondColor: frameSecondColor, prefix: @options.prefix, spread: frameSpread, offset: frameOffset, angle: true)
			else
				gradient = makeGradientThreeColorString(direction: frameDirection, firstColor: frameFirstColor, secondColor: frameSecondColor, thirdColor: frameThirdColor, prefix: @options.prefix, spread: frameSpread, offset: frameOffset, angle: true)
			@.style.background = gradient
			Utils.delay Framer.Loop.delta, =>
				@animateGradient({firstColor: firstColor, secondColor: secondColor, thirdColor: thirdColor, spread: spread, offset: offset, direction: direction, time: time, curve: curve}, frame + 1)

class exports.RadialLayer extends Layer
	constructor: (@options={}) ->
		@options = _.assign({}, defaults, @options)
		super @options
		if @options.prefix != ""
			@options.prefix = "-" + @options.prefix + "-"
		gradientOriginX = @options.gradientOriginX * 100
		gradientOriginY = @options.gradientOriginY * 100
		gradientScaleX = Utils.modulate(@options.gradientScaleX, [0, 100], [0, 70]) * 100
		gradientScaleY = Utils.modulate(@options.gradientScaleY, [0, 100], [0, 70]) * 100
		gradient = ""
		if @options.thirdColor == ""
			gradient = makeRadialGradientString(firstColor: @options.firstColor, secondColor: @options.secondColor, prefix: @options.prefix, spread: @options.spread, ellipseX: gradientOriginX, ellipseY: gradientOriginY, ellipseWidth: gradientScaleX, ellipseHeight: gradientScaleY)
		else
			gradient = makeRadialGradientThreeColorString(firstColor: @options.firstColor, secondColor: @options.secondColor, thirdColor: @options.thirdColor, prefix: @options.prefix, spread: @options.spread, ellipseX: gradientOriginX, ellipseY: gradientOriginY, ellipseWidth: gradientScaleX, ellipseHeight: gradientScaleY)
		@.style.background = gradient

	animateGradient: ({firstColor, secondColor, thirdColor, originX, originY, scaleX, scaleY, spread, time, curve} = {}, frame = 0) ->
		firstColor ?= @options.firstColor
		secondColor ?= @options.secondColor
		thirdColor ?= @options.thirdColor
		originX ?= @options.gradientOriginX
		originY ?= @options.gradientOriginY
		scaleX ?= @options.gradientScaleX
		scaleY ?= @options.gradientScaleY
		spread ?= @options.spread
		time ?= Framer.Defaults.Animation.time
		curve ?= "ease-out"
		totalFrames = time / Framer.Loop.delta
		if frame < totalFrames
			switch curve
				when "linear"
					easedFrame = linear(frame/totalFrames)
				when "ease-in"
					easedFrame = easeIn(frame/totalFrames)
				when "ease-out"
					easedFrame = easeOut(frame/totalFrames)
				when "ease-in-out"
					easedFrame = easeInOut(frame/totalFrames)
				else
					easedFrame = linear(frame/totalFrames)
			frameFirstColor = Color.mix(@options.firstColor, firstColor, easedFrame)
			frameSecondColor = Color.mix(@options.secondColor, secondColor, easedFrame)
			if @options.thirdColor != ""
				frameThirdColor = Color.mix(@options.thirdColor, thirdColor, easedFrame)
			frameSpread = Utils.modulate(easedFrame, [0, 1], [@options.spread, spread])
			frameOriginX = Utils.modulate(easedFrame, [0, 1], [@options.gradientOriginX, originX]) * 100
			frameOriginY = Utils.modulate(easedFrame, [0, 1], [@options.gradientOriginY, originY]) * 100
			frameScaleX = Utils.modulate(easedFrame, [0, 1], [@options.gradientScaleX, scaleX])
			
			frameScaleY = Utils.modulate(frame, [0, 1], [@options.gradientScaleY, scaleY])
			frameScaleX = Utils.modulate(frameScaleX, [0, 100], [0, 70]) * 100
			frameScaleY = Utils.modulate(frameScaleY, [0, 100], [0, 70]) * 100
			if @options.thirdColor == ""
				gradient = makeRadialGradientString(firstColor: frameFirstColor, secondColor: frameSecondColor, prefix: @options.prefix, spread: frameSpread, ellipseX: frameOriginX, ellipseY: frameOriginY, ellipseWidth: frameScaleX, ellipseHeight: frameScaleY)
			else
				gradient = makeRadialGradientThreeColorString(firstColor: frameFirstColor, secondColor: frameSecondColor, thirdColor: frameThirdColor, prefix: @options.prefix, spread: frameSpread, ellipseX: frameOriginX, ellipseY: frameOriginY, ellipseWidth: frameScaleX, ellipseHeight: frameScaleY)
			@.style.background = gradient
			Utils.delay Framer.Loop.delta, =>
				@animateGradient({firstColor: firstColor, secondColor: secondColor, thirdColor: thirdColor, originX: originX, originY: originY, scaleX: scaleX, scaleY: scaleY, spread: spread, time: time, curve: curve}, frame + 1)