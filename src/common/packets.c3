
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
  char[] dat = mem::new_array(char, 20);
  dat[0] = self.type.ordinal;
  mem::copy(&dat[1], self.data, self.data.len);

  return dat;
}



module common::packet;

<* Create new packet *>
fn Packet? new(PacketType type, void* data = null) {
  Packet output;
  output.type = type;

  // Copy data based on type
  switch (type) {
    default:
  }

  return output;
}

