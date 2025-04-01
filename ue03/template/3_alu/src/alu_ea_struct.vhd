library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity alu is
  generic(width: integer := 32);
  port(a, b:      in     std_ulogic_vector(width-1 downto 0);
       mode:      in     std_ulogic_vector(2 downto 0);
       result:    buffer std_ulogic_vector(width-1 downto 0);
       neg: buffer std_ulogic);
end;
