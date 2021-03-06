library IEEE;
use IEEE.std_logic_1164.all;

entity ID_EXreg is
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

end ID_EXreg;

architecture structure of ID_EXreg is

component generic_reg
  generic(N : integer := 125);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
end component;

signal i_data,Q : std_logic_vector(124 downto 0);

begin

i_data(124 downto 120) <= i_s_Inst_10to6_IDEX; --added late
i_data(119 downto 88) <= i_Read_Data1_IDEX;
i_data(87 downto 56) <= i_Read_Data2_IDEX;
i_data(55 downto 24) <= i_immediate_IDEX;
i_data(23 downto 19) <= i_s_Inst_15to11_IDEX;
i_data(18 downto 14) <= i_s_Inst_20to16_IDEX;
i_data(13) <= i_mem_load_IDEX;
i_data(12) <= i_lui_IDEX;
i_data(11) <= i_jal_IDEX;
i_data(10) <= i_s_DMemWr_IDEX;
i_data(9) <= i_ALUSrc_IDEX;
i_data(8) <= i_reg_dst_IDEX;
i_data(7 downto 4) <= i_ALUControl_IDEX;
i_data(3) <= i_LorR_IDEX;
i_data(2) <= i_LogOrAri_IDEX;
i_data(1) <= i_shiftorNot_IDEX;
i_data(0) <= i_shift_variable_IDEX;



ID_EXreg : generic_reg
    port map(i_CLK  => i_CLK,
		  i_RST   => i_RST_IDEX,
		  i_WE => i_WE_IDEX,
  	          i_D  => i_data,
		  o_Q  => Q);

o_s_Inst_10to6_IDEX <= Q(124 downto 120);
o_Read_Data1_IDEX <= Q(119 downto 88);
o_Read_Data2_IDEX <= Q(87 downto 56);
o_immediate_IDEX <= Q(55 downto 24);
o_s_Inst_15to11_IDEX <= Q(23 downto 19);
o_s_Inst_20to16_IDEX <= Q(18 downto 14);
o_mem_load_IDEX <= Q(13);
o_lui_IDEX <= Q(12);
o_jal_IDEX <= Q(11);
o_s_DMemWr_IDEX <= Q(10);
o_ALUSrc_IDEX <= Q(9);
o_reg_dst_IDEX <= Q(8);
o_ALUControl_IDEX <= Q(7 downto 4);
o_LorR_IDEX <= Q(3);
o_LogOrAri_IDEX <= Q(2);
o_shiftorNot_IDEX <= Q(1);
o_shift_variable_IDEX <= Q(0);
  
end structure;