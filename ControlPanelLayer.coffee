###
	# USING THE CONTROLPANELLAYER MODULE

	# Require the module
	ControlPanelLayer = require "ControlPanelLayer"

	myControlPanel = new ControlPanelLayer
		scaleFactor: <number>
		specs: <object>
		draggable: <boolean>
		textColor: <string> (hex or rgba)
		backgroundColor: <string> (hex or rgba)
		inputTextColor: <string> (hex or rgba)
		inputBackgroundColor: <string> (hex or rgba)
		buttonTextColor: <string> (hex or rgba)
		buttonColor: <string> (hex or rgba)
		commitAction: -> <action>
		closeAction: -> <action>

	# The specs object

	# The ControlPanelLayer requires your behavior specifications to be organized in key-value object form. Each item must include a `label` and `value`. Optionally you may include an explanatory `tip`. Additional keys will be ignored.

	# Specs object values can include strings, numbers and booleans.

	exampleSpecs =
		defaultText:
			label: "Default text"
			value: "hello"
			tip: "Initial text to display."
		animationTime:
			label: "Animation time"
			value: 5
			tip: "How long the animation will run."
		autoplay:
			label: "Should autoplay"
			value: false

	# Referring to a particular spec using such an object is done with the usual dot notation or bracket notation, e.g. `exampleSpecs.animationTime.value` or `exampleSpecs["animationTime"]["value"]` or `exampleSpecs["animationTime"].value`.

	# The commit action

	# The ControlPanelLayer features a Commit button which can be customized to perform any action. You will want to at least overwrite your specs object with any changes effected via the ControlPanelLayer.

	myControlPanel = new ControlPanelLayer
		specs: exampleSpecs
		commitAction: -> exampleSpecs = this.specs

	# The close action

	# The panel close button works to hide the panel, but you may supply it with additional functionality.

	myControlPanel = new ControlPanelLayer
		specs: exampleSpecs
		closeAction: -> print "panel closed"

	# Integration with QueryInterface (https://github.com/marckrenn/framer-QueryInterface/)

	{QueryInterface} = require 'QueryInterface'

	querySpecs = new QueryInterface
		key: "specs"
		default: exampleSpecs

	myControlPanel = new ControlPanelLayer
		specs: querySpecs.value
		commitAction: -> querySpecs.value = this.specs; window.location.reload(false)

	# Show or hide the ControlPanelLayer
	myControlPanel.show()
	myControlPanel.hide()
	myControlPanel.hidden (<readonly boolean>, returns whether the ControlPanelLayer is currently hidden)

	# Known issues

	# Creating multiple ControlPanelLayers with different scale factors will result in unexpected input field effects.
###

defaults =
	specs: {}
	scaleFactor: 1
	draggable: true
	textColor: "white"
	inputBackgroundColor: "rgba(255,255,255,0.8)"
	inputTextColor: "black"
	backgroundColor: "rgba(0,0,0,0.5)"
	buttonTextColor: "black"
	buttonColor: "white"
	width: 350
	showGuides: false
	hidden: false
	commitAction: () ->
	closeAction: () ->

