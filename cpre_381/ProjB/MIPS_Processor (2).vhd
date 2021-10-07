-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity MIPS_Processor is
  generic(N : integer := 32);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal v0             : std_logic_vector(N-1 downto 0); -- TODO: should be assigned to the output of register 2, used to implement the halt SYSCALL
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. This case happens when the syscall instruction is observed and the V0 register is at 0x0000000A. This signal is active high and should only be asserted after the last register and memory writes before the syscall are guaranteed to be completed.

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

 signal reg_dest, mem_load, ALUSrc, sign_zero, LorR, LogOrAri, shiftOrnot, shift_variable, Carry, dummyCarry, Overflow, dummyOF, Zero, dummyZero, lui : std_logic;
 signal ALUControl : std_logic_vector(3 downto 0);
 signal rtOrrd, shamt : std_logic_vector(4 downto 0);
 signal alu_A, alu_B,immediate, lui_immediate, immOrB, s_ALUOut,dMemOrALU,PCplusFour : std_logic_vector(31 downto 0);

component reg_file
port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset inputs
       i_WE         : in std_logic;     -- Write enable input(goes into decoder)
       i_WRITE_REG  : in std_logic_vector(4 downto 0);	-- Select line for decoder,output of decoder goes into corresponding register
       i_WRITE_DATA : in std_logic_vector(31 downto 0); -- goes into D of every register
       i_READ_REG1  : in std_logic_vector(4 downto 0); -- goes into first 32:1 mux select line
       i_READ_REG2  : in std_logic_vector(4 downto 0); -- goes into second 32:1 mux select line
       o_READ_DATA1 : out std_logic_vector(31 downto 0); -- output of first 32:1 mux
       o_READ_DATA2 : out std_logic_vector(31 downto 0);
       o_V0	    : out std_logic_vector(31 downto 0)); -- ouptut of second 32:1 mux
end component;

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
       o_shift_variable : out std_logic); --choose to variable shift(sllv, srlv, srav)
end component;

component projA_alu 
  port(i_A,i_B  : in std_logic_vector(31 downto 0);
       i_Shamt: in std_logic_vector(4 downto 0);
       i_Control: in std_logic_vector(3 downto 0);
       i_LorR: in std_logic; -- '0' is left
       i_LogOrAri: in std_logic; --'0' is logical
       i_shiftOrnot : in std_logic; --named this way to be clear
       o_F  : out std_logic_vector(31 downto 0);
       o_Carry,o_Overflow,o_Zero : out std_logic);
end component;

component sign_extender
port(i_X0  : in std_logic_vector(15 downto 0);
       signOrzero: in std_logic;
       o_Y  : out std_logic_vector(31 downto 0));
end component;

component lui_Unit
port(immediate : in std_logic_vector(15 downto 0);
       extended : out std_logic_vector(31 downto 0));
end component;

component gen_mux 
  generic(N : integer);
  port(i_X0  : in std_logic_vector(N-1 downto 0);
       i_X1  : in std_logic_vector(N-1 downto 0);
       i_Sel: in std_logic;
       o_Y  : out std_logic_vector(N-1 downto 0));
end component;

component single_reg
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(31 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(31 downto 0));   -- Data value output
end component;


begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  s_Halt <='1' when (s_Inst(31 downto 26) = "000000") and (s_Inst(5 downto 0) = "001100") and (v0 = "00000000000000000000000000001010") else '0';

  -- TODO: Implement the rest of your processor below this comment! 

 ControlLogic : control_Unit
  port map(i_Opcode => s_Inst(31 downto 26),
       i_Funct => s_Inst(5 downto 0),
       o_mem_load => mem_load, 
       o_DMemWr => s_DMemWr,
       o_RegWr => s_RegWr,
       o_reg_dest => reg_dest,
       o_signorzero => sign_zero,
       o_ALUControl => ALUControl, 
       o_LorR => LorR,
       o_LogOrAri => LogOrAri,
       o_shiftOrnot => shiftOrnot,
       o_ALUSrc => ALUSrc,
       o_lui => lui,
       o_shift_variable => shift_variable);

 ProgramCounter : single_reg
  port map(i_CLK => iCLK,
       i_RST => iRST,
       i_WE => '1',
       i_D => PCplusFour,
       o_Q => s_NextInstAddr);

 adder : projA_alu
  port map(i_A  => s_NextInstAddr,
       i_B  => x"00000004",
       i_Shamt => "00000",
       i_Control => "0000",
       i_LorR => '0',
       i_LogOrAri  => '0',
       i_shiftOrnot  => '0',
       o_F  => PCplusFour,
       o_Carry  => dummyCarry,
       o_Overflow  => dummyOF,
       o_Zero  => dummyZero);

 Regfile : reg_file
  port map(i_CLK => iCLK,
		i_RST => iRST,
		i_WE => s_RegWr,
		i_WRITE_REG => s_RegWrAddr,
		i_WRITE_DATA => s_RegWrData,
		i_READ_REG1 => s_Inst(25 downto 21),
		i_READ_REG2 => s_Inst(20 downto 16),
		o_READ_DATA1 => alu_A,
		o_READ_DATA2 => alu_B,
		o_V0 => v0);

 mux0: gen_mux
    generic map(N => 5)
    port map(i_X0  => s_Inst(20 downto 16),
             i_X1  => s_Inst(15 downto 11),
             i_Sel => reg_dest,
  	     o_Y  => s_RegWrAddr);

 mux1: gen_mux
   generic map(N => 32)
   port map(
	    i_X0 => alu_B,
	    i_X1 => immediate,
	    i_Sel => ALUSrc,
	    o_Y => immOrB);

 mux2: gen_mux
   generic map(N => 5)
   port map(
	    i_X0 => s_Inst(10 downto 6),
	    i_X1 => alu_A(4 downto 0), --bottom 5 bits of rs register for shifting by variable
	    i_Sel => shift_variable,
	    o_Y => shamt);

 mux3: gen_mux
  generic map(N => 32)
  port map(
	    i_X0	       => s_ALUOut,
	    i_X1	       => s_DMemOut,
	    i_Sel	       => s_DMemWr,
	    o_Y		       => dMemOrALU);

sign_extend : sign_extender
  port map(i_X0 => s_Inst(15 downto 0),
	signOrzero => sign_zero,
	o_Y => immediate);

lui_module : lui_Unit
  port map(immediate => s_Inst(15 downto 0),
	   extended => lui_immediate);

 mux4: gen_mux
  generic map(N => 32)
  port map(
	    i_X0	       => dMemOrALU,
	    i_X1	       => lui_immediate,
	    i_Sel	       => lui,
	    o_Y		       => s_RegWrData);

 alu : projA_alu
  port map(i_A  => alu_A,
       i_B  => immOrB,
       i_Shamt => shamt,
       i_Control => ALUControl,
       i_LorR => LorR,
       i_LogOrAri  => LogOrAri,
       i_shiftOrnot  => shiftOrnot,
       o_F  => s_ALUOut,
       o_Carry  => Carry,
       o_Overflow  => Overflow,
       o_Zero  => Zero);

s_DMemData <= alu_B;
s_DMemAddr <= s_ALUOut;
oALUOut <= s_ALUOut;

end structure;
