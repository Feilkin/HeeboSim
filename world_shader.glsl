// World Shader, handles lighting and stuff

extern Image day_cycle_hue;
extern number day_time;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec4 texturecolor = Texel(texture, texture_coords);
    vec4 ambient = Texel(day_cycle_hue, vec2(day_time, 0));
    return texturecolor * color * ambient;
}