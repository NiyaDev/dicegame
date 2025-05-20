
module server;
import std::io;
import std::net;
import common;


fn int main() {
	TcpServerSocket server = tcp::listen("10.0.0.208", 8080, 10)!!;
	TcpSocket socket = tcp::accept(&server)!!;

	bool run = true;
	while (run) {
		char[] buffer = mem::new_array(char,20);
		usz length = socket.read(buffer)!!;
		
		if (length != 0) {
		  switch (PacketType.from_ordinal(buffer[0])) {
		  	case PING:
		  		io::printn("Recieved PING");
				case QUIT:
					io::printn("Recieved QUIT");
					run = false;
					break;
				default:
			}
		}
		
		free(buffer);
	}
	return 0;
}
