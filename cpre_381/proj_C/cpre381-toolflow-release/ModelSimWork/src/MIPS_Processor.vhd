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

 signal branchequal, branchnotequal, jump1control,jump2control,jump3control,jalcontrol,reg_dest, mem_load, ALUSrc, sign_zero, LorR, LogOrAri, shiftOrnot, shift_variable, Carry, dummyCarry, Overflow, dummyOF, Zero, dummyZero, lui : std_logic;
 signal ALUControl : std_logic_vector(3 downto 0);
 signal rtOrrd, shamt : std_logic_vector(4 downto 0);
 signal luiOrDmem, jump1,jump2,jump3,alu_A, shiftImm,jumpAddResult, alu_B,immediate, lui_immediate, immOrB, s_ALUOut,dMemOrALU,PCplusFour, jump_address : std_logic_vector(31 downto 0);

-- project C signals for pipeline
  signal s_RST_IFID,s_RST_IDEX,s_RST_EXMEM,s_RST_MEMWB, s_WE_IFID,s_WE_IDEX,s_WE_EXMEM,s_WE_MEMWB,s_i_mem_load_IDEX,s_o_mem_load_IDEX,s_i_lui_IDEX,s_o_lui_IDEX,s_i_jal_IDEX,s_o_jal_IDEX,s_i_DMemWr_IDEX,s_o_DMemWr_IDEX,s_i_ALUSrc_IDEX,s_o_ALUSrc_IDEX,s_i_reg_dst_IDEX,s_o_reg_dst_IDEX,s_i_LorR_IDEX,s_o_LorR_IDEX,s_i_LogOrAri_IDEX,s_o_LogOrAri_IDEX,s_i_shiftorNot_IDEX,s_o_shiftorNot_IDEX,s_i_shift_variable_IDEX,s_o_shift_variable_IDEX : std_logic;
  signal s_i_mem_load_EXMEM, s_o_mem_load_EXMEM, s_i_lui_EXMEM,s_o_lui_EXMEM,s_i_jal_EXMEM,s_o_jal_EXMEM,s_i_DMemWr_EXMEM,s_o_DMemWr_EXMEM,s_i_mem_load_MEMWB,s_o_mem_load_MEMWB,s_i_lui_MEMWB,s_o_lui_MEMWB,s_i_jal_MEMWB,s_o_jal_MEMWB : std_logic;
  signal s_i_ALUControl_IDEX,s_o_ALUControl_IDEX : std_logic_vector(3 downto 0);
  signal s_i_Inst_15to11_IDEX,s_o_Inst_15to11_IDEX,s_i_Inst_20to16_IDEX,s_o_Inst_20to16_IDEX,s_i_Inst_10to6_IDEX, s_o_Inst_10to6_IDEX, s_i_rtorrd_EXMEM,s_o_rtorrd_EXMEM,s_i_rtorrd_MEMWB,s_o_rtorrd_MEMWB: std_logic_vector(4 downto 0);
  signal s_i_PCplus4_IFID,s_o_PCplus4_IFID,s_i_Inst_IFID,s_o_Inst_IFID: std_logic_vector(31 downto 0); 
  signal s_i_Read_Data1_IDEX, s_o_Read_Data1_IDEX,s_i_Read_Data2_IDEX,s_o_Read_Data2_IDEX,s_i_immediate_IDEX,s_o_immediate_IDEX: std_logic_vector(31 downto 0);
  signal s_i_ALUOut_EXMEM,s_o_ALUOut_EXMEM,s_i_ALUOut_MEMWB,s_o_ALUOut_MEMWB,s_i_DMemOut_MEMWB,s_o_DMemOut_MEMWB,s_i_Read_Data2_EXMEM,s_o_Read_Data2_EXMEM : std_logic_vector(31 downto 0);

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
       o_bne : out std_logic; --control for bne
       o_beq : out std_logic; --control for beq
       o_jump : out std_logic; --control for jump
       o_jr : out std_logic; --control for jr
       o_jal: out std_logic; --control for jal
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

