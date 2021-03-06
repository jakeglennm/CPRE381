library IEEE;
use IEEE.std_logic_1164.all;

entity tb_simple_proc is
  generic(gCLK_HPER   : time := 50 ns);
end tb_simple_proc;

architecture behavior of tb_simple_proc is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component simp_mips_proc
    port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset inputs
       i_WE         : in std_logic;     -- Write enable input(goes into decoder)
       i_rd : in std_logic_vector(4 downto 0);	-- Select line for decoder,output of decoder goes into corresponding register
       i_rs  : in std_logic_vector(4 downto 0); -- goes into first 32:1 mux select line
       i_rt  : in std_logic_vector(4 downto 0); -- goes into second 32:1 mux select line
       i_Imm : in std_logic_vector(31 downto 0);
       i_ALUSrc : in std_logic;
       i_addorsub : in std_logic);
  end component;

  -- Temporary signals to connect to the components.
  signal s_CLK, s_RST, s_WE, s_ALUSrc, s_addorsub  : std_logic;
  signal s_rd, s_rs, s_rt : std_logic_vector(4 downto 0);
signal s_Imm : std_logic_vector(31 downto 0);

begin

  DUT: simp_mips_proc
  port map(i_CLK  => s_CLK,     
       i_RST  => s_RST,    
       i_WE  => s_WE,     
       i_rs  => s_rs,
       i_rd  => s_rd,
       i_rt  => s_rt,
       i_Imm  => s_Imm,
       i_ALUSrc  => s_ALUSrc,
       i_addorsub  => s_addorsub);

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
    s_RST <= '1';
    s_WE  <= '0';     
    s_rs  <= "00000";
    s_Imm  <= "00000000000000000000000000000000";
    s_rd <= "00000";
    s_rt <= "00000";
    s_ALUSrc <= '0';
    s_addorsub <= '0';
    wait for cCLK_PER;

-- write the immediate(1) to register 1
    s_RST <= '0';
    s_WE  <= '1';     
    s_rs  <= "00000";
    s_Imm  <= "00000000000000000000000000000001";
    s_rd <= "00001";
    s_rt <= "00000";
    s_ALUSrc <= '1';
    s_addorsub <= '0';
    wait for cCLK_PER;

-- write the immediate(2) to register 2
    s_RST <= '0';
    s_WE  <= '1';     
    s_rs  <= "00000";
    s_Imm  <= "00000000000000000000000000000010";
    s_rd <= "00010";
    s_rt <= "00000";
    s_ALUSrc <= '1';
    s_addorsub <= '0';
    wait for cCLK_PER;

-- write to register 11, reg 1 + reg 2 -> should be 3(0011)
    s_RST <= '0';
    s_WE  <= '1';     
    s_rs  <= "00001";
    s_Imm  <= "10000000000000000000000000000000";
    s_rd <= "01011";
    s_rt <= "00010";
    s_ALUSrc <= '0';
    s_addorsub <= '0';
    wait for cCLK_PER;

-- write to register 12, reg 2 - reg 1 -> should be 1(0001)
    s_RST <= '0';
    s_WE  <= '1';     
    s_rs  <= "00010";
    s_Imm  <= "10000000000000000000000000000000";
    s_rd <= "01100";
    s_rt <= "00001";
    s_ALUSrc <= '0';
    s_addorsub <= '1';
    wait for cCLK_PER;

    
    
  wait;
  end process;

  
end behavior;