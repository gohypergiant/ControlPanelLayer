# Gradient Helper Framer Module

[![license](https://img.shields.io/github/license/bpxl-labs/RemoteLayer.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](.github/CONTRIBUTING.md)
[![Maintenance](https://img.shields.io/maintenance/yes/2017.svg)]()

The Gradient Helper module simplifies the process of applying gradients to Framer layers and even enables animated gradients.
	
<img src="https://cloud.githubusercontent.com/assets/935/24376320/13b7ea52-1301-11e7-99c0-35b8f327b982.gif" width="497" style="display: block; margin: auto" alt="StatusBarLayer preview" />	

### Installation

#### Manual installation

Copy or save the `Gradient.coffee` file into your project's `modules` folder.

### Adding It to Your Project

In your Framer project, add the following:

```javascript
gradient = require "Gradient"
```

### API

#### Apply a gradient
```coffeescript
layerA.style.background = gradient.top("yellow", "red")
layerA.style.background = gradient.bottom("yellow", "red")
layerA.style.background = gradient.left("yellow", "red")
layerA.style.background = gradient.right("yellow", "red")
layerA.style.background = gradient.angle("yellow", "red", -60)
```

#### Three-color gradient syntax
```coffeescript
layerA.style.background = gradient.topThreeColor("yellow", "red", "green")
layerA.style.background = gradient.bottomThreeColor("yellow", "red", "green")
layerA.style.background = gradient.leftThreeColor("yellow", "red", "green")
layerA.style.background = gradient.rightThreeColor("yellow", "red", "green")
layerA.style.background = gradient.angleThreeColor("yellow", "red", "green", -60)
```

#### Radial gradients
```coffeescript
layerA.style.background = gradient.radial("yellow", "red")
layerA.style.background = gradient.radialThreeColor("yellow", "red", "green")
```

#### Reshape a radial gradient
```coffeescript
layerA.style.background = gradient.radial("yellow", "red", originX: 0.5, originY: 0, scaleX: 2, scaleY: 1)
```

`originX`, `originY`, `scaleX` and `scaleY` are percentages. An `originX`,`originY` of 0,0 centers the gradient in the upper left while 1,1 centers it in the lower right. 0.5,0.5 is the default center.

#### Optionally set the gradient's spread
```coffeescript
layerA.style.background = gradient.top("yellow", "red", spread: 0.5)
# 1 is default, 0 is no transition between colors
```

#### Optionally set the gradient's offset (linear gradients only)
```coffeescript
layerA.style.background = gradient.top("yellow", "red", offset: 10)
# 0 is no offset, 100 will push the gradient out of view
```

#### Optionally change the CSS prefix
```coffeescript
layerA.style.background = gradient.top("yellow", "red", prefix: "moz")
# webkit is default, hyphens are added for you
```

### Gradient Layers
While a gradient can be applied to any existing layer, for convenience it is possible to create two types of gradient layers. If you wish to animate your gradients, you can do so using one of these classes:

```coffeescript
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
```
	
#### Animating gradients
```coffeescript
layerA.animateGradient(<arguments>)
```

#### Arguments
```coffeescript
firstColor: <string> (hex or rgba or named color)
secondColor: <string> (hex or rgba or named color)
thirdColor: <string> (hex or rgba or named color)
direction: <string> ("top" || "bottom" || "left" || "right") or <number> (in degrees)
spread: <number>
offset: <number>
time: <number>
curve: <string> ("linear" || "ease-in" || "ease-out" || "ease-in-out" )
```

#### Arguments for radial gradient animation
```coffeescript
originX: <number> (0 is left, 1 is right)
originY: <number> (0 is top, 1 is bottom)
scaleX: <number> (percentage, 1 is 100% scale)
scaleY: <number> (percentage, 1 is 100% scale)
```

#### Examples
```coffeescript
layerA.animateGradient(direction: -60, spread: 2, offset: 0, time: 2)
layerA.animateGradient(offset: -50, curve: "ease-in-out")
layerA.animateGradient(secondColor: "blue", spread: 0.5, scaleX: 2, originY: 1)
```

---

Website: [blackpixel.com](https://blackpixel.com) &nbsp;&middot;&nbsp;
GitHub: [@bpxl-labs](https://github.com/bpxl-labs/) &nbsp;&middot;&nbsp;
Twitter: [@blackpixel](https://twitter.com/blackpixel) &nbsp;&middot;&nbsp;
Medium: [@bpxl-craft](https://medium.com/bpxl-craft)