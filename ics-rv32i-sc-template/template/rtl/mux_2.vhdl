library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux_2 is
  port(d0, d1 : in  STD_ULOGIC_VECTOR(31 downto 0);
       s      : in  STD_ULOGIC;
       y      : out STD_ULOGIC_VECTOR(31 downto 0));
end;

architecture bhv of mux_2 is
begin
  y <= d1 when s='1' else 
       d0 when s='0' else
       (others => 'X');
end;
