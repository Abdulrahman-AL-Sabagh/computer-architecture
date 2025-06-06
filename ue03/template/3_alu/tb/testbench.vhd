library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity testbench is
end;

architecture test of testbench is
  component ALU
    generic(width: integer := 32);
    port(a, b:      in     std_ulogic_vector(width-1 downto 0);
         mode:      in     std_ulogic_vector(2 downto 0);
         result:    buffer std_ulogic_vector(width-1 downto 0);
         neg: buffer std_ulogic);
  end component;

  constant width: integer := 32;
  
  signal a, b, y:  std_ulogic_vector(width-1 downto 0) := (others => '0');
  signal f: std_ulogic_vector(2 downto 0) := (others => '0');
  signal neg: std_ulogic := '0';

begin
  
  my_alu: ALU generic map(width) port map(a, b, f, y, neg);

  process begin
    report "-- TRIAL CHECKS --";
    a <= std_ulogic_vector(to_signed(1, a'length));
    b <= std_ulogic_vector(to_signed(5, b'length));
    wait for 40 ns;
    report "A = " & integer'image(to_integer(signed(a))) & ", B = " & integer'image(to_integer(signed(b)));
    
    f <= "000";
    wait for 40 ns;
    report "---------------------------------------------------";
    report "A OR B = " & integer'image(to_integer(signed(y)))
      & ", neg = " & std_ulogic'image(neg);

    f <= "001";
    wait for 40 ns;
    report "---------------------------------------------------";
    report "A AND B = " & integer'image(to_integer(signed(y)))
      & ", neg = " & std_ulogic'image(neg);
    
    f <= "010";
    wait for 40 ns;
    report "---------------------------------------------------";
    report "A + B = " & integer'image(to_integer(signed(y)))
      & ", neg = " & std_ulogic'image(neg);

    f <= "100";
    wait for 40 ns;
    report "---------------------------------------------------";
    report "A OR (NOT B) = " & integer'image(to_integer(signed(y)))
      & ", neg = " & std_ulogic'image(neg);

    f <= "101";
    wait for 40 ns;
    report "---------------------------------------------------";
    report "A AND (NOT B) = " & integer'image(to_integer(signed(y)))
      & ", neg = " & std_ulogic'image(neg);

    f <= "110";
    wait for 40 ns;
    report "---------------------------------------------------";
    report "A - B = " & integer'image(to_integer(signed(y)))
      & ", neg = " & std_ulogic'image(neg);

    f <= "111";
    wait for 40 ns;
    report "---------------------------------------------------";
    report "SLT = " & integer'image(to_integer(signed(y)))
      & ", neg = " & std_ulogic'image(neg);

    report "---------------------------------------------------";
    report "---------------------------------------------------";
    a <= std_ulogic_vector(to_signed(-4, a'length));
    b <= std_ulogic_vector(to_signed(2, b'length));
    wait for 40 ns;
    report "A = " & integer'image(to_integer(signed(a))) & ", B = " & integer'image(to_integer(signed(b)));
    
    f <= "000";
    wait for 40 ns;
    report "---------------------------------------------------";
    report "A OR B = " & integer'image(to_integer(signed(y)))
      & ", neg = " & std_ulogic'image(neg);

    f <= "001";
    wait for 40 ns;
    report "---------------------------------------------------";
    report "A AND B = " & integer'image(to_integer(signed(y)))
      & ", neg = " & std_ulogic'image(neg);
    
    f <= "010";
    wait for 40 ns;
    report "---------------------------------------------------";
    report "A + B = " & integer'image(to_integer(signed(y)))
      & ", neg = " & std_ulogic'image(neg);

    f <= "100";
    wait for 40 ns;
    report "---------------------------------------------------";
    report "A OR (NOT B) = " & integer'image(to_integer(signed(y)))
      & ", neg = " & std_ulogic'image(neg);

    f <= "101";
    wait for 40 ns;
    report "---------------------------------------------------";
    report "A AND (NOT B) = " & integer'image(to_integer(signed(y)))
      & ", neg = " & std_ulogic'image(neg);

    f <= "110";
    wait for 40 ns;
    report "---------------------------------------------------";
    report "A - B = " & integer'image(to_integer(signed(y)))
      & ", neg = " & std_ulogic'image(neg);

    f <= "111";
    wait for 40 ns;
    report "---------------------------------------------------";
    report "SLT = " & integer'image(to_integer(signed(y)))
      & ", neg = " & std_ulogic'image(neg);
    
    report "-- ERROR CHECKS --";
    for aa in -20 to 20 loop
      for bb in -20 to 20 loop
        a <= std_ulogic_vector(to_signed(aa, a'length));
        b <= std_ulogic_vector(to_signed(bb, b'length));

        f <= "000";
        wait for 5 ns;
        if((a or b) /= y) then
          report integer'image(aa) & " OR " & integer'image(bb) & " = " & integer'image(to_integer(signed(a or b))) & ", but y = " & integer'image(to_integer(signed(y))) & " (BREAK)" severity error;
          wait;
        end if;
        if(( to_integer(signed(y)) < 0 and (neg /= '1')) or (to_integer(signed(y)) >= 0 and neg /= '0')) then
          report "[a: " & integer'image(to_integer(signed(a))) & ", b:" & integer'image(to_integer(signed(b))) & ", op: " & integer'image(to_integer(unsigned(f))) & "] y is " & integer'image(to_integer(signed(y))) & ", but neg = " & std_ulogic'image(neg) & " (BREAK)" severity error;
          wait;
        end if;

        f <= "001";
        wait for 5 ns;
        if((a and b) /= y) then
          report integer'image(aa) & " AND " & integer'image(bb) & " = " & integer'image(to_integer(signed(a and b))) & ", but y = " & integer'image(to_integer(signed(y))) & " (BREAK)" severity error;
          wait;
        end if;
        if(( to_integer(signed(y)) < 0 and (neg /= '1')) or (to_integer(signed(y)) >= 0 and neg /= '0')) then
          report "[a: " & integer'image(to_integer(signed(a))) & ", b:" & integer'image(to_integer(signed(b))) & ", op: " & integer'image(to_integer(unsigned(f))) & "] y is " & integer'image(to_integer(signed(y))) & ", but neg = " & std_ulogic'image(neg) & " (BREAK)" severity error;
          wait;
        end if;

        f <= "010";
        wait for 5 ns;
        if(aa + bb /= to_integer(signed(y))) then
          report integer'image(aa) & " + " & integer'image(bb) & " = " & integer'image((aa + bb)) & ", but y = "  & integer'image(to_integer(signed(y))) & " (BREAK)" severity error;
          wait;
        end if;
        if(( to_integer(signed(y)) < 0 and (neg /= '1')) or (to_integer(signed(y)) >= 0 and neg /= '0')) then
          report "[a: " & integer'image(to_integer(signed(a))) & ", b:" & integer'image(to_integer(signed(b))) & ", op: " & integer'image(to_integer(unsigned(f))) & "] y is " & integer'image(to_integer(signed(y))) & ", but neg = " & std_ulogic'image(neg) & " (BREAK)" severity error;
          wait;
        end if;

        f <= "100";
        wait for 5 ns;
        if((a or (not b)) /= y) then
          report integer'image(aa) & " OR (NOT" & integer'image(bb) & ") = " & integer'image(to_integer(signed(a or (not b)))) & ", but y = " & integer'image(to_integer(signed(y))) & " (BREAK)" severity error;
          wait;
        end if;
        if(( to_integer(signed(y)) < 0 and (neg /= '1')) or (to_integer(signed(y)) >= 0 and neg /= '0')) then
          report "[a: " & integer'image(to_integer(signed(a))) & ", b:" & integer'image(to_integer(signed(b))) & ", op: " & integer'image(to_integer(unsigned(f))) & "] y is " & integer'image(to_integer(signed(y))) & ", but neg = " & std_ulogic'image(neg) & " (BREAK)" severity error;
          wait;
        end if;

        f <= "101";
        wait for 5 ns;
        if((a and (not b)) /= y) then
          report integer'image(aa) & " AND (NOT" & integer'image(bb) & ") = " & integer'image(to_integer(signed(a and (not b)))) & ", but y = "  & integer'image(to_integer(signed(y))) & " (BREAK)" severity error;
          wait;
        end if;
        if(( to_integer(signed(y)) < 0 and (neg /= '1')) or (to_integer(signed(y)) >= 0 and neg /= '0')) then
          report "[a: " & integer'image(to_integer(signed(a))) & ", b:" & integer'image(to_integer(signed(b))) & ", op: " & integer'image(to_integer(unsigned(f))) & "] y is " & integer'image(to_integer(signed(y))) & ", but neg = " & std_ulogic'image(neg) & " (BREAK)" severity error;
          wait;
        end if;

        f <= "110";
        wait for 5 ns;
        if(aa - bb /= to_integer(signed(y))) then
          report integer'image(aa) & " - " & integer'image(bb) & " = " & integer'image((aa - bb)) & ", but y = "  & integer'image(to_integer(signed(y))) & " (BREAK)" severity error;
          wait;
        end if;
        if(( to_integer(signed(y)) < 0 and (neg /= '1')) or (to_integer(signed(y)) >= 0 and neg /= '0')) then
          report "[a: " & integer'image(to_integer(signed(a))) & ", b:" & integer'image(to_integer(signed(b))) & "] y is " & integer'image(to_integer(signed(y))) & ", but neg = " & std_ulogic'image(neg) & " (BREAK)" severity error;
          wait;
        end if;

        f <= "111";
        wait for 5 ns;
        if(((aa < bb) and (to_integer(signed(y)) /= 1)) or ((aa >= bb) and (to_integer(signed(y)) /= 0))) then
          report integer'image(aa) & " < " & integer'image(bb) & " = " & integer'image(to_integer(signed(y))) & " (BREAK)" severity error;
          wait;
        end if;
        if(( to_integer(signed(y)) < 0 and (neg /= '1')) or (to_integer(signed(y)) >= 0 and neg /= '0')) then
          report "[a: " & integer'image(to_integer(signed(a))) & ", b:" & integer'image(to_integer(signed(b))) & ", op: " & integer'image(to_integer(unsigned(f))) & "] y is " & integer'image(to_integer(signed(y))) & ", but neg = " & std_ulogic'image(neg) & " (BREAK)" severity error;
          wait;
        end if;

        wait for 5 ns;
      end loop;
    end loop;
    report ("all done");
    wait;
  end process;
end;
