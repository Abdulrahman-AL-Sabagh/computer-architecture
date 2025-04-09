library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity counter is
  generic (width: integer);
  port(clk, reset: in  std_ulogic;
       up:         in  std_ulogic;
       y:          out std_ulogic_vector(width-1 downto 0));
end;    

architecture struct of counter is

 signal ffa_outputs: std_ulogic_vector(width -1);  
  component ff  port(clk, reset:  in std_ulogic;
       d:           in std_ulogic_vector(width-1 downto 0);
       q:          out std_ulogic_vector(width-1 downto 0));
  
  end component;
begin

 ff0: ff port map(clk, reset, up, ffa_outputs(width -1) );
  ffN: for i in width - 2 downto 0 generate

  end generate;

end;
