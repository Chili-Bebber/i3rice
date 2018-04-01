elements = {
-- cpu text label
{
kind = 'static_text',
from = {x=100, y=90}, 
text = 'CPU', 
color = 0xFFFFFF, 
rotation_angle = 15, 
font = 'Roboto Condensed', 
font_size = 30, 
},
-- cpu ring graph
{
kind = 'ring_graph',
center = {x=70, y=70}, 
radius = 60, 
conky_value = 'cpu cpu0', 
max_value = 100, 
critical_threshold = 90, 
bar_color = 0xffffff, 
bar_alpha = 1, 
bar_thickness = 2, 
start_angle = 40, 
end_angle = 345, 
background_color = 0x000000, 
background_alpha = 0.5, 
background_thickness = 2, 
},
}
