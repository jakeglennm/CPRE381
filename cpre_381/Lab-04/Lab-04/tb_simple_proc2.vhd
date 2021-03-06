library IEEE;
use IEEE.std_logic_1164.all;

entity tb_simple_proc2 is
  generic(gCLK_HPER   : time := 50 ns);
end tb_simple_proc2;

architecture behavior of tb_simple_proc2 is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component simp_mips_proc2
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
  end component;

  -- Temporary signals to connect to the components.
  signal s_CLK, s_RST, s_reg_we, s_ALUSrc, s_addorsub, s_mem_load, s_mem_store, s_signorzero  : std_logic;
  signal s_rd, s_rs, s_rt : std_logic_vector(4 downto 0);
signal s_Imm : std_logic_vector(15 downto 0);

begin

  DUT: simp_mips_proc2
  port map(i_CLK  => s_CLK,     
       i_RST  => s_RST,    
       i_reg_we  => s_reg_we,     
       i_rs  => s_rs,
       i_rd  => s_rd,
       i_rt  => s_rt,
       i_Immed  => s_Imm,
       i_ALUSrc  => s_ALUSrc,
       i_addorsub  => s_addorsub,
       i_mem_load => s_mem_load,
       i_mem_store => s_mem_store,
       i_signorzero => s_signorzero);

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
  -- mem load -infile dmem.hex -format hex /tb_simple_proc2/DUT/memory/ram
  P_TB: process
  begin
    -- 
    s_RST <= '1';
    s_reg_we  <= '0';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00000";
    s_Imm  <= "0000000000000000";
    s_rd <= "00000";
    s_rt <= "00000";
    s_ALUSrc <= '0';
    s_addorsub <= '0';
    s_signorzero <= '1';
    wait for cCLK_PER;

    -- addi $25, $0, 0
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00000";
    s_rt <= "00000";
    s_Imm  <= "0000000000000000";
    s_rd <= "11001";
    s_ALUSrc <= '1';
    s_addorsub <= '0';
    s_signorzero <= '1';
    wait for cCLK_PER;

    -- addi $26, $0, 256
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00000";
    s_rt <= "00000";
    s_Imm  <= "0000000100000000";
    s_rd <= "11010";
    s_ALUSrc <= '1';
    s_addorsub <= '0';
    s_signorzero <= '1';
    wait for cCLK_PER;

    -- lw $1, 0($25)
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '1';
    s_mem_store <= '0';   
    s_rs  <= "11001";
    s_rt <= "00000";
    s_Imm  <= "0000000000000000";
    s_rd <= "00001";
    s_ALUSrc <= '1';
    s_addorsub <= '0';
    s_signorzero <= '1';
    wait for cCLK_PER;

    -- lw $2, 4($25) # Load A[1] into $2
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '1';
    s_mem_store <= '0';   
    s_rs  <= "11001";
    s_rt <= "00000";
    s_Imm  <= "0000000000000100";
    s_rd <= "00010";
    s_ALUSrc <= '1';
    s_addorsub <= '0';
    s_signorzero <= '1';
    wait for cCLK_PER;

    -- add $1, $1, $2 # $1 = $1 + $2
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00001";
    s_rt <= "00010";
    s_Imm  <= "0000000000000100";
    s_rd <= "00001";
    s_ALUSrc <= '0';
    s_addorsub <= '0';
    s_signorzero <= '1';
    wait for cCLK_PER;
    
    -- sw $1, 0($26) # Store $1 into B[0]
    s_RST <= '0';
    s_reg_we  <= '0';  
    s_mem_load <= '0';
    s_mem_store <= '1';   
    s_rs  <= "11010";
    s_rt <= "00001";
    s_Imm  <= "0000000000000000";
    s_rd <= "00000";
    s_ALUSrc <= '1';
    s_addorsub <= '0';
    s_signorzero <= '1';
    wait for cCLK_PER;

    -- lw $2, 8($25) 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '1';
    s_mem_store <= '0';   
    s_rs  <= "11001";
    s_rt <= "00000";
    s_Imm  <= "0000000000001000";
    s_rd <= "00010";
    s_ALUSrc <= '1';
    s_addorsub <= '0';
    s_signorzero <= '1';
    wait for cCLK_PER;

    -- add $1, $1, $2 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00001";
    s_rt <= "00010";
    s_Imm  <= "0000000000001000";
    s_rd <= "00001";
    s_ALUSrc <= '0';
    s_addorsub <= '0';
    s_signorzero <= '1';
    wait for cCLK_PER;

    -- sw $1, 4($26) 
    s_RST <= '0';
    s_reg_we  <= '0';  
    s_mem_load <= '0';
    s_mem_store <= '1';   
    s_rs  <= "11010";
    s_rt <= "00001";
    s_Imm  <= "0000000000000100";
    s_rd <= "00000";
    s_ALUSrc <= '1';
    s_addorsub <= '0';
    s_signorzero <= '1';
    wait for cCLK_PER;

    -- lw $2, 12($25) 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '1';
    s_mem_store <= '0';   
    s_rs  <= "11001";
    s_rt <= "00000";
    s_Imm  <= "0000000000001100";
    s_rd <= "00010";
    s_ALUSrc <= '1';
    s_addorsub <= '0';
    s_signorzero <= '1';
    wait for cCLK_PER;

    -- add $1, $1, $2 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00001";
    s_rt <= "00010";
    s_Imm  <= "0000000000001000";
    s_rd <= "00001";
    s_ALUSrc <= '0';
    s_addorsub <= '0';
    s_signorzero <= '1';
    wait for cCLK_PER;

    -- sw $1, 8($26) 
    s_RST <= '0';
    s_reg_we  <= '0';  
    s_mem_load <= '0';
    s_mem_store <= '1';   
    s_rs  <= "11010";
    s_rt <= "00001";
    s_Imm  <= "0000000000001000";
    s_rd <= "00000";
    s_ALUSrc <= '1';
    s_addorsub <= '0';
    s_signorzero <= '1';
    wait for cCLK_PER;

    -- lw $2, 16($25) 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '1';
    s_mem_store <= '0';   
    s_rs  <= "11001";
    s_rt <= "00000";
    s_Imm  <= "0000000000010000";
    s_rd <= "00010";
    s_ALUSrc <= '1';
    s_addorsub <= '0';
    s_signorzero <= '1';
    wait for cCLK_PER;

    -- add $1, $1, $2 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00001";
    s_rt <= "00010";
    s_Imm  <= "0000000000001000";
    s_rd <= "00001";
    s_ALUSrc <= '0';
    s_addorsub <= '0';
    s_signorzero <= '1';
    wait for cCLK_PER;

    -- sw $1, 12($26) 
    s_RST <= '0';
    s_reg_we  <= '0';  
    s_mem_load <= '0';
    s_mem_store <= '1';   
    s_rs  <= "11010";
    s_rt <= "00001";
    s_Imm  <= "0000000000001100";
    s_rd <= "00000";
    s_ALUSrc <= '1';
    s_addorsub <= '0';
    s_signorzero <= '1';
    wait for cCLK_PER;

    -- lw $2, 20($25) 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '1';
    s_mem_store <= '0';   
    s_rs  <= "11001";
    s_rt <= "00000";
    s_Imm  <= "0000000000010100";
    s_rd <= "00010";
    s_ALUSrc <= '1';
    s_addorsub <= '0';
    s_signorzero <= '1';
    wait for cCLK_PER;

    -- add $1, $1, $2 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00001";
    s_rt <= "00010";
    s_Imm  <= "0000000000001000";
    s_rd <= "00001";
    s_ALUSrc <= '0';
    s_addorsub <= '0';
    s_signorzero <= '1';
    wait for cCLK_PER;

    -- sw $1, 16($26) 
    s_RST <= '0';
    s_reg_we  <= '0';  
    s_mem_load <= '0';
    s_mem_store <= '1';   
    s_rs  <= "11010";
    s_rt <= "00001";
    s_Imm  <= "0000000000010000";
    s_rd <= "00000";
    s_ALUSrc <= '1';
    s_addorsub <= '0';
    s_signorzero <= '1';
    wait for cCLK_PER;

    -- lw $2, 24($25) 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '1';
    s_mem_store <= '0';   
    s_rs  <= "11001";
    s_rt <= "00000";
    s_Imm  <= "0000000000011000";
    s_rd <= "00010";
    s_ALUSrc <= '1';
    s_addorsub <= '0';
    s_signorzero <= '1';
    wait for cCLK_PER;

    -- add $1, $1, $2 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00001";
    s_rt <= "00010";
    s_Imm  <= "0000000000001000";
    s_rd <= "00001";
    s_ALUSrc <= '0';
    s_addorsub <= '0';
    s_signorzero <= '1';
    wait for cCLK_PER;

    -- addi $27, $26, 512
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "11010";
    s_rt <= "00000";
    s_Imm  <= "0000001000000000";
    s_rd <= "11011";
    s_ALUSrc <= '1';
    s_addorsub <= '0';
    s_signorzero <= '1';
    wait for cCLK_PER;

    -- sw $1, -4($27) 
    s_RST <= '0';
    s_reg_we  <= '0';  
    s_mem_load <= '0';
    s_mem_store <= '1';   
    s_rs  <= "11011";
    s_rt <= "00001";
    s_Imm  <= "0000000000000100";
    s_rd <= "00000";
    s_ALUSrc <= '1';
    s_addorsub <= '1';
    s_signorzero <= '1';
    wait for cCLK_PER;
    
  wait;
  end process;

  
end behavior;