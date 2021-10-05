// client side timers by ysc (https://forum.vc-mp.org/?topic=2748.0) slightly edited to append the 2nd argument to the timer hash
Timer <- {
	Timers = {}
	COUNTER = 0
	function Create(environment, listener, interval, repeat, ...)
	{
		// Prepare the arguments pack
		vargv.insert(0, environment);

		// Store timer information into a table
		local TimerInfo = {
			Environment = environment,
			Listener = listener,
			Interval = interval,
			Repeat = repeat,
			Args = vargv,
			LastCall = Script.GetTicks(),
			CallCount = 0
		};
		
		local hash = split(TimerInfo.tostring(), ":")[1].slice(3, -1).tointeger(16);
		hash = hash+"TimerCounter::"+Timer.COUNTER;
		// Store the timer information
		Timer.COUNTER++;
		Timers.rawset(hash, TimerInfo);

		// Return the hash that identifies this timer
		
		return hash;
	}

	function Destroy(hash)
	{
		// See if the specified timer exists
		if (Timers.rawin(hash))
		{
			// Remove the timer information
			Timers.rawdelete(hash);
		}
	}

	function Exists(hash)
	{
		// See if the specified timer exists
		return Timers.rawin(hash);
	}

	function Fetch(hash)
	{
		// Return the timer information
		return Timers.rawget(hash);
	}

	function Clear()
	{
		// Clear existing timers
		Timers.clear();
	}

	function Process()
	{
		local CurrTime = Script.GetTicks();
		foreach (hash, tm in Timers)
		{
			if (tm != null)
			{
				if (CurrTime - tm.LastCall >= tm.Interval)
				{
					tm.CallCount++;
					tm.LastCall = CurrTime;
					tm.Listener.pacall(tm.Args);

					if (tm.Repeat != 0 && tm.CallCount >= tm.Repeat)
						Timers.rawdelete(hash);
				}
			}
		}
	}
};