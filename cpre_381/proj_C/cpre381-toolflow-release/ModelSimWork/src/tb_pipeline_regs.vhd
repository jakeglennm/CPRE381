library IEEE;
use IEEE.std_logic_1164.all;

entity tb_pipeline_regs is
  generic(gCLK_HPER   : time := 50 ns);
end tb_pipeline_regs;

architecture behavior of tb_pipeline_regs is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component IF_IDreg
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST_IFID   : in std_logic;     -- Reset inputs
       i_WE_IFID    : in std_logic;     -- Write enable input
       --inputs to IF/ID register
       i_PCplus4_IFID : in std_logic_vector(31 downto 0);
       i_s_Inst_IFID : in std_logic_vector(31 downto 0);
       --outputs to IF/ID register
       o_PCplus4_IFID : out std_logic_vector(31 downto 0);
       o_s_Inst_IFID : out std_logic_vector(31 downto 0));
  end component;

  component ID_Exreg
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

  component EX_MEMreg
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
       i_RST_MEMWB     : in std_logic;     -- Reset inputs
       i_WE_MEMWB      : in std_logic;     -- Write enable input
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

  -- Temporary signals to connect to the components.
  signal s_CLK, s_RST_IFID,s_RST_IDEX,s_RST_EXMEM,s_RST_MEMWB, s_WE_IFID,s_WE_IDEX,s_WE_EXMEM,s_WE_MEMWB,s_i_mem_load_IDEX,s_o_mem_load_IDEX,s_i_lui_IDEX,s_o_lui_IDEX,s_i_jal_IDEX,s_o_jal_IDEX,s_i_DMemWr_IDEX,s_o_DMemWr_IDEX,s_i_ALUSrc_IDEX,s_o_ALUSrc_IDEX,s_i_reg_dst_IDEX,s_o_reg_dst_IDEX,s_i_LorR_IDEX,s_o_LorR_IDEX,s_i_LogOrAri_IDEX,s_o_LogOrAri_IDEX,s_i_shiftorNot_IDEX,s_o_shiftorNot_IDEX,s_i_shift_variable_IDEX,s_o_shift_variable_IDEX : std_logic;
  signal s_i_mem_load_EXMEM, s_o_mem_load_EXMEM, s_i_lui_EXMEM,s_o_lui_EXMEM,s_i_jal_EXMEM,s_o_jal_EXMEM,s_i_DMemWr_EXMEM,s_o_DMemWr_EXMEM,s_i_mem_load_MEMWB,s_o_mem_load_MEMWB,s_i_lui_MEMWB,s_o_lui_MEMWB,s_i_jal_MEMWB,s_o_jal_MEMWB : std_logic;
  signal s_i_ALUControl_IDEX,s_o_ALUControl_IDEX : std_logic_vector(3 downto 0);
  signal s_i_Inst_15to11_IDEX,s_o_Inst_15to11_IDEX,s_i_Inst_20to16_IDEX,s_o_Inst_20to16_IDEX, s_i_Inst_10to6_IDEX, s_o_Inst_10to6_IDEX,s_i_rtorrd_EXMEM,s_o_rtorrd_EXMEM,s_i_rtorrd_MEMWB,s_o_rtorrd_MEMWB: std_logic_vector(4 downto 0);
  signal s_i_PCplus4_IFID,s_o_PCplus4_IFID,s_i_Inst_IFID,s_o_Inst_IFID: std_logic_vector(31 downto 0); 
  signal s_i_Read_Data1_IDEX, s_o_Read_Data1_IDEX,s_i_Read_Data2_IDEX,s_o_Read_Data2_IDEX,s_i_immediate_IDEX,s_o_immediate_IDEX: std_logic_vector(31 downto 0);
  signal s_i_ALUOut_EXMEM,s_o_ALUOut_EXMEM,s_i_ALUOut_MEMWB,s_o_ALUOut_MEMWB,s_i_DMemOut_MEMWB,s_o_DMemOut_MEMWB,s_i_Read_Data2_EXMEM,s_o_Read_Data2_EXMEM : std_logic_vector(31 downto 0);
