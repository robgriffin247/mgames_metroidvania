# Todo

- debugging (see below)
- dynamic map building (currently have to manually add an position nodes; should be possibly to iterate through level and build the map automatically using the transitions as anchor points showing how each map connects)
- build more levels

# Bugs

- HP bar on start not full
	- **Claude feedback:**
		- Nothing emits `player_health_changed` on spawn. The starting values `hp = 20.0` and `max_hp = 20.0` in `player.gd` don't run the setters, and `HPBar` defaults to `value = 0`.
		- `SaveManager.setup_player()` is the only place `hp` gets assigned, and launching straight into `01_forest` (via `PlayerSpawn`) skips it.
		- The HUD width (minimum 40) also differs from what `update_healthbar` sets (22 + 20 = 42).
		- [x] Fix: emit the signal once from the player's `_ready()` (deferred), or have `player_hud.gd` read the player's health in its own `_ready()`. Also set the bar's starting `value` to 100.
		- [x] Latent bug: `setup_player()` sets `hp` before `max_hp`, so a save with 30/30 would load as 20/30. Set `max_hp` first.
- Save player direction/reset to facing right on new game
	- **Claude feedback:**
		- The facing direction lives only in `sprite.flip_h` and isn't saved or restored. `save_game()`, `create_new_game_save()` and `setup_player()` only handle hp, max_hp, position and abilities.
		- The player moves itself to the root node, so it survives scene changes. Loading with F7 keeps the current facing.
		- Fix: add `"facing": 1`/`-1` to the player save data. Write it in `save_game()`, default to right in `create_new_game_save()`, and apply it in `setup_player()` (fall back to right if it's missing).
		- Consider a `facing` property on `Player` that drives the sprite flip, since attacks and dashes will need it too.
- Add minimum direction for inputs so stick drift etc does not affect
	- **Claude feedback:**
		- The movement actions use `deadzone: 0.2` in `project.godot`, and `Input.get_axis()` returns an analog value. Drift above 0.2 switches `idle.gd` (`direction.x != 0`) to run, and the `direction.x * run_speed` lines in run/jump/fall make the player creep.
		- The vertical checks already use `> 0.5`, which is why the problem is mostly horizontal.
		- Fix: raise the movement deadzones to about 0.3-0.5. Or apply a threshold in `update_direction()` (zero the axis when `abs(x) < threshold`), and optionally use `signf(x)` for full-speed, digital-feeling movement.