component IF_IDreg 
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST_IFID        : in std_logic;     -- Reset inputs
       i_WE_IFID         : in std_logic;     -- Write enable input
       --inputs to IF/ID register
       i_PCplus4_IFID : in std_logic_vector(31 downto 0);
       i_s_Inst_IFID : in std_logic_vector(31 downto 0);
       --outputs to IF/ID register
       o_PCplus4_IFID : out std_logic_vector(31 downto 0);
       o_s_Inst_IFID : out std_logic_vector(31 downto 0));
end component;

component ID_EXreg
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST_IDEX        : in std_logic;     -- Reset inputs
       i_WE_IDEX         : in std_logic;     -- Write enable input
       --datapath inputs to ID/EX register
       i_Read_Data1_IDEX : in std_logic_vector(31 downto 0);
       i_Read_Data2_IDEX : in std_logic_vector(31 downto 0);
       i_immediate_IDEX : in std_logic_vector(31 downto 0);
       i_s_Inst_10to6_IDEX : in std_logic_vector(4 downto 0);
       i_s_Inst_15to11_IDEX : in std_logic_vector(4 downto 0);
       i_s_Inst_20to16_IDEX : in std_logic_vector(4 downto 0);
       --control inputs to ID/EX register
       --WB Control
       i_mem_load_IDEX   : in std_logic;  
       i_lui_IDEX        : in std_logic;   
       i_jal_IDEX        : in std_logic;
       --M Control
       i_s_DMemWr_IDEX   : in std_logic;
       --Ex Control
       i_ALUSrc_IDEX   : in std_logic;
       i_reg_dst_IDEX   : in std_logic;
       i_ALUControl_IDEX   : in std_logic_vector(3 downto 0);
       i_LorR_IDEX   : in std_logic;
       i_LogOrAri_IDEX   : in std_logic;
       i_shiftorNot_IDEX   : in std_logic;
       i_shift_variable_IDEX   : in std_logic;
       --outputs of IF/ED register
       o_Read_Data1_IDEX : out std_logic_vector(31 downto 0);
       o_Read_Data2_IDEX : out std_logic_vector(31 downto 0);
       o_immediate_IDEX : out std_logic_vector(31 downto 0);
       o_s_Inst_10to6_IDEX : out std_logic_vector(4 downto 0);
       o_s_Inst_15to11_IDEX : out std_logic_vector(4 downto 0);
       o_s_Inst_20to16_IDEX : out std_logic_vector(4 downto 0);
       o_mem_load_IDEX   : out std_logic;  
       o_lui_IDEX        : out std_logic;   
       o_jal_IDEX        : out std_logic;
       o_s_DMemWr_IDEX   : out std_logic;
       o_ALUSrc_IDEX   : out std_logic;
       o_reg_dst_IDEX   : out std_logic;
       o_ALUControl_IDEX   : out std_logic_vector(3 downto 0);
       o_LorR_IDEX   : out std_logic;
       o_LogOrAri_IDEX   : out std_logic;
       o_shiftorNot_IDEX   : out std_logic;
       o_shift_variable_IDEX   : out std_logic);
end component;

component EX_Memreg 
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST_EXMEM        : in std_logic;     -- Reset inputs
       i_WE_EXMEM         : in std_logic;     -- Write enable input
       --datapath inputs for EX/MEM register
       i_s_Read_Data2_EXMEM : in std_logic_vector(31 downto 0);
       i_s_ALUOut_EXMEM : in std_logic_vector(31 downto 0);
       i_rtorrd_EXMEM : in std_logic_vector(4 downto 0);
       --control inputs for EX/MEM register
       --WB Control
       i_mem_load_EXMEM   : in std_logic;  
       i_lui_EXMEM        : in std_logic;   
       i_jal_EXMEM        : in std_logic;
       --M Control
       i_s_DMemWr_EXMEM   : in std_logic;
       --outputs for EX/MEM register
       o_s_Read_Data2_EXMEM : out std_logic_vector(31 downto 0);
       o_s_ALUOut_EXMEM : out std_logic_vector(31 downto 0);
       o_rtorrd_EXMEM : out std_logic_vector(4 downto 0);
       o_mem_load_EXMEM   : out std_logic;  
       o_lui_EXMEM        : out std_logic;   
       o_jal_EXMEM        : out std_logic;
       o_s_DMemWr_EXMEM   : out std_logic);
