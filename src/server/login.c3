
module server::login;
import std::collections;
import std::io;


const String LOGIN_DATA = "resources/logins.dat";
const usz USERNAME_MAX  = 16;
const usz PASSWORD_MAX  = 16;
const usz USER_SIZE     = 40;

List{User} users;

struct User {
  String username, password;
  int elo;
  int currency;
}

<* Loads users from file *>
fn void load_users(String filepath = LOGIN_DATA) {
  char[] data = file::load_temp(filepath)!!;
  usz total = file::get_size(filepath)!! / USER_SIZE;

  for (int i; i < total; i++) {
    User u = data[i*USER_SIZE:USER_SIZE].to_user();
    users.push(u);
  }
}
<* Saves users to file *>
fn void List{User}.save(&self, String filepath = LOGIN_DATA) {
  char[] data = mem::new_array(char, users.len() * USER_SIZE);

  for (int i; i < users.len(); i++) {
    char[] temp = users[i].to_array();
    mem::copy(&data[i*USER_SIZE], temp, USER_SIZE);
  }

  File file = file::open(filepath, "wb")!!;
  file.write(data)!!;
  file.close()!!;
}

<* Converts User struct to char array *>
fn char[] User.to_array(&self) {
  char[] output = mem::temp_array(char, USER_SIZE); // TODO: Un-hardcode it. Size of User.
  mem::copy(&output[0], self.username, self.username.len);
  mem::copy(&output[16], self.password, self.password.len);
  *((int*)&output[32]) = self.elo;
  *((int*)&output[36]) = self.currency;

  return output;
}
<* Converts char array to User struct *>
fn User char[].to_user(&self) {
  int elo = (int)(*self)[32] + ((int)(*self)[33] << 8) + ((int)(*self)[34] << 16) + ((int)(*self)[35] << 24);// + ((int)(*self)[36] << 32);
  int cur = (int)(*self)[36] + ((int)(*self)[37] << 8) + ((int)(*self)[38] << 16) + ((int)(*self)[39] << 24);// + ((int)(*self)[41] << 32);
  return {
    (*self)[0:16].as_string(),
    (*self)[16:16].as_string(),
    elo,
    cur,
  };
}

