library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity counter is
  generic (width: integer);
  port(clk, reset: in  std_ulogic;
       up:         in  std_ulogic;
       y:          out std_ulogic_vector(width-1 downto 0));
end;    

architecture struct of counter is
  
  
  
begin



end;