end component;

component MEM_WBreg
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST_MEMWB        : in std_logic;     -- Reset inputs
       i_WE_MEMWB         : in std_logic;     -- Write enable input
       --datapath inputs for MEM/WB register
       i_s_ALUOut_MEMWB : in std_logic_vector(31 downto 0);
       i_s_DMemOut_MEMWB : in std_logic_vector(31 downto 0);
       i_rtorrd_MEMWB : in std_logic_vector(4 downto 0);
       --control inputs for MEM/WB register
       --WB Control
       i_mem_load_MEMWB   : in std_logic;  
       i_lui_MEMWB        : in std_logic;   
       i_jal_MEMWB        : in std_logic;
       --outputs for MEM/WB register
       o_s_ALUOut_MEMWB : out std_logic_vector(31 downto 0);
       o_s_DMemOut_MEMWB : out std_logic_vector(31 downto 0);
       o_rtorrd_MEMWB : out std_logic_vector(4 downto 0);
       o_mem_load_MEMWB   : out std_logic;  
       o_lui_MEMWB        : out std_logic;   
       o_jal_MEMWB        : out std_logic);
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

 s_RST_IFID <= iRST;
 s_RST_IDEX <= iRST;
 s_RST_EXMEM <= iRST;
 s_RST_MEMWB <= iRST;
 s_WE_IFID <= '1';
 s_WE_IDEX <= '1';
 s_WE_EXMEM <= '1';
 s_WE_MEMWB <= '1';

 s_i_Inst_IFID <= s_Inst;

 ControlLogic : control_Unit
  port map(i_Opcode => s_o_Inst_IFID(31 downto 26), 
       i_Funct => s_o_Inst_IFID(5 downto 0),
       o_mem_load => s_i_mem_load_IDEX, 
       o_DMemWr => s_i_DMemWr_IDEX, 
       o_RegWr => s_RegWr, --keep same
       o_reg_dest => s_i_reg_dst_IDEX, 
       o_signorzero => sign_zero,
       o_ALUControl => s_i_ALUControl_IDEX, 
       o_LorR => s_i_LorR_IDEX, 
       o_LogOrAri => s_i_LogOrAri_IDEX, 
       o_shiftOrnot => s_i_shiftorNot_IDEX, 
       o_ALUSrc => s_i_ALUSrc_IDEX, 
       o_lui => s_i_lui_IDEX, 
       o_bne => branchnotequal, --keep same
       o_beq => branchequal, --keep same
       o_jump => jump2control, --keep same
       o_jr => jump3control, --keep same
       o_jal => s_i_jal_IDEX, --s_i_jal_IDEX
       o_shift_variable => s_i_shift_variable_IDEX); 

s_i_mem_load_EXMEM <= s_o_mem_load_IDEX;
s_i_lui_EXMEM <= s_o_lui_IDEX;
s_i_jal_EXMEM <= s_o_jal_IDEX;
s_i_DMemWr_EXMEM <= s_o_DMemWr_IDEX;
s_i_Read_Data2_EXMEM <= s_o_Read_Data2_IDEX;

s_i_lui_MEMWB <= s_o_lui_EXMEM;
s_i_jal_MEMWB <= s_o_jal_EXMEM;
s_i_rtorrd_MEMWB <= s_o_rtorrd_EXMEM;
s_i_mem_load_MEMWB <= s_o_mem_load_EXMEM;
s_i_ALUOut_MEMWB <= s_o_ALUOut_EXMEM;

 ProgramCounter : single_reg
  port map(i_CLK => iCLK,
       i_RST => iRST,
       i_WE => '1',
       i_D => jump3,
       o_Q => s_NextInstAddr);
	
 adder : projA_alu
  port map(i_A  => s_NextInstAddr,
       i_B  => x"00000004",
       i_Shamt => "00000",
       i_Control => "0000",
       i_LorR => '0',
       i_LogOrAri  => '0',
       i_shiftOrnot  => '0',
       o_F  => s_i_PCplus4_IFID, 
       o_Carry  => dummyCarry,
       o_Overflow  => dummyOF,
       o_Zero  => dummyZero);
	
