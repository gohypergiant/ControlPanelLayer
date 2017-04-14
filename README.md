# ControlPanelLayer Framer Module

[![license](https://img.shields.io/github/license/bpxl-labs/RemoteLayer.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](.github/CONTRIBUTING.md)
[![Maintenance](https://img.shields.io/maintenance/yes/2017.svg)]()

The ControlPanelLayer module makes it easier to construct a developer panel for controlling aspects of your prototype within the prototype itself.
	
<img src="https://cloud.githubusercontent.com/assets/935/25053522/5e1b0ad2-211d-11e7-8a43-b91558fa2d63.png" width="497" style="display: block; margin: auto" alt="StatusBarLayer preview" />	

### Installation

#### Manual installation

Copy or save the `ControlPanelLayer.coffee` file into your project's `modules` folder.

### Adding It To Your Project

In your Framer project add the following:

```javascript
ControlPanelLayer = require "ControlPanelLayer"
```

### API

#### `new ControlPanelLayer`

Instantiates a new instance of ControlPanelLayer.

#### Available options

```coffeescript
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
```

#### The specs object

The ControlPanelLayer requires your behavior specifications to be organized in key-value object form. Each item must include a `label` and `value`. Optionally you may include an explanatory `tip`. Additional keys will be ignored.

The specs object can include strings, numbers and booleans.

```coffeescript
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
```

Referring to a particular spec using such an object is done with the usual dot notation or bracket notation, e.g. `exampleSpecs.animationTime.value` or `exampleSpecs["animationTime"]["value"]` or `exampleSpecs["animationTime"].value`.

#### The commit action

The ControlPanelLayer features a Commit button which can be customized to perform any action. You will want to at least overwrite your specs object with any changes effected via the ControlPanelLayer.

```coffeescript
myControlPanel = new ControlPanelLayer
	specs: exampleSpecs
	commitAction: -> exampleSpecs = this.specs
```

#### 	The close action
	
The panel close button works to hide the panel, but you may supply it with additional functionality.

```coffeescript
myControlPanel = new ControlPanelLayer
	specs: exampleSpecs
	closeAction: -> print "panel closed"
```

#### Example of integration with [QueryInterface](https://github.com/marckrenn/framer-QueryInterface/)

Using ControlPanelLayer in conjunction with QueryInterface provides a way to maintain settings across a reload or link to your prototype with custom settings included in the URL.

```coffeescript
{QueryInterface} = require 'QueryInterface'

querySpecs = new QueryInterface
	key: "specs"
	default: exampleSpecs
	
myControlPanel = new ControlPanelLayer
	specs: querySpecs.value
	commitAction: -> querySpecs.value = this.specs; window.location.reload(false)
```

---

Website: [blackpixel.com](https://blackpixel.com) &nbsp;&middot;&nbsp;
GitHub: [@bpxl-labs](https://github.com/bpxl-labs/) &nbsp;&middot;&nbsp;
Twitter: [@blackpixel](https://twitter.com/blackpixel) &nbsp;&middot;&nbsp;
Medium: [@bpxl-craft](https://medium.com/bpxl-craft)
