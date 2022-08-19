#1 /bin/sh

pgrep -f "x64.*-remotemonitor" || x64 -remotemonitor &
