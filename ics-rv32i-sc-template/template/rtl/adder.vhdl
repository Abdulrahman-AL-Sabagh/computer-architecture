library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD_UNSIGNED.all;

entity adder is -- adder
  port(a, b : in  STD_ULOGIC_VECTOR(31 downto 0);
       y    : out STD_ULOGIC_VECTOR(31 downto 0));
end;

architecture bhv of adder is
begin
  y <= a + b;
end;