adderJump : projA_alu
  port map(i_A  => s_o_PCplus4_IFID, 
       i_B  => shiftImm,
       i_Shamt => "00000",
       i_Control => "0000",
       i_LorR => '0',
       i_LogOrAri  => '0',
       i_shiftOrnot  => '0',
       o_F  => jumpAddResult,
       o_Carry  => dummyCarry,
       o_Overflow  => dummyOF,
       o_Zero  => dummyZero);

 Regfile : reg_file
  port map(i_CLK => iCLK,
		i_RST => iRST,
		i_WE => s_RegWr,
		i_WRITE_REG => s_RegWrAddr,
		i_WRITE_DATA => s_RegWrData,
		i_READ_REG1 => s_o_Inst_IFID(25 downto 21), 
		i_READ_REG2 => s_o_Inst_IFID(20 downto 16), 
		o_READ_DATA1 => s_i_Read_Data1_IDEX, 
		o_READ_DATA2 => s_i_Read_Data2_IDEX, 
		o_V0 => v0);

s_i_Inst_10to6_IDEX <= s_o_Inst_IFID(10 downto 6);
s_i_Inst_15to11_IDEX <= s_o_Inst_IFID(15 downto 11);
s_i_Inst_20to16_IDEX <= s_o_Inst_IFID(20 downto 16);

 mux0: gen_mux
    generic map(N => 5)
    port map(i_X0  => s_o_Inst_20to16_IDEX, 
             i_X1  => s_o_Inst_15to11_IDEX, 
             i_Sel => s_o_reg_dst_IDEX, 
  	     o_Y  => s_i_rtorrd_EXMEM); 

 mux1: gen_mux
   generic map(N => 32)
   port map(
	    i_X0 => s_o_Read_Data2_IDEX, 
	    i_X1 => s_o_immediate_IDEX, 
	    i_Sel => s_o_ALUSrc_IDEX, 
	    o_Y => immOrB);

 mux2: gen_mux
   generic map(N => 5)
   port map(
	    i_X0 => s_o_Inst_10to6_IDEX,
	    i_X1 => s_o_Read_Data1_IDEX(4 downto 0), 
	    i_Sel => s_o_shift_variable_IDEX, 
	    o_Y => shamt);

 mux3: gen_mux
  generic map(N => 32)
  port map(
	    i_X0	       => s_o_ALUOut_MEMWB, 
	    i_X1	       => s_o_DMemOut_MEMWB, 
	    i_Sel	       => s_o_mem_load_MEMWB, 
	    o_Y		       => dMemOrALU);

 mux4: gen_mux
  generic map(N => 32)
  port map(
	    i_X0	       => s_i_PCplus4_IFID, --s_o_PCplus4_IFID
	    i_X1	       => jumpAddResult,
	    i_Sel	       => jump1control,
	    o_Y		       => jump1);
		
 mux5: gen_mux
  generic map(N => 32)
  port map(
	    i_X0	       => jump1,
	    i_X1	       => jump_address,
	    i_Sel	       => jump2control,
	    o_Y		       => jump2);

mux6: gen_mux
  generic map(N => 32)
  port map(
	    i_X0	       => dMemOrALU,
	    i_X1	       => lui_immediate,
	    i_Sel	       => s_o_lui_MEMWB, 
	    o_Y		       => luiOrDmem);

 mux7: gen_mux
  generic map(N => 32)
  port map(
	    i_X0	       => jump2,
	    i_X1	       => s_i_Read_Data1_IDEX, 
	    i_Sel	       => jump3control,
	    o_Y		       => jump3);

mux8: gen_mux
  generic map(N => 32)
  port map(
	    i_X0	       => luiOrDmem,
	    i_X1	       => s_o_PCplus4_IFID, --s_o_PCplus4_IFID
	    i_Sel	       => s_o_jal_MEMWB, --s_o_jal_MEMWB
	    o_Y		       => s_RegWrData);

