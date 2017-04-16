# Demo camera project for Godot
This is a demo project that I used to make a small explination video on setting up stereo cameras.
You can find this video here:
https://youtu.be/tD06SpaeWOs

You need to uncomment a line of code in mono.gd to make the full experiment work however note that due to a save bug mono.tscn will become corrupted after this. This is due to mono.gd running in tool mode and the assignment of the render buffer texture to our material doesn't seem supported in the format. Normally this is a chance you would only do in runtime and it would be discarded as a result.

Note that for this to work you need the frustum mode enhancement to Godot:
- Godot 2.x: https://github.com/godotengine/godot/pull/7778
- Godot 3.x: https://github.com/godotengine/godot/pull/7121

If they haven't already been added into the main branch

Also I suggest checking out this video by Johnny Lee:
https://www.youtube.com/watch?v=Jd3-eiid-Uw
It gives some interesting insights in how we process 3D.
