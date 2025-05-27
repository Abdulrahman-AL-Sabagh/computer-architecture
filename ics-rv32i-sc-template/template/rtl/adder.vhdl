library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD_UNSIGNED.all;

entity adder is -- adder
  port(a, b  : in  STD_ULOGIC_VECTOR(31 downto 0);
      eraseLSB : in std_ulogic;
       y    : out STD_ULOGIC_VECTOR(31 downto 0));
end;


architecture bhv of adder is
signal sum : std_ulogic_vector(31 downto 0);

begin
  
  sum <=  (a +b);
  y <= sum when eraseLSB = '0' else sum and (not X"00000001");
end;