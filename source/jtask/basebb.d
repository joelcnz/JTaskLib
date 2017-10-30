module jtask.basebb;

import std.string;
public import jtask.taskbb, jtask.taskmanbb;

struct TimeLength
{
	int hours, minutes, seconds;
	//bool show = false; // for whether to display period or not
	string toString()
	{
		return format( "%s:%s:%s", hours, minutes, seconds );
	}
}
