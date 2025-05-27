-----------------------------------------
-- Institute for Complex Systems (ICS)
-- based on Harris&Harris Implementation (see below **)
--
-- Contact:
-- Christoph Hazott (christoph.hazott@.jku.at)
-- Katharina Ruep   (katharina.ruep@.jku.at)
--
-- VHDL'08 version
-----------------------
-- **
-- RISC-V single-cycle processor
-- From Section 7.6 of Digital Design & Computer Architecture
-- 27 April 2020
-- David_Harris@hmc.edu 
-- Sarah.Harris@unlv.edu
--
-- Single-cycle implementation of RISC-V (RV32I)
-- User-level Instruction Set Architecture V2.2 (May 7, 2017)
-- Implements a subset of the base integer instructions:
--    lw, sw
--    add, sub, and, or, slt, 
--    addi, andi, ori, slti
--    beq
--    jal
-- Exceptions, traps, and interrupts not implemented
-- little-endian memory

-- 31 32-bit registers x1-x31, x0 hardwired to 0
-- R-Type instructions
--   add, sub, and, or, slt
--   INSTR rd, rs1, rs2
--   Instr[31:25] = funct7 (funct7b5 & opb5 = 1 for sub, 0 for others)
--   Instr[24:20] = rs2
--   Instr[19:15] = rs1
--   Instr[14:12] = funct3
--   Instr[11:7]  = rd
--   Instr[6:0]   = opcode
-- I-Type Instructions
--   lw, I-type ALU (addi, andi, ori, slti)
--   lw:         INSTR rd, imm(rs1)
--   I-type ALU: INSTR rd, rs1, imm (12-bit signed)
--   Instr[31:20] = imm[11:0]
--   Instr[24:20] = rs2
--   Instr[19:15] = rs1
--   Instr[14:12] = funct3
--   Instr[11:7]  = rd
--   Instr[6:0]   = opcode
-- S-Type Instruction
--   sw rs2, imm(rs1) (store rs2 into address specified by rs1 + immm)
--   Instr[31:25] = imm[11:5] (offset[11:5])
--   Instr[24:20] = rs2 (src)
--   Instr[19:15] = rs1 (base)
--   Instr[14:12] = funct3
--   Instr[11:7]  = imm[4:0]  (offset[4:0])
--   Instr[6:0]   = opcode
-- B-Type Instruction
--   beq rs1, rs2, imm (PCTarget = PC + (signed imm x 2))
--   Instr[31:25] = imm[12], imm[10:5]
--   Instr[24:20] = rs2
--   Instr[19:15] = rs1
--   Instr[14:12] = funct3
--   Instr[11:7]  = imm[4:1], imm[11]
--   Instr[6:0]   = opcode
-- J-Type Instruction
--   jal rd, imm  (signed imm is multiplied by 2 and added to PC, rd = PC+4)
--   Instr[31:12] = imm[20], imm[10:1], imm[11], imm[19:12]
--   Instr[11:7]  = rd
--   Instr[6:0]   = opcode

--   Instruction  opcode    funct3    funct7
--   add          0110011   000       0000000
--   sub          0110011   000       0100000
--   and          0110011   111       0000000
--   or           0110011   110       0000000
--   slt          0110011   010       0000000
--   addi         0010011   000       immediate
--   andi         0010011   111       immediate
--   ori          0010011   110       immediate
--   slti         0010011   010       immediate
--   beq          1100011   000       immediate
--   lw           0000011   010       immediate
--   sw           0100011   010       immediate
--   jal          1101111   immediate immediate

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.pkg_riscv_sc.all;

entity ICS_EDU_RV32I_SC is

  generic (TEXT_SEGMENT: string; DATA_SEGMENT: string; REGISTERS: string);
  port    (clk, reset: in  STD_ULOGIC;
           ram_regs  : out regs_ram;
           ram_dmem  : out dmem_ram); 

end;

architecture struct of ICS_EDU_RV32I_SC is

  component control_unit
    port( op              : in  STD_ULOGIC_VECTOR(6 downto 0);
          funct3          : in  STD_ULOGIC_VECTOR(2 downto 0);
          funct7_5        : in  STD_ULOGIC;
          Zero, AluSign            : in  STD_ULOGIC;
          ResultSrc       : out STD_ULOGIC_VECTOR(1 downto 0);
          MemWrite        : out STD_ULOGIC;
          PCSrc, ALUSrc, PcAdderSrcB   : out STD_ULOGIC;
          RegWrite        : out STD_ULOGIC;
          ImmSrc          : out STD_ULOGIC_VECTOR(IMM_SRC_SIZE-1 downto 0);
          ALUControl      : out STD_ULOGIC_VECTOR(ALU_CTRL_SIZE-1 downto 0));
  end component;
  component datapath
    generic (TEXT_SEGMENT     : string; DATA_SEGMENT: string; REGISTERS: string);
    port    ( clk, reset      : in  STD_ULOGIC;
              ResultSrc       : in  STD_ULOGIC_VECTOR(1  downto 0);
              PCSrc, ALUSrc   : in  STD_ULOGIC;
              RegWrite        : in  STD_ULOGIC;
              MemWrite        : in  STD_ULOGIC;
              ImmSrc          : in  STD_ULOGIC_VECTOR(IMM_SRC_SIZE-1 downto 0);
              ALUControl      : in  STD_ULOGIC_VECTOR(ALU_CTRL_SIZE-1 downto 0);
              PcAdderSrcB     : in STD_ULOGIC;
              Zero, AluSign            : out STD_ULOGIC;
              Instr           : out STD_ULOGIC_VECTOR(31 downto 0);
              
              ram_regs        : out regs_ram;
              ram_dmem        : out dmem_ram);
  end component;
    
  signal ALUSrc, RegWrite, MemWrite, Zero ,PCSrc, AluSign: STD_ULOGIC;
  signal Instr                                  : STD_ULOGIC_VECTOR(31 downto 0);
  signal ResultSrc                              : STD_ULOGIC_VECTOR(1 downto 0);
  signal ImmSrc                                 : STD_ULOGIC_VECTOR(IMM_SRC_SIZE-1 downto 0);
  signal ALUControl                             : STD_ULOGIC_VECTOR(ALU_CTRL_SIZE-1 downto 0);
  signal PcAdderMuxEnble                        : STD_ULOGIC;
begin

  c: control_unit port map(Instr(6 downto 0), Instr(14 downto 12), Instr(30), Zero,AluSign ,ResultSrc, MemWrite, PCSrc, ALUSrc, PcAdderMuxEnble ,RegWrite, ImmSrc, ALUControl);
  dp: datapath generic map (TEXT_SEGMENT, DATA_SEGMENT, REGISTERS) port map(clk, reset, ResultSrc, PCSrc, ALUSrc, RegWrite, MemWrite, ImmSrc, ALUControl, PcAdderMuxEnble ,Zero, AluSign,Instr, ram_regs, ram_dmem);

end;