class ControlPanelLayer extends Layer
	constructor: (@options={}) ->
		@options = _.assign({}, defaults, @options)
		super @options

		rowHeight = 32 * @options.scaleFactor
		panelTopMargin = 15 * @options.scaleFactor
		panelBottomMargin = 15 * @options.scaleFactor
		panelSideMargin = 30 * @options.scaleFactor
		panelButtonMargin = 15 * @options.scaleFactor
		panelRowHeight = 34 * @options.scaleFactor
		minimumPanelHeight = 2 * panelRowHeight + panelTopMargin + panelBottomMargin
		panelLabelSize = 16 * @options.scaleFactor
		panelTipSize = 12 * @options.scaleFactor
		panelTipMargin = -8 * @options.scaleFactor
		radioButtonSize = 20 * @options.scaleFactor
		radioButtonMarkSize = 12 * @options.scaleFactor
		radioButtonTopMargin = 6 * @options.scaleFactor
		inputWidth = 50 * @options.scaleFactor
		inputTopMargin = panelLabelSize/4
		inputTopOffet = if @options.scaleFactor == 1 then -3 else 0
		svgTopOffset = if @options.scaleFactor == 1 then 2 else 0
		commitButtonHeight = 30 * @options.scaleFactor
		commitButtonTopMargin = 5 * @options.scaleFactor
		codeVariableColor = "#ed6a43"
		codeBracketColor = "#a71d5d"
		codeBodyColor = "#24292e"
		closeButtonSize = 24 * @options.scaleFactor
		closeButtonMargin = 8 * @options.scaleFactor
		closeButtonGlyphMargin = 4 * @options.scaleFactor
		closeGlyphHeight = 2 * @options.scaleFactor
		closeGlyphWidth = closeButtonSize - closeButtonGlyphMargin * 2
		closeGlyphTop = closeButtonSize/2 - 1 * @options.scaleFactor
		closeGlyphRotationX = closeButtonSize/2
		closeGlyphRotationY = closeButtonSize/2
		inputInsetShadowColor = new Color(@options.inputBackgroundColor).darken(30)
		alertString = "<p style='font-size:#{panelLabelSize}px; color:#000; text-align:center; line-height:#{commitButtonHeight}px'>Add specs with <code style='color:#{codeBodyColor}'><span style='color:#{codeVariableColor}'>specs</span>: <span style='color:#{codeBracketColor}'>&lt;</span>mySpecs<span style='color:#{codeBracketColor}'>&gt;</span></code></p>"
		commitString = "<p style='font-size:#{panelLabelSize}px; color:#000; text-align:center; line-height:#{commitButtonHeight}px'>Commit</p>"

		rowCount = Object.keys(@options.specs).length + 1 # allow for Commit button
		rows = []
		@.name = "controlPanel"
		@.width = @options.width * @options.scaleFactor
		@.height = panelRowHeight * rowCount + panelTopMargin + panelBottomMargin
		@.borderRadius = 10 * @options.scaleFactor
		@.shadowBlur = 20 * @options.scaleFactor
		@.shadowColor = "rgba(0,0,0,0.3)"
		@.backgroundColor = @options.backgroundColor
		@.draggable = @options.draggable
		@.draggable.momentum = false

		labelWidth = @.width - 125 * @options.scaleFactor

		inputCSS = """
		input[type='text'] {
		  color: #{@options.inputTextColor};
		  background-color: #{@options.inputBackgroundColor};
		  font-family: -apple-system, Helvetica, Arial, sans-serif;
		  font-weight: 500;
		  text-align: right;
		  font-size: #{panelLabelSize}px;
		  margin-top: #{inputTopMargin}px;
		  padding: #{panelLabelSize/8}px;
		  appearance: none;
		  width: #{inputWidth - panelLabelSize/8}px;
		  box-shadow: inset 0px 1px 2px 0 #{inputInsetShadowColor};
		  border-radius: #{3 * @options.scaleFactor}px;
		  position: relative;
		  top: #{inputTopOffet}px;
		}"""

		closeGlyph = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 #{svgTopOffset} #{closeButtonSize} #{closeButtonSize}'><rect x='#{closeButtonGlyphMargin}' y='#{closeGlyphTop}' width='#{closeGlyphWidth}' height='#{closeGlyphHeight}' rx='#{1 * @options.scaleFactor}' ry='#{1 * @options.scaleFactor}' fill='white' transform='rotate(45 #{closeGlyphRotationX} #{closeGlyphRotationY})' /><rect x='#{closeButtonGlyphMargin}' y='#{closeGlyphTop}' width='#{closeGlyphWidth}' height='#{closeGlyphHeight}' rx='#{1 * @options.scaleFactor}' ry='#{1 * @options.scaleFactor}' fill='white' transform='rotate(135 #{closeGlyphRotationX} #{closeGlyphRotationY})' /></svg>"

		Utils.insertCSS(inputCSS)

		keyIndex = 0
		for row of @options.specs
			do (row) =>
				tipRequired = if @options.specs[row].tip != "" and @options.specs[row].tip != undefined then true else false

				rowBlock = new Layer
					name: "row" + keyIndex
					parent: @
					x: panelSideMargin
					y: if keyIndex > 0 then rows[keyIndex - 1].maxY else panelTopMargin + keyIndex * panelRowHeight
					height: if tipRequired then panelRowHeight * 1.5 else panelRowHeight
					width: labelWidth
					backgroundColor: "clear"

				rows.push(rowBlock)

				label = new TextLayer
					name: _.camelCase(@options.specs[row].label + "Label")
					parent: rowBlock
					color: @options.textColor
					text: @options.specs[row].label
					fontSize: panelLabelSize
					fontWeight: 500
					textAlign: "right"
					padding:
						vertical: panelLabelSize/3
					height: panelRowHeight
					width: labelWidth

				@[label.name] = label

				if tipRequired
					tip = new TextLayer
						name: _.camelCase(@options.specs[row].label + "Tip")
						parent: rowBlock
						height: panelRowHeight * 0.4
						width: labelWidth
						y: label.maxY + panelTipMargin
						color: @options.textColor
						text: @options.specs[row].tip
						fontSize: panelTipSize
						fontWeight: 500
						textAlign: "right"
						truncate: true

					@[tip.name] = tip

				idString = _.camelCase(@options.specs[row].label + "Input")
				switch typeof @options.specs[row].value
					when "boolean"
						input = new Layer
							name: idString
							parent: rowBlock
							x: Align.right(inputWidth)
							y: Align.top(radioButtonTopMargin)
							height: radioButtonSize
							width: radioButtonSize
							borderRadius: radioButtonSize/2
							borderColor: @options.textColor
							borderWidth: 1 * @options.scaleFactor
							backgroundColor: "clear"

						inputMark = new Layer
							name: "mark"
							parent: input
							width: radioButtonMarkSize
							height: radioButtonMarkSize
							x: Align.center
							y: Align.center
							borderRadius: radioButtonMarkSize/2
							backgroundColor: @options.textColor
							visible: @options.specs[row].value

						input.mark = inputMark
						input.row = row

						input.onClick =>
							if @options.specs[input.row].value == true
								@options.specs[input.row].value = false
								input.mark.visible = false
							else
								@options.specs[input.row].value = true
								input.mark.visible = true

					else
						input = new Layer
							name: idString
							parent: rowBlock
							x: Align.right((@.width - labelWidth)/2)
							y: Align.top
							color: @options.textColor
							html: "<input id='#{idString}' type='text' contenteditable='true' value='#{@options.specs[row].value}'>"
							height: panelRowHeight
							width: inputWidth
							backgroundColor: "clear"

				@[input.name] = input

				if @options.showGuides == true
					guide = new Layer
						name: "guide"
						parent: rowBlock
						width: @.width
						x: -panelSideMargin
						backgroundColor: "red"
						height: 1
						y: panelLabelSize * 1.3
						opacity: 0.5

			++keyIndex


		@.height = Math.max(minimumPanelHeight, @.contentFrame().height + panelTopMargin + panelBottomMargin + commitButtonHeight + commitButtonTopMargin)

		closeButton = new Layer
			name: "closeButton"
			parent: @
			width: closeButtonSize
			height: closeButtonSize
			borderRadius: closeButtonSize/2
			backgroundColor: "rgba(0,0,0,0.15)"
			borderWidth: 1 * @options.scaleFactor
			borderColor: "rgba(255,255,255,0.5)"
			x: closeButtonMargin
			y: closeButtonMargin
			html: closeGlyph

		@.closeButton = closeButton

		closeButton.onClick =>
			@.hide()
			@options.closeAction()

		commitButton = new Layer
			name: "commitButton"
			parent: @
			width: @.width - panelButtonMargin * 2
			height: commitButtonHeight
			x: Align.center
			y: Align.bottom(- panelBottomMargin)
			backgroundColor: @options.buttonColor
			html: if Object.keys(@options.specs).length == 0 then alertString else commitString
			borderRadius: 5 * @options.scaleFactor

		@.commitButton = commitButton

		commitButton.onClick =>
			for row of @options.specs
				do(row) =>
					idString = _.camelCase(@options.specs[row].label + "Input")
					switch typeof @options.specs[row].value
						when "string"
							typedValue = document.getElementById(idString).value
						when "number"
							typedValue = +document.getElementById(idString).value
						when "boolean"
							typedValue = @options.specs[row].value
						else
							typedValue = document.getElementById(idString).value
					@options.specs[row].value = typedValue
			@options.commitAction()

		if @options.hidden == true
			@.hide()

	hide: () =>
		@options.hidden = true
		@.animate
			properties:
				opacity: 0
			time:
				0.25
		Utils.delay 0.25, =>
			@.visible = false

	show: () =>
		@.visible = true
		@options.hidden = false
		@.animate
			properties:
				opacity: 1
			time:
				0.25

	@define 'specs', get: () -> @options.specs
	@define 'hidden', get: () -> @options.hidden
module.exports = ControlPanelLayer
