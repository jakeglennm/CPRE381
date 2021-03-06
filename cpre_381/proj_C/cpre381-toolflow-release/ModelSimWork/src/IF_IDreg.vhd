library IEEE;
use IEEE.std_logic_1164.all;

entity IF_IDreg is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST_IFID        : in std_logic;     -- Reset inputs
       i_WE_IFID         : in std_logic;     -- Write enable input
       --inputs to IF/ID register
       i_PCplus4_IFID : in std_logic_vector(31 downto 0);
       i_s_Inst_IFID : in std_logic_vector(31 downto 0);
       --outputs to IF/ID register
       o_PCplus4_IFID : out std_logic_vector(31 downto 0);
       o_s_Inst_IFID : out std_logic_vector(31 downto 0));

end IF_IDreg;

architecture structure of IF_IDreg is

component generic_reg
  generic(N : integer := 64);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
end component;

signal i_data,Q : std_logic_vector(63 downto 0);

begin

i_data(63 downto 32) <= i_PCplus4_IFID;
i_data(31 downto 0) <= i_s_Inst_IFID;


IF_IDreg : generic_reg
    port map(i_CLK  => i_CLK,
		  i_RST   => i_RST_IFID,
		  i_WE => i_WE_IFID,
  	          i_D  => i_data,
		  o_Q  => Q);

o_PCplus4_IFID <= Q(63 downto 32);
o_s_Inst_IFID <= Q(31 downto 0);
  
end structure;