library IEEE;
use IEEE.std_logic_1164.all;

entity tb_controlunit is
 
end tb_controlunit;

architecture structure of tb_controlunit is 

component control_Unit 
  port(i_Opcode : in std_logic_vector(5 downto 0);
       i_Funct  : in std_logic_vector(5 downto 0);
       o_mem_load   : out std_logic;     -- Control to load from memory
       o_DMemWr : out std_logic; -- dmem store(write to mem) enable
       o_RegWr  : out std_logic; --reg file write enable
       o_reg_dest   : out std_logic;     -- use rd for r-format, rt for immediate types
       o_signorzero : out std_logic;     -- Control for sign extender unit
       o_ALUControl  : out std_logic_vector(3 downto 0); --4 bit value to choose which ALU operation
       o_LorR : out std_logic; --shift left or right
       o_LogOrAri : out std_logic; --shift logical or arithmetic
       o_shiftOrnot : out std_logic;--shift or not
       o_ALUSrc : out std_logic; -- choose to use immediate or register data
       o_lui : out std_logic; -- choose to load upper immediate or not(for write data to reg file)
       o_bne : out std_logic; --control for bne
       o_beq : out std_logic; --control for beq
       o_jump : out std_logic; --control for jump
       o_jr : out std_logic; --control for jr
       o_jal: out std_logic; --control for jal
       o_shift_variable : out std_logic); --choose to variable shift(sllv, srlv, srav)
end component;

signal opcode, funct : std_logic_vector(5 downto 0);
signal alucontrol : std_logic_vector(3 downto 0);
signal memload,dmemwr,regwr,regdest,signorzero,LorR,logorari,shiftornot,alusrc,lui,bne,beq,jump,jr,jal,shiftvariable : std_logic;

begin 

ControlLogic : control_Unit
  port map(i_Opcode => opcode,
       i_Funct => funct,
       o_mem_load => memload, 
       o_DMemWr => dmemwr,
       o_RegWr => regwr,
       o_reg_dest => regdest,
       o_signorzero => signorzero,
       o_ALUControl => alucontrol, 
       o_LorR => LorR,
       o_LogOrAri => logorari,
       o_shiftOrnot => shiftOrnot,
       o_ALUSrc => alusrc,
       o_lui => lui,
       o_bne => bne,
       o_beq => beq,
       o_jump => jump,
       o_jr => jr,
       o_jal => jal,
       o_shift_variable => shiftvariable);

process
begin

    opcode <= "001000"; --addi
    funct <= "000000";
    wait for 100 ns;

    opcode <= "100011"; --lw
    funct <= "000000";
    wait for 100 ns;

    opcode <= "000000";  --xor
    funct <= "100110";
    wait for 100 ns;

    opcode <= "000000"; --sll
    funct <= "000000";
    wait for 100 ns;

    opcode <= "000000"; --srav
    funct <= "000111";
    wait for 100 ns;

    opcode <= "000100"; --beq
    funct <= "000000";
    wait for 100 ns;

    opcode <= "000000"; --jr
    funct <= "001000";
    wait for 100 ns;



  end process;


end structure;
