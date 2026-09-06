shader_type canvas_item;

uniform vec2 light_pos_px = vec2(400.0, 300.0); // player's position in screen pixels
uniform float radius_px : hint_range(0.0, 2000.0) = 120.0;
uniform float feather_px : hint_range(0.0, 2000.0) = 60.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float dist = distance(FRAGCOORD.xy, light_pos_px);
    float alpha = smoothstep(radius_px, radius_px + feather_px, dist);
    COLOR = vec4(0.0, 0.0, 0.0, alpha);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
