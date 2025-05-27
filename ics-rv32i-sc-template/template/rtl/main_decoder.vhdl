library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.pkg_riscv_sc.all;

entity main_decoder is 
  port(op             : in  STD_ULOGIC_VECTOR(6 downto 0); 
       ResultSrc      : out STD_ULOGIC_VECTOR(1 downto 0);
       MemWrite       : out STD_ULOGIC;
       Branch, ALUSrc : out STD_ULOGIC;
       RegWrite, Jump : out STD_ULOGIC;
       ImmSrc         : out STD_ULOGIC_VECTOR(IMM_SRC_SIZE-1 downto 0);
       ALUOp          : out STD_ULOGIC_VECTOR(1 downto 0);
       PcAdderSrcB  : out STD_ULOGIC );
end;

architecture bhv of main_decoder is
  signal controls: STD_ULOGIC_VECTOR(13 downto 0);
begin
  process(op) begin
    case op is
      when "0000011" => controls <= "10001001000000"; -- lw
      when "0100011" => controls <= "00011100000000"; -- sw
      when "0110011" => controls <= "1---0000010000"; -- R-type
      when "1100011" => controls <= "00100000101000"; -- beq
      when "0010011" => controls <= "10001000010000"; -- I-type ALU
      when "1101111" => controls <= "10110010000100"; -- jal
      when "1110011" => controls <= "0---00--000010"; -- ECALL
      when "1100111" => controls <= "10000010001101"; -- jalr
      when "0010111" => controls <= "11001000000000"; -- auipc
      when others    => controls <= "--------------"; -- 
    end case;
  end process;

  (RegWrite,ImmSrc(2) ,ImmSrc(1), ImmSrc(0), ALUSrc, MemWrite, ResultSrc(1), ResultSrc(0), Branch, ALUOp(1), ALUOp(0), Jump, g_ecall, PcAdderSrcB) <= controls;
end;
