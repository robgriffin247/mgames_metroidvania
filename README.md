# Michael Games Metroidvania Forge Tutorial

## Setup

- Create a project
- Create a Playground 2D scene as default on run
- Setup display and input settings

## Chapter 1

- First scenes with basic physics
- Playground scene used as an initial level
	- Sprite2D, Area2D, CollisionShape2D
- Player:
	- CharacterBody2D, Sprite2D, CollisionShape2D
	- Basic movement script (gravity and left/right; used ``get_axis()``)
- Player State Machine
	- Includes one-way platforms with crouch-drop