mux9: gen_mux
  generic map(N => 5)
  port map(
	    i_X0	       => s_i_rtorrd_MEMWB, --s_o_rtorrd_MEMWB
	    i_X1	       => "11111",
	    i_Sel	       => s_i_jal_MEMWB, --s_o_jal_MEMWB
	    o_Y		       => s_RegWrAddr);


sign_extend : sign_extender
  port map(i_X0 => s_Inst(15 downto 0),
	signOrzero => sign_zero,
	o_Y => s_i_immediate_IDEX); 

lui_module : lui_Unit
  port map(immediate => s_Inst(15 downto 0),
	   extended => lui_immediate);

 alu : projA_alu
  port map(i_A  => s_o_Read_Data1_IDEX, 
       i_B  => immOrB,
       i_Shamt => shamt,
       i_Control => s_o_ALUControl_IDEX, 
       i_LorR => s_o_LorR_IDEX, 
       i_LogOrAri  => s_o_LogOrAri_IDEX, 
       i_shiftOrnot  => s_o_shiftorNot_IDEX,
       o_F  => s_i_ALUOut_EXMEM, 
       o_Carry  => Carry,
       o_Overflow  => Overflow,
       o_Zero  => dummyZero);

if_id: IF_IDreg
  port map(i_CLK => iCLK,
       i_RST_IFID  => s_RST_IFID,
       i_WE_IFID   => s_WE_IFID,
       i_PCplus4_IFID => s_i_PCplus4_IFID,
       i_s_Inst_IFID => s_i_Inst_IFID,
       o_PCplus4_IFID => s_o_PCplus4_IFID,
       o_s_Inst_IFID => s_o_Inst_IFID);

