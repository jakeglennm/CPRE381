library IEEE;
use IEEE.std_logic_1164.all;

use work.vector_type.all;

entity projA_proc is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset inputs
       i_reg_we     : in std_logic;     -- Write enable input(goes into decoder)
       i_mem_load   : in std_logic;     -- Control to load from memory
       i_mem_store  : in std_logic;     -- Control to store into memory
       i_reg_dest   : in std_logic;     -- use rd for r-format, rt for immediate types
       i_signorzero : in std_logic;     -- Control for sign extender unit
       i_rd : in std_logic_vector(4 downto 0);	-- Select line for decoder,output of decoder goes into corresponding register
       i_rs  : in std_logic_vector(4 downto 0); -- goes into first 32:1 mux select line
       i_rt  : in std_logic_vector(4 downto 0); -- goes into second 32:1 mux select line
       i_Control  : in std_logic_vector(3 downto 0); --4 bit value to choose which ALU operation
       i_Shamt : in std_logic_vector(4 downto 0); -- amount to shift
       i_LorR : in std_logic; --shift left or right
       i_LogOrAri : in std_logic; --shift logical or arithmetic
       i_shiftOrnot : in std_logic;--shift or not
       i_Immed : in std_logic_vector(15 downto 0); -- 16 bitimmediate
       i_ALUSrc : in std_logic); -- choose to use immediate or register data

end projA_proc;

architecture structure of projA_proc is

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
 
component reg_file
port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset inputs
       i_WE         : in std_logic;     -- Write enable input(goes into decoder)
       i_WRITE_REG  : in std_logic_vector(4 downto 0);	-- Select line for decoder,output of decoder goes into corresponding register
       i_WRITE_DATA : in std_logic_vector(31 downto 0); -- goes into D of every register
       i_READ_REG1  : in std_logic_vector(4 downto 0); -- goes into first 32:1 mux select line
       i_READ_REG2  : in std_logic_vector(4 downto 0); -- goes into second 32:1 mux select line
       o_READ_DATA1 : out std_logic_vector(31 downto 0); -- output of first 32:1 mux
       o_READ_DATA2 : out std_logic_vector(31 downto 0)); -- ouptut of second 32:1 mux
end component;

component mem
	generic 
	(
		DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 10
	);

	port 
	(
		clk		: in std_logic;
		addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
		data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);
end component;

component twoto1mux
   port(i_X0  : in std_logic;
       i_X1  : in std_logic;
       i_Sel: in std_logic;
       o_Y  : out std_logic);
end component;

component twoto1muxflow is
  port(i_X0  : in std_logic_vector(31 downto 0);
       i_X1  : in std_logic_vector(31 downto 0);
       i_Sel: in std_logic;
       o_Y  : out std_logic_vector(31 downto 0));

end component;

component gen_mux 
  generic(N : integer := 5);
  port(i_X0  : in std_logic_vector(N-1 downto 0);
       i_X1  : in std_logic_vector(N-1 downto 0);
       i_Sel: in std_logic;
       o_Y  : out std_logic_vector(N-1 downto 0));

end component;

signal reg_values : reg_inputs; -- vector_type
signal alu_A, alu_B, alu_Out, mem_out, write_data,immOrB : std_logic_vector(31 downto 0);
signal carry_out,overflow,zero, mem_we : std_logic;
signal rtOrrd : std_logic_vector(4 downto 0);
signal mem_addr : std_logic_vector(9 downto 0);
signal immediate : std_logic_vector(31 downto 0);

begin

sign_extend : sign_extender
  port map(i_X0 => i_Immed,
	signOrzero => i_signorzero,
	o_Y => immediate);

mux0: twoto1muxflow
  port map(
	    i_X0	       => alu_B,
	    i_X1	       => immediate,
	    i_Sel	       => i_ALUSrc,
	    o_Y		       => immOrB);

mux1: twoto1muxflow
  port map(
	    i_X0	       => alu_Out,
	    i_X1	       => mem_out,
	    i_Sel	       => i_mem_load,
	    o_Y		       => write_data);

mux2: twoto1mux
  port map(
	    i_X0	       => '0',
	    i_X1	       => '1',
	    i_Sel	       => i_mem_store,
	    o_Y		       => mem_we);

mux3: gen_mux
    port map(i_X0  => i_rt,
             i_X1  => i_rd,
		  i_Sel => i_reg_dest,
  	          o_Y  => rtOrrd);

regfile : reg_file
  port map(i_CLK => i_CLK,
		i_RST => i_RST,
		i_WE => i_reg_we,
		i_WRITE_REG => rtOrrd,
		i_WRITE_DATA => write_data,
		i_READ_REG1 => i_rs,
		i_READ_REG2 => i_rt,
		o_READ_DATA1 => alu_A,
		o_READ_DATA2 => alu_B);

alu : projA_alu
  port map(i_A  => alu_A,
       i_B  => immOrB,
       i_Shamt => i_Shamt,
       i_Control => i_Control,
       i_LorR => i_LorR,
       i_LogOrAri  => i_LogOrAri,
       i_shiftOrnot  => i_shiftOrnot,
       o_F  => alu_Out,
       o_Carry  => carry_out,
       o_Overflow  => overflow,
       o_Zero  => zero);

mem_addr <= alu_Out(11 downto 2);

memory : mem
  port map(clk => i_CLK,
	addr => mem_addr,
	data => alu_B,
	we => mem_we,
	q => mem_out);

end structure;