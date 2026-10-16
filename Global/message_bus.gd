extends Node

@warning_ignore_start("unused_signal")
signal player_interacted(player:Player)
signal player_healed(amount: int)
signal input_hint_changed(hint: String)
@warning_ignore_restore("unused_signal")
