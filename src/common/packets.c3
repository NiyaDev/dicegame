
module common;


struct Packet {
  PacketType type;
  char[] data;
}

enum PacketType : char {
  PING,
  MULTIPACKET_HEADER,
  VERSION,
  USERNAME,
  PASSWORD,
  QUIT,
}

<* Converts packet to char array to be sent over socket *>
fn char[] Packet.as_data(&self) {
  char[] dat = mem::temp_array(char, 20);
  dat[0] = self.type.ordinal;
  mem::copy(&dat[1], self.data, self.data.len);

  return dat;
}



module common::packet;
import std::io;
import std::net;

<* Send a packet to server *>
fn void Socket.send_packet(&self, PacketType type, char[] data = {}) {
  Packet p = new(type, data);
  self.write(p.as_data())!!;

  switch (type) {
    case PING:     io::printfn("Sent PING");
    case MULTIPACKET_HEADER: io::printfn("Sent MULTIPACKET_HEADER");
    case VERSION:  io::printfn("Requested VERSION");
    case USERNAME: io::printfn("Sent USERNAME []"); // TODO:
    case PASSWORD: io::printfn("Sent PASSWORD []"); // TODO:
    case QUIT:     io::printfn("Sent QUIT");
  }
}
<* Recieve packet from server *>
fn Packet Socket.get_packet(&self) {
  char[] data = mem::temp_array(char, 20);
  self.read(data)!!;

  Packet output;
  output.type = PacketType.from_ordinal(data[0]);
  
  switch (output.type) {
    case PING: io::printfn("Recieved PING");
    case MULTIPACKET_HEADER: // TODO:
      io::printfn("Recieved MULTIPACKET_HEADER");
    case VERSION:
      output.data = mem::temp_array(char, 19);
      mem::copy(output.data, &data[1], 19);
      io::printfn("Recieved VERSION [%s]", (String)output.data);
    case USERNAME:
      output.data = mem::temp_array(char, 19);
      mem::copy(output.data, &data[1], 19);
      io::printfn("Recieved USERNAME [%s]", (String)output.data);
    case PASSWORD:
      output.data = mem::temp_array(char, 19);
      mem::copy(output.data, &data[1], 19);
      io::printfn("Recieved PASSWORD [%s]", (String)output.data);
    case QUIT: io::printfn("Recieved PING");
  }

  return output;
}
<* Create new packet *>
fn Packet new(PacketType type, char[] data = {}) {
  Packet output;
  output.type = type;
  output.data = data;

  //switch (type) {
  //  case MULTIPACKET_HEADER:
  //  case VERSION:
  //    
  //  default:
  //}

  return output;
}

