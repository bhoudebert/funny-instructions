let
  player1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICGDeXmRUQ5YWz8bpap5Ik8VmyEiJw/V6mXxu2FaD2NW player one";
  player2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILsuDQWXVCKcbuuUss/kMv6/HxprIyTipkxzPfOnOFkI player two";
  contender = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMdLfQGtuKJr9dfljjmZzUNhIc22y9TGjKKZAOvrHQrR contender";
in
{
  "instructions.age".publicKeys = [ player1 player2 contender ];
}

