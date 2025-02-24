extends MeshInstance3D

@export var max_glitch := 0.2
@export var audio_stream : AudioStreamPlayer

var glitch_amount := 0.0
var mat : ShaderMaterial
@onready var rhythm_timer = $RhythmNotifier

func _ready():
	mat = get_active_material(0) as ShaderMaterial
	rhythm_timer.audio_stream_player = audio_stream
	rhythm_timer.audio_stream_player.play()
	rhythm_timer.beat.connect(_begin_glitch)


func _process(delta):
	glitch_amount = maxf(0.0, glitch_amount - delta)
	mat.set_shader_parameter("offset_scale", glitch_amount)
	audio_stream.get_playback_position()
	

func _begin_glitch(current_beat: int):
	glitch_amount = max_glitch
