#!/bin/bash
# Assuming all screens will ALWAYS have the SAME Brightness
# @author Allan Laal <allan@laal.ee>
# @url https://github.org/allanlaal/brightness


	# wait for the newest brightness to complete, so we dont get chaos:
	this_pid=$$
	pids=""
	pids=$(pgrep -x "brightness" | grep -v "^$this_pid" | sort | tail -n 1)
	
	if [ ! -z "$pids" ]; then
		while pid=; do
		
			if ! ps -p $pid > /dev/null; then
				break
			fi
			sleep 0.02 
		done
	fi

	brightness="$1"
	current_brightness=50

	echo "Changing brightness: $brightness"

	screen_numbers=$(ddcutil detect --brief | grep 'I2C bus:' | awk -F'/' '{print $NF}' | awk -F'-' '{print $2}')
	# NODO: caching this ( https://chatgpt.com/c/ac54e9d4-a1a4-424c-b36d-45eb0f15356e )

	for screen_number in $screen_numbers; do # all screens have the same brghtness
	  current_brightness=$(ddcutil --no-table --brief -b "$screen_number" getvcp 10 | awk '{print $4}')
		continue
	done

	if [ $# -eq 0 ]; then # No arguments provided, display current brightness
		echo "Current brightness: $current_brightness%"
		exit
	fi

	new_brightness=50
	if [[ "$brightness" == "up" ]]; then
		echo "Matched rule: up"
		new_brightness=$((current_brightness + 10))
	elif [[ "$brightness" == "down" ]]; then
		echo "Matched rule: down"
		new_brightness=$((current_brightness - 10))
		
	elif [[ "$brightness" =~ ^([\+\-][0-9]+)$ ]]; then
		echo "Matched rule: ± xx"
		new_brightness=$((current_brightness + brightness))
	elif [[ "$brightness" =~ ^([0-9]+)\%?$ ]]; then
		new_brightness=$(echo "$brightness" | sed 's/\%//')
		echo "Matched rule: xx or xx%"
	else
		echo "################################################"
		echo "ERROR: Invalid brightness value!"
		echo "Please provide either 'up', 'down', '+X', '-X', or a numeric value (% optional)"
		#~ echo "  defaulting to $new_brightness"
		echo "### EXITING ###"
		echo "################################################"
		exit 1
	fi

	# Force brightness into a range:
	max_brightness=100
	min_brightness=10
	new_brightness=$((new_brightness < min_brightness ? min_brightness : new_brightness))

	if [[ "$brightness" < 101 ]]; then
		echo "using DDC"
		new_brightness=$((new_brightness > max_brightness ? max_brightness : new_brightness))


		for screen_number in $screen_numbers; do
			
			ddcutil -b "$screen_number" setvcp 10 "$new_brightness" &
			echo "Screen $screen_number: Changed brightness from $current_brightness to $new_brightness"

		done
	else
		new_brightness=$(echo "scale=2; $new_brightness / 100" | bc)
		echo "using xrandr hack to set brightness to $new_brightness"
		screen_names=$(xrandr -q | grep " connected" | cut -d" " -f1)
		for screen_name in $screen_names; do
			xrandr --output "$screen_name" --brightness $new_brightness
		done
	fi
