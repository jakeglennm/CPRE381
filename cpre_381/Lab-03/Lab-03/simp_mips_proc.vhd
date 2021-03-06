library IEEE;
use IEEE.std_logic_1164.all;

use work.vector_type.all;

entity simp_mips_proc is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset inputs
       i_WE         : in std_logic;     -- Write enable input(goes into decoder)
       i_rd : in std_logic_vector(4 downto 0);	-- Select line for decoder,output of decoder goes into corresponding register
       i_rs  : in std_logic_vector(4 downto 0); -- goes into first 32:1 mux select line
       i_rt  : in std_logic_vector(4 downto 0); -- goes into second 32:1 mux select line
       i_Imm : in std_logic_vector(31 downto 0);
       i_ALUSrc : in std_logic;
       i_addorsub : in std_logic);

end simp_mips_proc;

architecture structure of simp_mips_proc is

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

signal reg_values : reg_inputs; -- vector_type
signal alu_A, alu_B, alu_Out : std_logic_vector(31 downto 0);
signal i_Ci, o_Co : std_logic;

begin

regfile : reg_file
  port map(i_CLK => i_CLK,
		i_RST => i_RST,
		i_WE => i_WE,
		i_WRITE_REG => i_rd,
		i_WRITE_DATA => alu_Out,
		i_READ_REG1 => i_rs,
		i_READ_REG2 => i_rt,
		o_READ_DATA1 => alu_A,
		o_READ_DATA2 => alu_B);

alu : nbitadder_sub_ALU
  port map(i_X0  => alu_A,
       i_X1  => alu_B,
       i_nAdd_Sub => i_addorsub,
       i_ALUSrc => i_ALUSrc,
       i_Imm => i_Imm,
       i_Ci  => i_Ci,
       o_Co  => o_Co,
       o_So  => alu_Out);

end structure;