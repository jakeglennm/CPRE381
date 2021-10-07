library IEEE;
use IEEE.std_logic_1164.all;

entity EX_Memreg is
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

end EX_Memreg;

architecture structure of EX_Memreg is

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

i_data(72 downto 41) <= i_s_Read_Data2_EXMEM;
i_data(40 downto 9) <= i_s_ALUOut_EXMEM;
i_data(8 downto 4) <= i_rtorrd_EXMEM;
i_data(3) <= i_mem_load_EXMEM;
i_data(2) <= i_lui_EXMEM;
i_data(1) <= i_jal_EXMEM;
i_data(0) <= i_s_DMemWr_EXMEM;


EX_MEMreg : generic_reg
    port map(i_CLK  => i_CLK,
		  i_RST   => i_RST_EXMEM,
		  i_WE => i_WE_EXMEM,
  	          i_D  => i_data,
		  o_Q  => Q);

o_s_Read_Data2_EXMEM <= Q(72 downto 41);
o_s_ALUOut_EXMEM <= Q(40 downto 9);
o_rtorrd_EXMEM <= Q(8 downto 4);
o_mem_load_EXMEM <= Q(3);
o_lui_EXMEM <= Q(2);
o_jal_EXMEM <= Q(1);
o_s_DMemWr_EXMEM <= Q(0);
  
end structure;