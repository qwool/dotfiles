function fish_greeting

	set boottime (sysctl -n kern.boottime | awk '{print $4}' | sed 's/,//g')
	set unixtime (date +%s)
	set timeAgo (math $unixtime - $boottime)
	set uptime (echo $timeAgo | awk '{ 
	seconds = $1 % 60; 
	minutes = int($1 / 60 % 60); 
	hours = int($1 / 60 / 60 % 24); 
	days = int($1 / 60 / 60 / 24); 
	printf("%.0f days, %.0f hours, %.0f minutes, %.0f seconds", days, hours, minutes, seconds) 
	}')
	echo "up $uptime"
	df -h / | awk 'NR==2 {print $4, "left"}'

end
