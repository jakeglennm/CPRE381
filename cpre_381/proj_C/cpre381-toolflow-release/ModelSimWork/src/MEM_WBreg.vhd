library IEEE;
use IEEE.std_logic_1164.all;

entity MEM_WBreg is
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

end MEM_WBreg;

architecture structure of MEM_WBreg is

component generic_reg
  generic(N : integer := 73);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
end component;

signal i_data,Q : std_logic_vector(72 downto 0);

begin

i_data(71 downto 40) <= i_s_ALUOut_MEMWB;
i_data(39 downto 8) <= i_s_DMemOut_MEMWB;
i_data(7 downto 3) <= i_rtorrd_MEMWB;
i_data(2) <= i_mem_load_MEMWB;
i_data(1) <= i_lui_MEMWB;
i_data(0) <= i_jal_MEMWB;


MEM_WBeg : generic_reg
    port map(i_CLK  => i_CLK,
		  i_RST   => i_RST_MEMWB,
		  i_WE => i_WE_MEMWB,
  	          i_D  => i_data,
		  o_Q  => Q);

o_s_ALUOut_MEMWB <= Q(71 downto 40);
o_s_DMemOut_MEMWB <= Q(39 downto 8);
o_rtorrd_MEMWB <= Q(7 downto 3);
o_mem_load_MEMWB <= Q(2);
o_lui_MEMWB <= Q(1);
o_jal_MEMWB <= Q(0);
  
end structure;