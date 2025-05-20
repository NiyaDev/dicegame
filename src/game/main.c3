
module game;
import std::io;
import std::net;
import common;


fn int main(String[] args) {
	TcpSocket socket = tcp::connect("10.0.0.208", 8080)!!;

	Packet packet = {PING,{}};
	
	char[] data = packet.as_data();
	socket.write(data)!!;
	free(data);

	Packet quit_packet = {QUIT,{}};

	data = quit_packet.as_data();
	socket.write(data)!!;
	free(data);

	//socket.write("fugandulu\0")!!;
	//socket.write("quit\0\0\0\0\0\0")!!;

	return 0;
}

