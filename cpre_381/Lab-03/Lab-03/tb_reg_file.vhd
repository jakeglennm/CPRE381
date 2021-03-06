library IEEE;
use IEEE.std_logic_1164.all;

entity tb_reg_file is
  generic(gCLK_HPER   : time := 50 ns);
end tb_reg_file;

architecture behavior of tb_reg_file is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


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

  -- Temporary signals to connect to the components.
  signal s_CLK, s_RST, s_WE  : std_logic;
  signal s_WRITE_REG, s_READ_REG1, s_READ_REG2: std_logic_vector(4 downto 0);
signal s_WRITE_DATA, s_READ_DATA1, s_READ_DATA2 : std_logic_vector(31 downto 0);

begin

  DUT: reg_file
  port map(i_CLK  => s_CLK,     
       i_RST  => s_RST,    
       i_WE  => s_WE,     
       i_WRITE_REG  => s_WRITE_REG,
       i_WRITE_DATA  => s_WRITE_DATA,
       i_READ_REG1  => s_READ_REG1,
       i_READ_REG2  => s_READ_REG2,
       o_READ_DATA1  => s_READ_DATA1,
       o_READ_DATA2  => s_READ_DATA2);

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
    s_WRITE_REG  <= "00100";
    s_WRITE_DATA  <= "01000000000000000000000000000000";
    s_READ_REG1  <= "10000";
    s_READ_REG2  <= "00100";
    wait for cCLK_PER;

    -- Write 0x40000000 to register 4
    s_RST <= '0';
    s_WE  <= '1';     
    s_WRITE_REG  <= "00100";
    s_WRITE_DATA  <= "01000000000000000000000000000000";
    s_READ_REG1  <= "00000";
    s_READ_REG2  <= "00100";
    wait for cCLK_PER;  

    -- Write 0x15000000 to register 15
    s_RST <= '0';
    s_WE  <= '1';     
    s_WRITE_REG  <= "01111";
    s_WRITE_DATA  <= "00010101000000000000000000000000";
    s_READ_REG1  <= "00100";
    s_READ_REG2  <= "01111";
    wait for cCLK_PER;

-- Write 0x20000000 to register 2
    s_RST <= '0';
    s_WE  <= '1';     
    s_WRITE_REG  <= "00010";
    s_WRITE_DATA  <= "00100000000000000000000000000000";
    s_READ_REG1  <= "00000";
    s_READ_REG2  <= "00010";
    wait for cCLK_PER; 

-- Write 0x30000000 to register 0(Shouldn't change it)
    s_RST <= '0';
    s_WE  <= '1';     
    s_WRITE_REG  <= "00000";
    s_WRITE_DATA  <= "00110000000000000000000000000000";
    s_READ_REG1  <= "00000";
    s_READ_REG2  <= "00010";
    wait for cCLK_PER; 

-- Reset(both read registers should be 0)
    s_RST <= '1';
    s_WE  <= '0';     
    s_WRITE_REG  <= "00000";
    s_WRITE_DATA  <= "00000000000000000000000000000000";
    s_READ_REG1  <= "01111";
    s_READ_REG2  <= "00010";
    wait for cCLK_PER;
    
  wait;
  end process;

  
end behavior;