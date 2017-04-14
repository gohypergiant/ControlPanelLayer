# ControlPanelLayer Framer Module

[![license](https://img.shields.io/github/license/bpxl-labs/RemoteLayer.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](.github/CONTRIBUTING.md)
[![Maintenance](https://img.shields.io/maintenance/yes/2017.svg)]()

The ControlPanelLayer module makes it easier to construct a developer panel for controlling aspects of your prototype within the prototype itself.
	
<img src="https://cloud.githubusercontent.com/assets/935/24376320/13b7ea52-1301-11e7-99c0-35b8f327b982.gif" width="497" style="display: block; margin: auto" alt="StatusBarLayer preview" />	

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
	inputBackgroundColor: <string> (hex or rgba)
	inputTextColor: <string> (hex or rgba)
	backgroundColor: <string> (hex or rgba)
	buttonTextColor: <string> (hex or rgba)
	buttonColor: <string> (hex or rgba)
	commitAction: -> <action>
```

#### The specs object

The ControlPanelLayer requires your behavior specifications to be organized in key-value object form. Each item must include a `label` and `value`. Additional keys will be ignored.

The specs object can include strings, numbers and booleans.

```coffeescript
exampleSpecs =
	defaultText:
		label: "Default text"
		value: "hello"
	animationTime:
		label: "Animation time"
		value: 5
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

#### Example of integration with [QueryInterface](https://github.com/marckrenn/framer-QueryInterface/)

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
