library IEEE;
use IEEE.std_logic_1164.all;

entity control_Unit is
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

end control_Unit;

architecture control_logic of control_Unit is
begin

o_mem_load <= '1' when (i_Opcode = "100011") else
	      '0';

o_DMemWr <= '1' when (i_Opcode = "101011") else
	    '0';

o_RegWr <= '1' when (i_Opcode = "001000") else
	   '1' when (i_Opcode = "001001") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "100001") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "100000") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "100100") else
	   '1' when (i_Opcode = "001100") else
	   '1' when (i_Opcode = "001111") else
	   '1' when (i_Opcode = "100011") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "100111") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "100110") else
	   '1' when (i_Opcode = "001110") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "100101") else
	   '1' when (i_Opcode = "001101") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "101010") else
	   '1' when (i_Opcode = "001010") else
	   '1' when (i_Opcode = "001011") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "101011") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "000000") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "000010") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "000011") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "000100") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "000110") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "000111") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "100010") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "100011") else
	   '1' when (i_Opcode = "000011") else
	   '0';

o_reg_dest <= '1' when (i_Opcode = "000000" AND i_Funct = "100001") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "100000") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "100100") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "100111") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "100110") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "100101") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "101010") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "101011") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "000000") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "000010") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "000011") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "000100") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "000110") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "000111") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "100010") else
	   '1' when (i_Opcode = "000000" AND i_Funct = "100011") else
	   '0';

o_signorzero <= '1' when (i_Opcode = "001000") else
	   '1' when (i_Opcode = "001001") else
	   '1' when (i_Opcode = "100011") else
	   '1' when (i_Opcode = "001110") else
	   '1' when (i_Opcode = "001010") else
	   '1' when (i_Opcode = "001011") else
	   '1' when (i_Opcode = "101011") else
	   '0';

o_ALUControl <= "0000" when (i_Opcode = "001000") else
	   "0010" when (i_Opcode = "001001") else
	   "0010" when (i_Opcode = "000000" AND i_Funct = "100001") else
	   "0000" when (i_Opcode = "000000" AND i_Funct = "100000") else
	   "0101" when (i_Opcode = "000000" AND i_Funct = "100100") else
	   "0101" when (i_Opcode = "001100") else
	   "0000" when (i_Opcode = "001111") else
	   "0000" when (i_Opcode = "100011") else
	   "1001" when (i_Opcode = "000000" AND i_Funct = "100111") else
	   "0111" when (i_Opcode = "000000" AND i_Funct = "100110") else
	   "0111" when (i_Opcode = "001110") else
	   "0110" when (i_Opcode = "000000" AND i_Funct = "100101") else
	   "0110" when (i_Opcode = "001101") else
	   "0100" when (i_Opcode = "000000" AND i_Funct = "101010") else
	   "0100" when (i_Opcode = "001010") else
	   "0100" when (i_Opcode = "001011") else
	   "0000" when (i_Opcode = "000000" AND i_Funct = "101011") else
	   "0000" when (i_Opcode = "000000" AND i_Funct = "000000") else
	   "0000" when (i_Opcode = "000000" AND i_Funct = "000010") else
	   "0000" when (i_Opcode = "000000" AND i_Funct = "000011") else
	   "0000" when (i_Opcode = "000000" AND i_Funct = "000100") else
	   "0000" when (i_Opcode = "000000" AND i_Funct = "000110") else
	   "0000" when (i_Opcode = "000000" AND i_Funct = "000111") else
	   "0000" when (i_Opcode = "101011") else
	   "0001" when (i_Opcode = "000000" AND i_Funct = "100010") else
	   "0011" when (i_Opcode = "000000" AND i_Funct = "100011") else
	   "0001" when (i_Opcode = "000100") else
	   "0001" when (i_Opcode = "000101") else
	   "0000";

o_ALUSrc <= '1' when (i_Opcode = "001000") else
	   '1' when (i_Opcode = "001001") else
	   '1' when (i_Opcode = "001100") else
	   '1' when (i_Opcode = "001111") else
	   '1' when (i_Opcode = "100011") else
	   '1' when (i_Opcode = "001110") else
	   '1' when (i_Opcode = "001101") else
	   '1' when (i_Opcode = "001010") else
	   '1' when (i_Opcode = "001011") else
	   '1' when (i_Opcode = "101011") else
	   '0';

o_LorR <= '1' when (i_Opcode = "000000" AND i_Funct = "000010") else
	  '1' when (i_Opcode = "000000" AND i_Funct = "000011") else
	  '1' when (i_Opcode = "000000" AND i_Funct = "000110") else
	  '1' when (i_Opcode = "000000" AND i_Funct = "000111") else
	  '0';

o_LogOrAri <= '1' when (i_Opcode = "000000" AND i_Funct = "000011") else
	      '1' when (i_Opcode = "000000" AND i_Funct = "000111") else
	      '0';

o_shiftOrnot <= '1' when (i_Opcode = "000000" AND i_Funct = "000000") else
		'1' when (i_Opcode = "000000" AND i_Funct = "000010") else
		'1' when (i_Opcode = "000000" AND i_Funct = "000011") else
		'1' when (i_Opcode = "000000" AND i_Funct = "000100") else
		'1' when (i_Opcode = "000000" AND i_Funct = "000110") else
		'1' when (i_Opcode = "000000" AND i_Funct = "000111") else
	        '0';

o_shift_variable <= '1' when (i_Opcode = "000000" AND i_Funct = "000100") else
		'1' when (i_Opcode = "000000" AND i_Funct = "000110") else
		'1' when (i_Opcode = "000000" AND i_Funct = "000111") else
	        '0';

o_lui <= '1' when (i_Opcode = "001111") else
         '0';

o_bne <= '1' when (i_Opcode = "000101") else
         '0';

o_beq <= '1' when (i_Opcode = "000100") else
         '0';

o_jump <= '1' when (i_Opcode = "000010") else
	  '1' when (i_Opcode = "000011") else
         '0';

o_jr <= '1' when (i_Opcode = "000000" AND i_Funct = "001000") else
         '0';

o_jal <= '1' when (i_Opcode = "000011") else
	   '0';

end control_logic;
 