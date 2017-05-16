netsh advfirewall set allprofile state on
netsh advfirewall firewall add rule name=denyT445 dir=in action=block protocol=TCP localport=445
netsh advfirewall firewall add rule name=denyU445 dir=in action=block protocol=UDP localport=445
netsh advfirewall firewall add rule name=denyT135 dir=in action=block protocol=TCP localport=135
netsh advfirewall firewall add rule name=denyU135 dir=in action=block protocol=UDP localport=135
netsh advfirewall firewall add rule name=denyT137 dir=in action=block protocol=TCP localport=137
netsh advfirewall firewall add rule name=denyU137 dir=in action=block protocol=UDP localport=137
netsh advfirewall firewall add rule name=denyT138 dir=in action=block protocol=TCP localport=138
netsh advfirewall firewall add rule name=denyU138 dir=in action=block protocol=UDP localport=138
netsh advfirewall firewall add rule name=denyT139 dir=in action=block protocol=TCP localport=139
netsh advfirewall firewall add rule name=denyU139 dir=in action=block protocol=UDP localport=139