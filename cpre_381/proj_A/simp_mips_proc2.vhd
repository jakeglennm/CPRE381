library IEEE;
use IEEE.std_logic_1164.all;

use work.vector_type.all;

entity simp_mips_proc2 is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset inputs
       i_reg_we     : in std_logic;     -- Write enable input(goes into decoder)
       i_mem_load   : in std_logic;     -- Control to load from memory
       i_mem_store  : in std_logic;     -- Control to store into memory
       i_signorzero : in std_logic;     -- Control for sign extender unit
       i_rd : in std_logic_vector(4 downto 0);	-- Select line for decoder,output of decoder goes into corresponding register
       i_rs  : in std_logic_vector(4 downto 0); -- goes into first 32:1 mux select line
       i_rt  : in std_logic_vector(4 downto 0); -- goes into second 32:1 mux select line
       i_Immed : in std_logic_vector(15 downto 0);
       i_ALUSrc : in std_logic; -- choose to use immediate or register data
       i_addorsub : in std_logic); -- add or subtract numbers from regfile

end simp_mips_proc2;

architecture structure of simp_mips_proc2 is

component nbitadder_sub_ALU
port(i_X0  : in std_logic_vector(31 downto 0);
       i_X1  : in std_logic_vector(31 downto 0);
       i_nAdd_Sub : in std_logic;
       i_ALUSrc : in std_logic;
       i_Imm : std_logic_vector(31 downto 0);
       i_Ci  : in std_logic;
       o_Co  : out std_logic;
       o_So  : out std_logic_vector(31 downto 0));
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
  generic(N : integer := 32);
  port(i_X0  : in std_logic_vector(N-1 downto 0);
       i_X1  : in std_logic_vector(N-1 downto 0);
       i_Sel: in std_logic;
       o_Y  : out std_logic_vector(N-1 downto 0));

end component;

signal reg_values : reg_inputs; -- vector_type
signal alu_A, alu_B, alu_Out, mem_out, write_data : std_logic_vector(31 downto 0);
signal i_Ci, o_Co, mem_we : std_logic;
signal mem_addr : std_logic_vector(9 downto 0);
signal immediate : std_logic_vector(31 downto 0);

begin

sign_extend : sign_extender
  port map(i_X0 => i_Immed,
	signOrzero => i_signorzero,
	o_Y => immediate);

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

regfile : reg_file
  port map(i_CLK => i_CLK,
		i_RST => i_RST,
		i_WE => i_reg_we,
		i_WRITE_REG => i_rd,
		i_WRITE_DATA => write_data,
		i_READ_REG1 => i_rs,
		i_READ_REG2 => i_rt,
		o_READ_DATA1 => alu_A,
		o_READ_DATA2 => alu_B);

alu : nbitadder_sub_ALU
  port map(i_X0  => alu_A,
       i_X1  => alu_B,
       i_nAdd_Sub => i_addorsub,
       i_ALUSrc => i_ALUSrc,
       i_Imm => immediate,
       i_Ci  => i_Ci,
       o_Co  => o_Co,
       o_So  => alu_Out);

mem_addr <= alu_out(11 downto 2);

memory : mem
  port map(clk => i_CLK,
	addr => mem_addr,
	data => alu_B,
	we => mem_we,
	q => mem_out);

end structure;