id_ex: ID_EXreg
  port map(i_CLK => iCLK,
       i_RST_IDEX  => s_RST_IDEX,
       i_WE_IDEX   => s_WE_IDEX,    
       i_Read_Data1_IDEX => s_i_Read_Data1_IDEX,
       i_Read_Data2_IDEX => s_i_Read_Data2_IDEX,
       i_immediate_IDEX => s_i_immediate_IDEX,
       i_s_Inst_10to6_IDEX => s_i_Inst_10to6_IDEX,
       i_s_Inst_15to11_IDEX => s_i_Inst_15to11_IDEX,
       i_s_Inst_20to16_IDEX => s_i_Inst_20to16_IDEX,
       i_mem_load_IDEX     => s_i_mem_load_IDEX,
       i_lui_IDEX          => s_i_lui_IDEX,
       i_jal_IDEX          => s_i_jal_IDEX,
       i_s_DMemWr_IDEX  => s_i_DMemWr_IDEX,
       i_ALUSrc_IDEX   => s_i_ALUSrc_IDEX,
       i_reg_dst_IDEX   => s_i_reg_dst_IDEX,
       i_ALUControl_IDEX   => s_i_ALUControl_IDEX,
       i_LorR_IDEX => s_i_LorR_IDEX,  
       i_LogOrAri_IDEX   => s_i_LogOrAri_IDEX,
       i_shiftorNot_IDEX  => s_i_shiftorNot_IDEX,
       i_shift_variable_IDEX   => s_i_shift_variable_IDEX,
       o_Read_Data1_IDEX => s_o_Read_Data1_IDEX,
       o_Read_Data2_IDEX => s_o_Read_Data2_IDEX,
       o_immediate_IDEX => s_o_immediate_IDEX,
       o_s_Inst_10to6_IDEX => s_o_Inst_10to6_IDEX,
       o_s_Inst_15to11_IDEX => s_o_Inst_15to11_IDEX,
       o_s_Inst_20to16_IDEX => s_o_Inst_20to16_IDEX,
       o_mem_load_IDEX     => s_o_mem_load_IDEX,
       o_lui_IDEX          => s_o_lui_IDEX,
       o_jal_IDEX        => s_o_jal_IDEX,
       o_s_DMemWr_IDEX   => s_o_DMemWr_IDEX,
       o_ALUSrc_IDEX   => s_o_ALUSrc_IDEX,
       o_reg_dst_IDEX   => s_o_reg_dst_IDEX,
       o_ALUControl_IDEX   => s_o_ALUControl_IDEX,
       o_LorR_IDEX   => s_o_LorR_IDEX,
       o_LogOrAri_IDEX   => s_o_LogOrAri_IDEX,
       o_shiftorNot_IDEX  => s_o_shiftorNot_IDEX,
       o_shift_variable_IDEX   => s_o_shift_variable_IDEX);

  ex_mem: EX_MEMreg
  port map(i_CLK => iCLK,
       i_RST_EXMEM  => s_RST_EXMEM,
       i_WE_EXMEM   => s_WE_EXMEM,
       i_s_Read_Data2_EXMEM => s_i_Read_Data2_EXMEM,
       i_s_ALUOut_EXMEM => s_i_ALUOut_EXMEM,
       i_rtorrd_EXMEM => s_i_rtorrd_EXMEM,
       i_mem_load_EXMEM  => s_i_mem_load_EXMEM,
       i_lui_EXMEM   => s_i_lui_EXMEM,  
       i_jal_EXMEM  => s_i_jal_EXMEM,
       i_s_DMemWr_EXMEM  => s_i_DMemWr_EXMEM,
       o_s_Read_Data2_EXMEM => s_o_Read_Data2_EXMEM,
       o_s_ALUOut_EXMEM => s_o_ALUOut_EXMEM,
       o_rtorrd_EXMEM => s_o_rtorrd_EXMEM,
       o_mem_load_EXMEM   => s_o_mem_load_EXMEM,
       o_lui_EXMEM    => s_o_lui_EXMEM,
       o_jal_EXMEM     => s_o_jal_EXMEM,   
       o_s_DMemWr_EXMEM  => s_o_DMemWr_EXMEM);

  mem_wb: MEM_WBreg
  port map(i_CLK => iCLK,
       i_RST_MEMWB  => s_RST_MEMWB,
       i_WE_MEMWB   => s_WE_MEMWB,
       i_s_ALUOut_MEMWB => s_i_ALUOut_MEMWB,
       i_s_DMemOut_MEMWB => s_i_DMemOut_MEMWB,
       i_rtorrd_MEMWB  => s_i_rtorrd_MEMWB,
       i_mem_load_MEMWB  => s_i_mem_load_MEMWB,
       i_lui_MEMWB      => s_i_lui_MEMWB,
       i_jal_MEMWB     => s_i_jal_MEMWB,
       o_s_ALUOut_MEMWB => s_o_ALUOut_MEMWB,
       o_s_DMemOut_MEMWB => s_o_DMemOut_MEMWB,
       o_rtorrd_MEMWB => s_o_rtorrd_MEMWB,
       o_mem_load_MEMWB  => s_o_mem_load_MEMWB,
       o_lui_MEMWB    => s_o_lui_MEMWB,   
       o_jal_MEMWB   => s_o_jal_MEMWB);

-- assign "Zero" signal correctly by checking readdata1 and readdata2

shiftImm(31 downto 2) <= s_i_immediate_IDEX(29 downto 0); 
shiftImm(1 downto 0) <= "00";

jump_address(31 downto 28) <= s_o_PCplus4_IFID(31 downto 28); 
jump_address(27 downto 2) <= s_o_Inst_IFID(25 downto 0); 
jump_address(1 downto 0) <= "00";

process (Zero, s_i_Read_Data1_IDEX, s_i_Read_Data2_IDEX )
begin
	if (s_i_Read_Data1_IDEX = s_i_Read_Data2_IDEX) then Zero <= '1';
	end if;
end process;

jump1control <= (branchequal and Zero) or (branchnotequal and not Zero);

s_DMemData <= s_o_Read_Data2_EXMEM; 
s_DMemAddr <= s_o_ALUOut_EXMEM;
oALUOut <= s_o_ALUOut_EXMEM; 

end structure;
