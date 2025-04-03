library IEEE;
use IEEE.NUMERIC_STD.all; -- habe mir die Vergleiche in dem Testfile angeschaut

use IEEE.STD_LOGIC_1164.all;
entity alu is
  generic(width: integer := 32);
  port(a, b:      in     std_ulogic_vector(width-1 downto 0);
       mode:      in     std_ulogic_vector(2 downto 0);
       result:    buffer std_ulogic_vector(width-1 downto 0);
       neg: buffer std_ulogic);
end entity alu;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity fa is
  port(a, b, cin: in  std_ulogic;
       cout, s:   out std_ulogic);
end entity fa;

architecture struct of fa is
begin
    cout <= (a and b) or (a and cin) or (b and cin);
    s <= a xor b xor cin;
end architecture struct;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity cra_gen is
  generic(width: integer := 32);
  port(a, b: in  std_ulogic_vector(width-1 downto 0);
       cin:  in  std_ulogic;
       cout: out std_ulogic;
       sum:  out std_ulogic_vector(width-1 downto 0));
end entity cra_gen;    

architecture struct of cra_gen is
  component fa --Wiederholung der Komponent damit wir sie nutzen können
    port(a, b, cin: in  std_ulogic;
         cout, s:   out std_ulogic);
  end component;
--    signal c1, c2, c3: STD_ULOGIC; -- mit den Signalen verbinden wir Cout und Cin der FAs
  signal c: std_ulogic_vector(width-1 downto 0);
begin
  
  fa0: fa port map(a(0), b(0), cin, c(0), sum(0));
  
  FA_CHAIN: for I in 1 to width-1 generate
    faN: fa port map(a(I), b(I), c(I-1), c(I), sum(I));
  end generate;
  
  cout <= c(width-1);
end architecture struct;

architecture struct of alu is
component cra_gen is
 port(a, b: in  std_ulogic_vector(width-1 downto 0);
       cin:  in  std_ulogic;
       cout: out std_ulogic;
       sum:  out std_ulogic_vector(width-1 downto 0));
end component cra_gen;


signal result_signal: std_ulogic_vector(width -1 downto 0);
signal sum_result: std_ulogic_vector(width -1 downto 0);
signal cin_modified: std_ulogic := '0'; -- 
signal b_modified: std_ulogic_vector(width -1 downto 0);
signal c_out_for_nothing:std_ulogic;
signal neg_value:std_ulogic;

begin
  adder: cra_gen port map(
    a,
    b_modified,
    cin_modified,
    c_out_for_nothing,
    sum_result
  );

  process(a,b,mode,sum_result)

  begin
  b_modified <= b;
  cin_modified <= '0';
  report "a: " & to_string(a);
  report "b_modified: " & to_string(b_modified);
      if mode = "000" then
      result_signal <= a or b;
      end if; 
      if mode = "001" then
      result_signal <= a and b; 
      end if;

      if mode = "010" then
        
         b_modified <=  b;
               report " AFTER _UPDATE Mode: 010 | b_modified = " & to_string(b_modified);

         cin_modified <= '0';
         result_signal <= sum_result;
              end if;
      if mode = "100" then
      result_signal <= a or not b;
      end if;

      if mode = "101" then
      result_signal <= a and not b;
      end if;

      if mode = "110" then
            cin_modified <= '1';
            b_modified <= not b;
           result_signal <= sum_result;
      end if;
    if mode = "111" then
         

          if signed(a) < signed(b) then
              result_signal <= (0 => '1', others => '0');
           else 
            result_signal <= (0 => '0', others  => '0' );
        end if;
      end if;

  report "MSB (bit 31) of result_signal = " & std_logic'image(result_signal(31));
  end process;
  result <= result_signal;
  neg <= result_signal(width - 1);
end;