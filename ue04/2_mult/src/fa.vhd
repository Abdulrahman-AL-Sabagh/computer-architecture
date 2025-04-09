library IEEE; 
use IEEE.STD_LOGIC_1164.all;
entity FA is 
port (
  a,b,cin: in std_ulogic;
  s,carry_out: out std_ulogic
); 
end;



architecture behaviour of FA is
begin
    carry_out <= (a and b) or (a and cin) or (b and cin);
    s <= a xor b xor cin;
end;