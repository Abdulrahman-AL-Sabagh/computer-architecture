library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity HA is 
port (a,b: in std_ulogic;
      s, carry_out: out std_ulogic
);
end;

architecture behaviour of HA is
begin
s <= a xor b;
carry_out <= a and b;
end;

