library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all; 
use IEEE.NUMERIC_STD.all;

entity testbench is
end;

architecture test of testbench is

  component counter is
    generic(width: integer);
    port(clk, reset: in  std_ulogic;
          up:         in  std_ulogic;
          y:          out std_ulogic_vector(width-1 downto 0));
  end component;

  constant w_a: integer := 3;
  constant w_b: integer := 4;  
    
  signal clk, reset: std_ulogic := '0';
  signal up:         std_ulogic := '1';
  signal y_a:        std_ulogic_vector(w_a-1 downto 0);
  signal y_b:        std_ulogic_vector(w_b-1 downto 0);
  
begin
  -- initiate device to be tested
  four: counter generic map(width => w_a) port map(clk, reset, up, y_a);
  five: counter generic map(width => w_b) port map(clk, reset, up, y_b);
  
  -- generate clock with 10 ns period
  process begin
      report ("increment");
      for i in 1 to 32 loop
        clk <= not(clk);
        wait for 5 ps;
        clk <= not(clk);
        wait for 5 ps;
        report "The value of y_a=" & integer'image(to_integer(unsigned(y_a))) & "     y_b=" & integer'image(to_integer(unsigned(y_b)));
      end loop;
      wait for 5 ns;
      
      report ("decrement");
      up <= '0';
      for i in 1 to 32 loop
        clk <= not(clk);
        wait for 5 ps;
        clk <= not(clk);
        wait for 5 ps;
        report "The value of y_a=" & integer'image(to_integer(unsigned(y_a))) & "     y_b=" & integer'image(to_integer(unsigned(y_b)));
      end loop;
      wait for 5 ns;
      
      report ("up toggle");
      up <= '1';
      for i in 1 to 8 loop
        clk <= not(clk);
        wait for 5 ps;
        clk <= not(clk);
        wait for 5 ps;
        report "The value of y_a=" & integer'image(to_integer(unsigned(y_a))) & "     y_b=" & integer'image(to_integer(unsigned(y_b)));
        up <= not(up);
      end loop;
      wait;
    end process;

    -- test all combinations
    process begin
      reset <= '1';
      wait for 12 ps;
      reset <= '0';
      report("reset released");
      wait;
   end process;
end;