begin

  if_id: IF_IDreg
  port map(i_CLK => s_CLK,
       i_RST_IFID  => s_RST_IFID,
       i_WE_IFID   => s_WE_IFID,
       i_PCplus4_IFID => s_i_PCplus4_IFID,
       i_s_Inst_IFID => s_i_Inst_IFID,
       o_PCplus4_IFID => s_o_PCplus4_IFID,
       o_s_Inst_IFID => s_o_Inst_IFID);

s_i_Inst_10to6_IDEX <= s_o_Inst_IFID(10 downto 6);
s_i_Inst_15to11_IDEX <= s_o_Inst_IFID(15 downto 11);
s_i_Inst_20to16_IDEX <= s_o_Inst_IFID(20 downto 16);

  id_ex: ID_EXreg
  port map(i_CLK => s_CLK,
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

s_i_mem_load_EXMEM <= s_o_mem_load_IDEX;
s_i_lui_EXMEM <= s_o_lui_IDEX;
s_i_jal_EXMEM <= s_o_jal_IDEX;
s_i_DMemWr_EXMEM <= s_o_DMemWr_IDEX;
s_i_Read_Data2_EXMEM <= s_o_Read_Data2_IDEX;

  ex_mem: EX_MEMreg
  port map(i_CLK => s_CLK,
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

s_i_lui_MEMWB <= s_o_lui_EXMEM;
s_i_jal_MEMWB <= s_o_jal_EXMEM;
s_i_rtorrd_MEMWB <= s_o_rtorrd_EXMEM;
s_i_mem_load_MEMWB <= s_o_mem_load_EXMEM;
s_i_ALUOut_MEMWB <= s_o_ALUOut_EXMEM;

  mem_wb: MEM_WBreg
  port map(i_CLK => s_CLK,
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

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin

       -- Nothing should be written(Write enable is 0)
       s_RST_IFID <= '1';
       s_RST_IDEX <= '1';
       s_RST_EXMEM <= '1';
       s_RST_MEMWB <= '1';
       s_WE_IFID <= '0';
       s_WE_IDEX <= '0';
       s_WE_EXMEM <= '0';
       s_WE_MEMWB <= '0';
       s_i_PCplus4_IFID <= "00000000000000000000000000000000"; -- 32 bit address
       s_i_Inst_IFID  <= "00000000000000000000000000000000"; -- 32 bit instruction
       s_i_Read_Data1_IDEX <= "00000000000000000000000000000000"; -- 32 bit register data
       s_i_Read_Data2_IDEX <= "00000000000000000000000000000000"; -- 32 bit register data
       s_i_immediate_IDEX <= "00000000000000000000000000000000"; -- 32 bit imm
       s_i_mem_load_IDEX <= '0';
       s_i_lui_IDEX <= '0';
       s_i_jal_IDEX <= '0';
       s_i_DMemWr_IDEX <= '0';
       s_i_ALUSrc_IDEX <= '0';
       s_i_reg_dst_IDEX <= '0';
       s_i_ALUControl_IDEX <= "0000"; -- 4 bit alu control
       s_i_LorR_IDEX <= '0';  
       s_i_LogOrAri_IDEX <= '0';
       s_i_shiftorNot_IDEX <= '0';
       s_i_shift_variable_IDEX <= '0';
       s_i_ALUOut_EXMEM <= "00000000000000000000000000000000"; -- 32 bit alu out
       s_i_rtorrd_EXMEM <= "00000"; -- 5 bit address
       s_i_DMemOut_MEMWB <= "00000000000000000000000000000000"; -- 32 bit dmem out
       wait for cCLK_PER;

       s_RST_IFID <= '0';
       s_RST_IDEX <= '0';
       s_RST_EXMEM <= '0';
       s_RST_MEMWB <= '0';
       s_WE_IFID <= '1';
       s_WE_IDEX <= '1';
       s_WE_EXMEM <= '1';
       s_WE_MEMWB <= '1';
       s_i_PCplus4_IFID <= "11111111111111111111111111111111"; -- 32 bit address
       s_i_Inst_IFID  <= "11111111111111111111111111111111"; -- 32 bit instruction
       s_i_Read_Data1_IDEX <= "11111111111111111111111111111111"; -- 32 bit register data
       s_i_Read_Data2_IDEX <= "11111111111111111111111111111111"; -- 32 bit register data
       s_i_immediate_IDEX <= "11111111111111111111111111111111"; -- 32 bit imm
       s_i_mem_load_IDEX <= '1';
       s_i_lui_IDEX <= '1';
       s_i_jal_IDEX <= '1';
       s_i_DMemWr_IDEX <= '1';
       s_i_ALUSrc_IDEX <= '1';
       s_i_reg_dst_IDEX <= '1';
       s_i_ALUControl_IDEX <= "1111"; -- 4 bit alu control
       s_i_LorR_IDEX <= '1';  
       s_i_LogOrAri_IDEX <= '1';
       s_i_shiftorNot_IDEX <= '1';
       s_i_shift_variable_IDEX <= '1';
       s_i_ALUOut_EXMEM <= "11111111111111111111111111111111"; -- 32 bit alu out
       s_i_rtorrd_EXMEM <= "11111"; -- 5 bit address
       s_i_DMemOut_MEMWB <= "11111111111111111111111111111111"; -- 32 bit dmem out
       wait for cCLK_PER;

       s_RST_IFID <= '0';
       s_RST_IDEX <= '0';
       s_RST_EXMEM <= '0';
       s_RST_MEMWB <= '0';
       s_WE_IFID <= '1';
       s_WE_IDEX <= '1';
       s_WE_EXMEM <= '1';
       s_WE_MEMWB <= '1';
       s_i_PCplus4_IFID <= "00000000000000000000000000000000"; -- 32 bit address
       s_i_Inst_IFID  <= "00000000000000000000000000000000"; -- 32 bit instruction
       s_i_Read_Data1_IDEX <= "00000000000000000000000000000000"; -- 32 bit register data
       s_i_Read_Data2_IDEX <= "00000000000000000000000000000000"; -- 32 bit register data
       s_i_immediate_IDEX <= "00000000000000000000000000000000"; -- 32 bit imm
       s_i_mem_load_IDEX <= '0';
       s_i_lui_IDEX <= '0';
       s_i_jal_IDEX <= '0';
       s_i_DMemWr_IDEX <= '0';
       s_i_ALUSrc_IDEX <= '0';
       s_i_reg_dst_IDEX <= '0';
       s_i_ALUControl_IDEX <= "0000"; -- 4 bit alu control
       s_i_LorR_IDEX <= '0';  
       s_i_LogOrAri_IDEX <= '0';
       s_i_shiftorNot_IDEX <= '0';
       s_i_shift_variable_IDEX <= '0';
       s_i_ALUOut_EXMEM <= "00000000000000000000000000000000"; -- 32 bit alu out
       s_i_rtorrd_EXMEM <= "00000"; -- 5 bit address
       s_i_DMemOut_MEMWB <= "00000000000000000000000000000000"; -- 32 bit dmem out
       wait for cCLK_PER;

       s_RST_IFID <= '0';
       s_RST_IDEX <= '0';
       s_RST_EXMEM <= '0';
       s_RST_MEMWB <= '0';
       s_WE_IFID <= '1';
       s_WE_IDEX <= '1';
       s_WE_EXMEM <= '1';
       s_WE_MEMWB <= '1';
       s_i_PCplus4_IFID <= "00000000000000000000000000000000"; -- 32 bit address
       s_i_Inst_IFID  <= "00000000000000000000000000000000"; -- 32 bit instruction
       s_i_Read_Data1_IDEX <= "00000000000000000000000000000000"; -- 32 bit register data
       s_i_Read_Data2_IDEX <= "00000000000000000000000000000000"; -- 32 bit register data
       s_i_immediate_IDEX <= "00000000000000000000000000000000"; -- 32 bit imm
       s_i_mem_load_IDEX <= '0';
       s_i_lui_IDEX <= '0';
       s_i_jal_IDEX <= '0';
       s_i_DMemWr_IDEX <= '0';
       s_i_ALUSrc_IDEX <= '0';
       s_i_reg_dst_IDEX <= '0';
       s_i_ALUControl_IDEX <= "0000"; -- 4 bit alu control
       s_i_LorR_IDEX <= '0';  
       s_i_LogOrAri_IDEX <= '0';
       s_i_shiftorNot_IDEX <= '0';
       s_i_shift_variable_IDEX <= '0';
       s_i_ALUOut_EXMEM <= "00000000000000000000000000000000"; -- 32 bit alu out
       s_i_rtorrd_EXMEM <= "00000"; -- 5 bit address
       s_i_DMemOut_MEMWB <= "00000000000000000000000000000000"; -- 32 bit dmem out
       wait for cCLK_PER;

       s_RST_IFID <= '0';
       s_RST_IDEX <= '0';
       s_RST_EXMEM <= '0';
       s_RST_MEMWB <= '0';
       s_WE_IFID <= '1';
       s_WE_IDEX <= '1';
       s_WE_EXMEM <= '1';
       s_WE_MEMWB <= '1';
       s_i_PCplus4_IFID <= "00000000000000000000000000000000"; -- 32 bit address
       s_i_Inst_IFID  <= "00000000000000000000000000000000"; -- 32 bit instruction
       s_i_Read_Data1_IDEX <= "00000000000000000000000000000000"; -- 32 bit register data
       s_i_Read_Data2_IDEX <= "00000000000000000000000000000000"; -- 32 bit register data
       s_i_immediate_IDEX <= "00000000000000000000000000000000"; -- 32 bit imm
       s_i_mem_load_IDEX <= '0';
       s_i_lui_IDEX <= '0';
       s_i_jal_IDEX <= '0';
       s_i_DMemWr_IDEX <= '0';
       s_i_ALUSrc_IDEX <= '0';
       s_i_reg_dst_IDEX <= '0';
       s_i_ALUControl_IDEX <= "0000"; -- 4 bit alu control
       s_i_LorR_IDEX <= '0';  
       s_i_LogOrAri_IDEX <= '0';
       s_i_shiftorNot_IDEX <= '0';
       s_i_shift_variable_IDEX <= '0';
       s_i_ALUOut_EXMEM <= "00000000000000000000000000000000"; -- 32 bit alu out
       s_i_rtorrd_EXMEM <= "00000"; -- 5 bit address
       s_i_DMemOut_MEMWB <= "00000000000000000000000000000000"; -- 32 bit dmem out
       wait for cCLK_PER;

       s_RST_IFID <= '1';
       s_RST_IDEX <= '1';
       s_RST_EXMEM <= '1';
       s_RST_MEMWB <= '1';
       s_WE_IFID <= '0';
       s_WE_IDEX <= '0';
       s_WE_EXMEM <= '0';
       s_WE_MEMWB <= '0';
       s_i_PCplus4_IFID <= "00000000000000000000000000000000"; -- 32 bit address
       s_i_Inst_IFID  <= "00000000000000000000000000000000"; -- 32 bit instruction
       s_i_Read_Data1_IDEX <= "00000000000000000000000000000000"; -- 32 bit register data
       s_i_Read_Data2_IDEX <= "00000000000000000000000000000000"; -- 32 bit register data
       s_i_immediate_IDEX <= "00000000000000000000000000000000"; -- 32 bit imm
       s_i_mem_load_IDEX <= '0';
       s_i_lui_IDEX <= '0';
       s_i_jal_IDEX <= '0';
       s_i_DMemWr_IDEX <= '0';
       s_i_ALUSrc_IDEX <= '0';
       s_i_reg_dst_IDEX <= '0';
       s_i_ALUControl_IDEX <= "0000"; -- 4 bit alu control
       s_i_LorR_IDEX <= '0';  
       s_i_LogOrAri_IDEX <= '0';
       s_i_shiftorNot_IDEX <= '0';
       s_i_shift_variable_IDEX <= '0';
       s_i_ALUOut_EXMEM <= "00000000000000000000000000000000"; -- 32 bit alu out
       s_i_rtorrd_EXMEM <= "00000"; -- 5 bit address
       s_i_DMemOut_MEMWB <= "00000000000000000000000000000000"; -- 32 bit dmem out
       wait for cCLK_PER;

       s_RST_IFID <= '0';
       s_RST_IDEX <= '0';
       s_RST_EXMEM <= '0';
       s_RST_MEMWB <= '0';
       s_WE_IFID <= '1';
       s_WE_IDEX <= '1';
       s_WE_EXMEM <= '1';
       s_WE_MEMWB <= '1';
       s_i_PCplus4_IFID <= "11111111111111111111111111111111"; -- 32 bit address
       s_i_Inst_IFID  <= "11111111111111111111111111111111"; -- 32 bit instruction
       s_i_Read_Data1_IDEX <= "11111111111111111111111111111111"; -- 32 bit register data
       s_i_Read_Data2_IDEX <= "11111111111111111111111111111111"; -- 32 bit register data
       s_i_immediate_IDEX <= "11111111111111111111111111111111"; -- 32 bit imm
       s_i_mem_load_IDEX <= '0';
       s_i_lui_IDEX <= '0';
       s_i_jal_IDEX <= '0';
       s_i_DMemWr_IDEX <= '0';
       s_i_ALUSrc_IDEX <= '0';
       s_i_reg_dst_IDEX <= '0';
       s_i_ALUControl_IDEX <= "0000"; -- 4 bit alu control
       s_i_LorR_IDEX <= '0';  
       s_i_LogOrAri_IDEX <= '0';
       s_i_shiftorNot_IDEX <= '0';
       s_i_shift_variable_IDEX <= '0';
       s_i_ALUOut_EXMEM <= "00000000000000000000000000000000"; -- 32 bit alu out
       s_i_rtorrd_EXMEM <= "00000"; -- 5 bit address
       s_i_DMemOut_MEMWB <= "00000000000000000000000000000000"; -- 32 bit dmem out
       wait for cCLK_PER;

       s_RST_IFID <= '0';
       s_RST_IDEX <= '0';
       s_RST_EXMEM <= '0';
       s_RST_MEMWB <= '0';
       s_WE_IFID <= '1';
       s_WE_IDEX <= '1';
       s_WE_EXMEM <= '1';
       s_WE_MEMWB <= '1';
       s_i_PCplus4_IFID <= "00000000000000000000000000000000"; -- 32 bit address
       s_i_Inst_IFID  <= "00000000000000000000000000000000"; -- 32 bit instruction
       s_i_Read_Data1_IDEX <= "00000000000000000000000000000000"; -- 32 bit register data
       s_i_Read_Data2_IDEX <= "00000000000000000000000000000000"; -- 32 bit register data
       s_i_immediate_IDEX <= "00000000000000000000000000000000"; -- 32 bit imm
       s_i_mem_load_IDEX <= '1';
       s_i_lui_IDEX <= '1';
       s_i_jal_IDEX <= '1';
       s_i_DMemWr_IDEX <= '1';
       s_i_ALUSrc_IDEX <= '1';
       s_i_reg_dst_IDEX <= '1';
       s_i_ALUControl_IDEX <= "0000"; -- 4 bit alu control
       s_i_LorR_IDEX <= '0';  
       s_i_LogOrAri_IDEX <= '0';
       s_i_shiftorNot_IDEX <= '0';
       s_i_shift_variable_IDEX <= '0';
       s_i_ALUOut_EXMEM <= "00000000000000000000000000000000"; -- 32 bit alu out
       s_i_rtorrd_EXMEM <= "00000"; -- 5 bit address
       s_i_DMemOut_MEMWB <= "00000000000000000000000000000000"; -- 32 bit dmem out
       wait for cCLK_PER;

       s_RST_IFID <= '0';
       s_RST_IDEX <= '0';
       s_RST_EXMEM <= '0';
       s_RST_MEMWB <= '0';
       s_WE_IFID <= '1';
       s_WE_IDEX <= '1';
       s_WE_EXMEM <= '1';
       s_WE_MEMWB <= '1';
       s_i_PCplus4_IFID <= "00000000000000000000000000000000"; -- 32 bit address
       s_i_Inst_IFID  <= "00000000000000000000000000000000"; -- 32 bit instruction
       s_i_Read_Data1_IDEX <= "00000000000000000000000000000000"; -- 32 bit register data
       s_i_Read_Data2_IDEX <= "00000000000000000000000000000000"; -- 32 bit register data
       s_i_immediate_IDEX <= "00000000000000000000000000000000"; -- 32 bit imm
       s_i_mem_load_IDEX <= '0';
       s_i_lui_IDEX <= '0';
       s_i_jal_IDEX <= '0';
       s_i_DMemWr_IDEX <= '0';
       s_i_ALUSrc_IDEX <= '0';
       s_i_reg_dst_IDEX <= '0';
       s_i_ALUControl_IDEX <= "1111"; -- 4 bit alu control
       s_i_LorR_IDEX <= '1';  
       s_i_LogOrAri_IDEX <= '1';
       s_i_shiftorNot_IDEX <= '1';
       s_i_shift_variable_IDEX <= '1';
       s_i_ALUOut_EXMEM <= "00000000000000000000000000000000"; -- 32 bit alu out
       s_i_rtorrd_EXMEM <= "00000"; -- 5 bit address
       s_i_DMemOut_MEMWB <= "00000000000000000000000000000000"; -- 32 bit dmem out
       wait for cCLK_PER;

       s_RST_IFID <= '0';
       s_RST_IDEX <= '0';
       s_RST_EXMEM <= '0';
       s_RST_MEMWB <= '0';
       s_WE_IFID <= '1';
       s_WE_IDEX <= '1';
       s_WE_EXMEM <= '1';
       s_WE_MEMWB <= '1';
       s_i_PCplus4_IFID <= "10000000000000000000000000000000"; -- 32 bit address
       s_i_Inst_IFID  <= "10000000000000000000000000000000"; -- 32 bit instruction
       s_i_Read_Data1_IDEX <= "00000000000000000000000000000000"; -- 32 bit register data
       s_i_Read_Data2_IDEX <= "00000000000000000000000000000000"; -- 32 bit register data
       s_i_immediate_IDEX <= "00000000000000000000000000000000"; -- 32 bit imm
       s_i_mem_load_IDEX <= '0';
       s_i_lui_IDEX <= '0';
       s_i_jal_IDEX <= '0';
       s_i_DMemWr_IDEX <= '0';
       s_i_ALUSrc_IDEX <= '0';
       s_i_reg_dst_IDEX <= '0';
       s_i_ALUControl_IDEX <= "0000"; -- 4 bit alu control
       s_i_LorR_IDEX <= '0';  
       s_i_LogOrAri_IDEX <= '0';
       s_i_shiftorNot_IDEX <= '0';
       s_i_shift_variable_IDEX <= '0';
       s_i_ALUOut_EXMEM <= "00000000000000000000000000000000"; -- 32 bit alu out
       s_i_rtorrd_EXMEM <= "00000"; -- 5 bit address
       s_i_DMemOut_MEMWB <= "00000000000000000000000000000000"; -- 32 bit dmem out
       wait for cCLK_PER;

       s_RST_IFID <= '0';
       s_RST_IDEX <= '0';
       s_RST_EXMEM <= '0';
       s_RST_MEMWB <= '0';
       s_WE_IFID <= '1';
       s_WE_IDEX <= '1';
       s_WE_EXMEM <= '1';
       s_WE_MEMWB <= '1';
       s_i_PCplus4_IFID <= "00000000000000000000000000000001"; -- 32 bit address
       s_i_Inst_IFID  <= "00000000000000000000000000000001"; -- 32 bit instruction
       s_i_Read_Data1_IDEX <= "00000000000000000000000000000000"; -- 32 bit register data
       s_i_Read_Data2_IDEX <= "00000000000000000000000000000000"; -- 32 bit register data
       s_i_immediate_IDEX <= "00000000000000000000000000000000"; -- 32 bit imm
       s_i_mem_load_IDEX <= '0';
       s_i_lui_IDEX <= '0';
       s_i_jal_IDEX <= '0';
       s_i_DMemWr_IDEX <= '0';
       s_i_ALUSrc_IDEX <= '0';
       s_i_reg_dst_IDEX <= '0';
       s_i_ALUControl_IDEX <= "0000"; -- 4 bit alu control
       s_i_LorR_IDEX <= '0';  
       s_i_LogOrAri_IDEX <= '0';
       s_i_shiftorNot_IDEX <= '0';
       s_i_shift_variable_IDEX <= '0';
       s_i_ALUOut_EXMEM <= "00000000000000000000000000000000"; -- 32 bit alu out
       s_i_rtorrd_EXMEM <= "00000"; -- 5 bit address
       s_i_DMemOut_MEMWB <= "00000000000000000000000000000000"; -- 32 bit dmem out
       wait for cCLK_PER;

       s_RST_IFID <= '0';
       s_RST_IDEX <= '0';
       s_RST_EXMEM <= '0';
       s_RST_MEMWB <= '0';
       s_WE_IFID <= '1';
       s_WE_IDEX <= '1';
       s_WE_EXMEM <= '1';
       s_WE_MEMWB <= '1';
       s_i_PCplus4_IFID <= "00000000000000000000000000000000"; -- 32 bit address
       s_i_Inst_IFID  <= "00000000000000000000000000000000"; -- 32 bit instruction
       s_i_Read_Data1_IDEX <= "00000000000000000000000000000000"; -- 32 bit register data
       s_i_Read_Data2_IDEX <= "00000000000000000000000000000000"; -- 32 bit register data
       s_i_immediate_IDEX <= "00000000000000000000000000000000"; -- 32 bit imm
       s_i_mem_load_IDEX <= '0';
       s_i_lui_IDEX <= '0';
       s_i_jal_IDEX <= '0';
       s_i_DMemWr_IDEX <= '0';
       s_i_ALUSrc_IDEX <= '0';
       s_i_reg_dst_IDEX <= '0';
       s_i_ALUControl_IDEX <= "0000"; -- 4 bit alu control
       s_i_LorR_IDEX <= '0';  
       s_i_LogOrAri_IDEX <= '0';
       s_i_shiftorNot_IDEX <= '0';
       s_i_shift_variable_IDEX <= '0';
       s_i_ALUOut_EXMEM <= "00000000000000000000000000000000"; -- 32 bit alu out
       s_i_rtorrd_EXMEM <= "00000"; -- 5 bit address
       s_i_DMemOut_MEMWB <= "00000000000000000000000000000000"; -- 32 bit dmem out
       wait for cCLK_PER;

       s_RST_IFID <= '0';
       s_RST_IDEX <= '0';
       s_RST_EXMEM <= '0';
       s_RST_MEMWB <= '0';
       s_WE_IFID <= '1';
       s_WE_IDEX <= '1';
       s_WE_EXMEM <= '1';
       s_WE_MEMWB <= '1';
       s_i_PCplus4_IFID <= "00000000000000000000000000000000"; -- 32 bit address
       s_i_Inst_IFID  <= "00000000000000000000000000000000"; -- 32 bit instruction
       s_i_Read_Data1_IDEX <= "00000000000000000000000000000000"; -- 32 bit register data
       s_i_Read_Data2_IDEX <= "00000000000000000000000000000000"; -- 32 bit register data
       s_i_immediate_IDEX <= "00000000000000000000000000000000"; -- 32 bit imm
       s_i_mem_load_IDEX <= '0';
       s_i_lui_IDEX <= '0';
       s_i_jal_IDEX <= '0';
       s_i_DMemWr_IDEX <= '0';
       s_i_ALUSrc_IDEX <= '0';
       s_i_reg_dst_IDEX <= '0';
       s_i_ALUControl_IDEX <= "0000"; -- 4 bit alu control
       s_i_LorR_IDEX <= '0';  
       s_i_LogOrAri_IDEX <= '0';
       s_i_shiftorNot_IDEX <= '0';
       s_i_shift_variable_IDEX <= '0';
       s_i_ALUOut_EXMEM <= "00000000000000000000000000000000"; -- 32 bit alu out
       s_i_rtorrd_EXMEM <= "00000"; -- 5 bit address
       s_i_DMemOut_MEMWB <= "00000000000000000000000000000000"; -- 32 bit dmem out
       wait for cCLK_PER;
      

  wait;
  end process;

  
end behavior;