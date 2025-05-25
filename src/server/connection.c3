
module server;
import std::net;
import common;


struct Connection {
	TcpServerSocket server;
	TcpSocket socket;

	String username, password;}

faultdef NO_PACKET;

<* Reads connection and if there is data convert into packet *>
fn Packet? Connection.read(&self) {
	char[] buffer = mem::new_array(char, 20);
	usz length = self.socket.read(buffer)!!;

	// Return essentially null
	if (length == 0) return NO_PACKET?;

	// Create packet
	Packet output;
	output.type = PacketType.from_ordinal(buffer[0]);
	output.data = mem::new_array(char, length-1);
	mem::copy(output.data, &buffer[1], length-1);

	return output;
}

<* Close connections *>
fn void Connection.close(&self) {
  self.server.close()!!;
  self.socket.close()!!;
  self.server = {};
  self.socket = {};
}

