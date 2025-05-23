
module common;
import std::io;


const String IP_ADDRESS = "10.0.0.208";
const uint PORT = 8080;


<* Copies data in array to a string ignoring null terminators *>
fn String char[].as_string(&self) {
  usz char_count;
  for (int i; i < self.len; i++) {
    if ((*self)[i] == '\0') break;
    char_count++;
  }

  String output = (String)mem::temp_array(char, char_count);
  mem::copy(output, *self, char_count);
  
  return output;
}

