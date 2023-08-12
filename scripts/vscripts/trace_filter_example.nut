// Example script that demonstrates the use of a filter TraceLine, and a gather TraceLine
// To use: script_execute trace_filter_example
// Then: script ExampleHitTrace()
// Or: script ExampleGatherTrace()

IncludeScript("trace_filter");

function ExampleHitTrace()
{
	local player = GetListenServerHost();

	local trace =
	{
		start = player.EyePosition(),
		end = player.EyePosition() + player.EyeAngles().Forward() * 1024.0,
		ignore = player,
		mask = 1107296257, // CONTENTS_SOLID|CONTENTS_MONSTER|CONTENTS_HITBOX
		filter = function(entity)
		{
			// if player is on red team, accept the hit
			if (entity.IsPlayer() && entity.GetTeam() == 2) 
				return TRACE_STOP;

			return TRACE_CONTINUE;
		}
	};

	TraceLineFilter(trace);

	if (trace.hit)
	{
		DebugDrawLine(trace.start, trace.endpos, 255, 0, 0, false, 5.0);
		printl(trace.enthit);
	}
	else
	{
		DebugDrawLine(trace.start, trace.endpos, 0, 255, 0, false, 5.0);
		printl("no hit");
	}
}

function ExampleGatherTrace()
{
	local player = GetListenServerHost();

	local trace =
	{
		start = player.EyePosition(),
		end = player.EyePosition() + player.EyeAngles().Forward() * 1024.0,
		ignore = player,
		mask = 1107296257, // CONTENTS_SOLID|CONTENTS_MONSTER|CONTENTS_HITBOX
		filter = function(entity)
		{
			if (entity.IsPlayer())
			{
				// if player is on red team, accept the hit and continue
				if (entity.GetTeam() == 2) 
					return TRACE_OK_CONTINUE;
				// player is not on red team, continue but don't accept hit
				else
					return TRACE_CONTINUE;
			}
			
			// hit something that isn't a player, stop
			return TRACE_STOP;
		}
	};

	TraceLineGather(trace);

	if (trace.hits.len() > 0)
	{
		foreach (i, hit in trace.hits)
		{
			printf("=== hit %d ===\n", i);
			foreach (k, v in hit)
			{
				printf("\t%s = %s\n", k, v.tostring());
			}
			
			DebugDrawText(hit.endpos, format("hit %d", i), false, 5.0);
		}
		
		DebugDrawLine(trace.start, trace.endpos, 255, 0, 0, false, 5.0);
	}
	else
	{
		DebugDrawLine(trace.start, trace.endpos, 0, 255, 0, false, 5.0);
		printl("no hits");
	}
}