import socket
import time

from zeroconf import IPVersion, ServiceInfo, Zeroconf

desc = {"path": "/~user"}
info = ServiceInfo(
    "_ssh._tcp.local.",
    "Termux-SSH._ssh._tcp.local.",
    addresses=[socket.inet_aton("192.168.1.50")],  # Your phone's local IP
    port=8022,
    properties=desc,
    server="termux.local.",
)

zc = Zeroconf(ip_version=IPVersion.V4Only)
print("Broadcasting Termux SSH service... Press Ctrl+C to exit.")
zc.register_service(info)

try:
    while True:
        time.sleep(0.1)
except KeyboardInterrupt:
    pass
finally:
    zc.unregister_service(info)
    zc.close()
