library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.pkg_riscv_sc.all;

entity control_unit is -- single-cycle controller
  port(op             : in  STD_ULOGIC_VECTOR(6 downto 0);
       funct3         : in  STD_ULOGIC_VECTOR(2 downto 0);
       funct7_5       : in  STD_ULOGIC;
       Zero           : in  STD_ULOGIC;
       AluSign        : in STD_ULOGIC;
       ResultSrc      : out STD_ULOGIC_VECTOR(1 downto 0);
       MemWrite       : out STD_ULOGIC;
       PCSrc, ALUSrc,PcAdderSrcB  : out STD_ULOGIC;
       RegWrite       : out STD_ULOGIC;
       ImmSrc         : out STD_ULOGIC_VECTOR(IMM_SRC_SIZE-1 downto 0);
       ALUControl     : out STD_ULOGIC_VECTOR(ALU_CTRL_SIZE-1 downto 0);
       allowCustomWrite : out STD_ULOGIC
       );
end;

architecture struct of control_unit is
  component main_decoder
    port(op             : in  STD_ULOGIC_VECTOR(6 downto 0);
         ResultSrc      : out STD_ULOGIC_VECTOR(1 downto 0);
         MemWrite       : out STD_ULOGIC;
         Branch, ALUSrc : out STD_ULOGIC;
         RegWrite, Jump : out STD_ULOGIC;
         ImmSrc         : out STD_ULOGIC_VECTOR(IMM_SRC_SIZE-1 downto 0);
         ALUOp          : out STD_ULOGIC_VECTOR(1 downto 0);
         PcAdderSrcB  : out STD_ULOGIC
         );
  end component;
  component alu_decoder
    port(op_5       : in  STD_ULOGIC;
         funct3     : in  STD_ULOGIC_VECTOR(2 downto 0);
         funct7_5   : in  STD_ULOGIC;
         ALUOp      : in  STD_ULOGIC_VECTOR(1 downto 0);
         cInstr     : in  STD_ULOGIC;
         ALUControl : out STD_ULOGIC_VECTOR(ALU_CTRL_SIZE-1 downto 0));
  end component;
  
  signal ALUOp  : STD_ULOGIC_VECTOR(1 downto 0);
  signal Branch : STD_ULOGIC;
  signal Jump   : STD_ULOGIC;
  signal AdderSrcB : std_ulogic;
  signal isCInstr  : STD_ULOGIC;
begin
  isCInstr <= '1' when op = "0001011" else '0';
  md: main_decoder  port map(op, ResultSrc, MemWrite, Branch, ALUSrc ,RegWrite, Jump, ImmSrc, ALUOp, PcAdderSrcB);
  ad: alu_decoder   port map(op(5), funct3, funct7_5, ALUOp, isCInstr, ALUControl);
  
  allowCustomWrite <= '1' when op = "0001011" else '0';  
  process(Branch, funct3, AluSign, Zero, Jump) begin
  if Jump = '1' then
    PCSrc <= '1';
  elsif Branch = '1' then
    if funct3 = "101" and AluSign = '0' then
      PCSrc <= '1';
    elsif funct3 = "000" and Zero = '1' then
      PCSrc <= '1';
    else
      PCSrc <= '0';
    end if;
  else
    PCSrc <= '0';
  end if;
end process;
--  PCSrc <= (Branch and (Zero or AluSign = '0')) or Jump;
end;
