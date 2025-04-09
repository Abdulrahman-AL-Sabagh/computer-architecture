library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity ff is
  generic(width: integer);
  port(clk, reset:  in std_ulogic;
       d:           in std_ulogic_vector(width-1 downto 0);
       q:          out std_ulogic_vector(width-1 downto 0));
end;

architecture bhv of ff is
  
begin
  -- process is triggered everytime one of values in reset or clk changes
  process(reset, clk) begin
    if reset = '1' then
      q <= (width-1 downto 0 => '0');
    elsif clk'event and clk = '1' then -- clk'event is true if clk changed
      q <= d;
    end if;
  end process;
  
end;
