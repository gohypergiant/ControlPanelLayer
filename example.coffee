############################################
# Example usage.
# For all features, please check the README.
############################################

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

myControlPanel = new ControlPanelLayer
	specs: exampleSpecs
	commitAction: -> commitAction: -> exampleSpecs = this.specs
