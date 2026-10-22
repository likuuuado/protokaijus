shader_type spatial;
render_mode cull_disabled;

uniform float progreso : hint_range(0.0, 1.0) = 0.0;
uniform float altura_minima = 0.0;
uniform float altura_maxima = 5.0;

void fragment() {
	float altura = VERTEX.y;
	float limite = mix(altura_minima, altura_maxima, progreso);

	if (altura > limite) {
		discard;
	}
}