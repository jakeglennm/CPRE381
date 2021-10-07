library IEEE;
use IEEE.std_logic_1164.all;

entity tb_proja is
  generic(gCLK_HPER   : time := 50 ns);
end tb_proja;

architecture behavior of tb_proja is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component projA_proc
     port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset inputs
       i_reg_we     : in std_logic;     -- Write enable input(goes into decoder)
       i_mem_load   : in std_logic;     -- Control to load from memory
       i_mem_store  : in std_logic;     -- Control to store into memory
       i_reg_dest   : in std_logic;     -- use rd for r-format, rt for immediate types
       i_signorzero : in std_logic;     -- Control for sign extender unit
       i_rd : in std_logic_vector(4 downto 0);	-- Select line for decoder,output of decoder goes into corresponding register
       i_rs  : in std_logic_vector(4 downto 0); -- goes into first 32:1 mux select line
       i_rt  : in std_logic_vector(4 downto 0); -- goes into second 32:1 mux select line
       i_Control  : in std_logic_vector(3 downto 0); --4 bit value to choose which ALU operation
       i_Shamt : in std_logic_vector(4 downto 0); -- amount to shift
       i_LorR : in std_logic; --shift left or right
       i_LogOrAri : in std_logic; --shift logical or arithmetic
       i_shiftOrnot : in std_logic;--shift or not
       i_Immed : in std_logic_vector(15 downto 0); -- 16 bitimmediate
       i_ALUSrc : in std_logic); -- choose to use immediate or register data

  end component;

  -- Temporary signals to connect to the components.
  signal s_CLK, s_RST, s_reg_we, s_ALUSrc,s_mem_load, s_mem_store, s_signorzero,s_LorR,s_LogOrAri,s_shiftOrnot,s_reg_dest  : std_logic;
  signal s_rd, s_rs, s_rt, s_Shamt : std_logic_vector(4 downto 0);
  signal s_Imm : std_logic_vector(15 downto 0);
  signal alu_control : std_logic_vector(3 downto 0);

begin

  DUT: proja_proc
  port map(i_CLK  => s_CLK,     
       i_RST  => s_RST,    
       i_reg_we  => s_reg_we,     
       i_rs  => s_rs,
       i_rd  => s_rd,
       i_rt  => s_rt,
       i_reg_dest => s_reg_dest,
       i_Immed  => s_Imm,
       i_ALUSrc  => s_ALUSrc,
       i_mem_load => s_mem_load,
       i_mem_store => s_mem_store,
       i_Control => alu_control,
       i_Shamt => s_Shamt,
       i_LorR => s_LorR,
       i_LogOrAri => s_LogOrAri,
       i_shiftOrnot => s_shiftOrnot,
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
  -- after simulating and before adding a wave, enter the following line into transcript window
  -- mem load -infile dmem.hex -format hex /tb_proja/DUT/memory/ram
  -- in the memory list, the last 2 instances is what you want to open(1 is the reg file, the other is memory)
  P_TB: process
  begin
    -- 
    
    s_RST <= '1';
    s_reg_we  <= '0';  
    s_mem_load <= '0';
    s_mem_store <= '0';
    s_reg_dest <= '0';   
    s_rs  <= "00000";
    s_Imm  <= "0000000000000000";
    s_rd <= "00000";
    s_rt <= "00000";
    s_ALUSrc <= '0';
    alu_control <= "0000";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    s_signorzero <= '1';
    wait for cCLK_PER;

    -- addi $25, $0, 0
    s_reg_dest <= '0'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00000";
    s_rt <= "11001";
    s_Imm  <= "0000000000000000";
    s_rd <= "00000";
    s_ALUSrc <= '1';
    s_signorzero <= '1';
    alu_control <= "0000";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- addi $26, $0, 256
    s_reg_dest <= '0'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00000";
    s_rt <= "11010";
    s_Imm  <= "0000000100000000";
    s_rd <= "00000";
    s_ALUSrc <= '1';
    s_signorzero <= '1';
    alu_control <= "0000";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- lw $1, 8($25) #0xFFFFFFFD
    s_reg_dest <= '0'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '1';
    s_mem_store <= '0';   
    s_rs  <= "11001";
    s_rt <= "00001";
    s_Imm  <= "0000000000001000";
    s_rd <= "00000";
    s_ALUSrc <= '1';
    s_signorzero <= '1';
    alu_control <= "0000";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- lw $2, 4($25) # Load A[1] into $2, 0x2
    s_reg_dest <= '0'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '1';
    s_mem_store <= '0';   
    s_rs  <= "11001";
    s_rt <= "00010";
    s_Imm  <= "0000000000000100";
    s_rd <= "00000";
    s_ALUSrc <= '1';
    s_signorzero <= '1';
    alu_control <= "0000";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- add $1, $1, $2 # $1 = $1 + $2 = 0xFFFFFFFF
    s_reg_dest <= '1'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00001";
    s_rt <= "00010";
    s_Imm  <= "0000000000000100";
    s_rd <= "00001";
    s_ALUSrc <= '0';
    s_signorzero <= '1';
    alu_control <= "0000";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- add $1, $1, $2 # $1 = $1 + $2 = 0xFFFFFFFF + 2
    s_reg_dest <= '1'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00001";
    s_rt <= "00010";
    s_Imm  <= "0000000000000100";
    s_rd <= "00001";
    s_ALUSrc <= '0';
    s_signorzero <= '1';
    alu_control <= "0000";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;
    
    -- sw $1, 0($26) # Store $1 into B[0], 0x00000001
    s_reg_dest <= '0'; 
    s_RST <= '0';
    s_reg_we  <= '0';  
    s_mem_load <= '0';
    s_mem_store <= '1';   
    s_rs  <= "11010";
    s_rt <= "00001";
    s_Imm  <= "0000000000000000";
    s_rd <= "00000";
    s_ALUSrc <= '1';
    s_signorzero <= '1';
    alu_control <= "0000";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- sub $1, $0, $1 # 0x0 - 1
    s_reg_dest <= '1'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00000";
    s_rt <= "00001";
    s_Imm  <= "0000000000000000";
    s_rd <= "00001";
    s_ALUSrc <= '0';
    s_signorzero <= '1';
    alu_control <= "0001";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- sw $1, 0($26) # Store $1 into B[0], 0xFFFFFFFF
    s_reg_dest <= '0'; 
    s_RST <= '0';
    s_reg_we  <= '0';  
    s_mem_load <= '0';
    s_mem_store <= '1';   
    s_rs  <= "11010";
    s_rt <= "00001";
    s_Imm  <= "0000000000000000";
    s_rd <= "00000";
    s_ALUSrc <= '1';
    s_signorzero <= '1';
    alu_control <= "0000";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- addi $2, $0, 255
    s_reg_dest <= '0'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00000";
    s_rt <= "00010";
    s_Imm  <= "0000000011111111";
    s_rd <= "00000";
    s_ALUSrc <= '1';
    s_signorzero <= '1';
    alu_control <= "0000";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- sub $3, $1, $2 # 0xFFFFFFFF - 0xFF
    s_reg_dest <= '1'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00001";
    s_rt <= "00010";
    s_Imm  <= "0000000000000000";
    s_rd <= "00011";
    s_ALUSrc <= '0';
    s_signorzero <= '1';
    alu_control <= "0001";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- sw $3, 4($26) # Store $3 into B[1]
    s_reg_dest <= '0'; 
    s_RST <= '0';
    s_reg_we  <= '0';  
    s_mem_load <= '0';
    s_mem_store <= '1';   
    s_rs  <= "11010";
    s_rt <= "00011";
    s_Imm  <= "0000000000000100";
    s_rd <= "00000";
    s_ALUSrc <= '1';
    s_signorzero <= '1';
    alu_control <= "0000";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- addu $3, $3, $2 # 0XFFFFFF00 + 0X000000FF
    s_reg_dest <= '1'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00011";
    s_rt <= "00010";
    s_Imm  <= "0000000000000000";
    s_rd <= "00011";
    s_ALUSrc <= '0';
    s_signorzero <= '1';
    alu_control <= "0010";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- sw $3, 8($26) # Store $3 into B[2] 0xFFFFFFFF
    s_reg_dest <= '0'; 
    s_RST <= '0';
    s_reg_we  <= '0';  
    s_mem_load <= '0';
    s_mem_store <= '1';   
    s_rs  <= "11010";
    s_rt <= "00011";
    s_Imm  <= "0000000000001000";
    s_rd <= "00000";
    s_ALUSrc <= '1';
    s_signorzero <= '1';
    alu_control <= "0000";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- subu $4, $3, $2 # 0XFFFFFFFF - 0X000000FF
    s_reg_dest <= '1'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00011";
    s_rt <= "00010";
    s_Imm  <= "0000000000000000";
    s_rd <= "00100";
    s_ALUSrc <= '0';
    s_signorzero <= '1';
    alu_control <= "0011";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- sw $4, 12($26) # Store $3 into B[3], 0xFFFFFF00
    s_reg_dest <= '0'; 
    s_RST <= '0';
    s_reg_we  <= '0';  
    s_mem_load <= '0';
    s_mem_store <= '1';   
    s_rs  <= "11010";
    s_rt <= "00100";
    s_Imm  <= "0000000000001100";
    s_rd <= "00000";
    s_ALUSrc <= '1';
    s_signorzero <= '1';
    alu_control <= "0000";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- slt $31, $0(0x0), $2(0x000000FF) # should be 1
    s_reg_dest <= '1'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00000";
    s_rt <= "00010";
    s_Imm  <= "0000000000000000";
    s_rd <= "11111";
    s_ALUSrc <= '0';
    s_signorzero <= '1';
    alu_control <= "0100";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- slt $30, $2(0x000000FF), $0(0x0) # should be 0
    s_reg_dest <= '1'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00010";
    s_rt <= "00000";
    s_Imm  <= "0000000000000000";
    s_rd <= "11110";
    s_ALUSrc <= '0';
    s_signorzero <= '1';
    alu_control <= "0100";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- slt $29, $2(0x000000FF), $1(0xFFFFFFFF) # should be 0
    s_reg_dest <= '1'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00010";
    s_rt <= "00001";
    s_Imm  <= "0000000000000000";
    s_rd <= "11101";
    s_ALUSrc <= '0';
    s_signorzero <= '1';
    alu_control <= "0100";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- slt $28, $1(0xFFFFFFFF), $2(0x000000FF) # should be 1
    s_reg_dest <= '1'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00001";
    s_rt <= "00010";
    s_Imm  <= "0000000000000000";
    s_rd <= "11100";
    s_ALUSrc <= '0';
    s_signorzero <= '1';
    alu_control <= "0100";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- and $7, $2, $3 # should be 0x000000FF
    s_reg_dest <= '1'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00010";
    s_rt <= "00011";
    s_Imm  <= "0000000000000000";
    s_rd <= "00111";
    s_ALUSrc <= '0';
    s_signorzero <= '1';
    alu_control <= "0101";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- or $8, $2, $3 # should be 0xFFFFFFFF
    s_reg_dest <= '1'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00010";
    s_rt <= "00011";
    s_Imm  <= "0000000000000000";
    s_rd <= "01000";
    s_ALUSrc <= '0';
    s_signorzero <= '1';
    alu_control <= "0110";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- xor $9, $2, $3 # should be 0xFFFFFF00
    s_reg_dest <= '1'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00010";
    s_rt <= "00011";
    s_Imm  <= "0000000000000000";
    s_rd <= "01001";
    s_ALUSrc <= '0';
    s_signorzero <= '1';
    alu_control <= "0111";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- nand $10, $2, $3 # should be 0xFFFFFF00
    s_reg_dest <= '1'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00010";
    s_rt <= "00011";
    s_Imm  <= "0000000000000000";
    s_rd <= "01010";
    s_ALUSrc <= '0';
    s_signorzero <= '1';
    alu_control <= "1000";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- nor $11, $2, $3 # should be 0x00000000
    s_reg_dest <= '1'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00010";
    s_rt <= "00011";
    s_Imm  <= "0000000000000000";
    s_rd <= "01011";
    s_ALUSrc <= '0';
    s_signorzero <= '1';
    alu_control <= "1001";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- sll $3, 16 # shift left 16 bits
    s_reg_dest <= '1'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00000";
    s_rt <= "00011";
    s_Imm  <= "0000000000000000";
    s_rd <= "00011";
    s_ALUSrc <= '0';
    s_signorzero <= '1';
    alu_control <= "0000";
    s_Shamt <= "10000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '1';
    wait for cCLK_PER;

    -- sw $3, 20($26) # Store 0xFFFF0000
    s_reg_dest <= '0'; 
    s_RST <= '0';
    s_reg_we  <= '0';  
    s_mem_load <= '0';
    s_mem_store <= '1';   
    s_rs  <= "11010";
    s_rt <= "00011";
    s_Imm  <= "0000000000010100";
    s_rd <= "00000";
    s_ALUSrc <= '1';
    s_signorzero <= '1';
    alu_control <= "0000";
    s_Shamt <= "00100";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- sra $3, 16 # shift right 16 bits
    s_reg_dest <= '1'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00000";
    s_rt <= "00011";
    s_Imm  <= "0000000000000000";
    s_rd <= "00011";
    s_ALUSrc <= '0';
    s_signorzero <= '1';
    alu_control <= "0000";
    s_Shamt <= "10000";
    s_LorR <= '1';
    s_LogOrAri <= '1';
    s_shiftOrnot <= '1';
    wait for cCLK_PER;

    -- sw $3, 24($26) # Store 0xFFFFFFFF
    s_reg_dest <= '0'; 
    s_RST <= '0';
    s_reg_we  <= '0';  
    s_mem_load <= '0';
    s_mem_store <= '1';   
    s_rs  <= "11010";
    s_rt <= "00011";
    s_Imm  <= "0000000000011000";
    s_rd <= "00000";
    s_ALUSrc <= '1';
    s_signorzero <= '1';
    alu_control <= "0000";
    s_Shamt <= "00100";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- srl $3, 16 # shift right 16 bits
    s_reg_dest <= '1'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "00000";
    s_rt <= "00011";
    s_Imm  <= "0000000000000000";
    s_rd <= "00011";
    s_ALUSrc <= '0';
    s_signorzero <= '1';
    alu_control <= "0000";
    s_Shamt <= "10000";
    s_LorR <= '1';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '1';
    wait for cCLK_PER;

    -- sw $3, 28($26) # Store 0x0000FFFF
    s_reg_dest <= '0'; 
    s_RST <= '0';
    s_reg_we  <= '0';  
    s_mem_load <= '0';
    s_mem_store <= '1';   
    s_rs  <= "11010";
    s_rt <= "00011";
    s_Imm  <= "0000000000011100";
    s_rd <= "00000";
    s_ALUSrc <= '1';
    s_signorzero <= '1';
    alu_control <= "0000";
    s_Shamt <= "00100";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- lw $14, 32($25) #0x80000000
    s_reg_dest <= '0'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '1';
    s_mem_store <= '0';   
    s_rs  <= "11001";
    s_rt <= "01110";
    s_Imm  <= "0000000000100000";
    s_rd <= "00000";
    s_ALUSrc <= '1';
    s_signorzero <= '1';
    alu_control <= "0000";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- add $13, $14, $14 # 0x80000000 + 0x80000000 (should be overflow)
    s_reg_dest <= '1'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "01110";
    s_rt <= "01110";
    s_Imm  <= "0000000000000100";
    s_rd <= "01101";
    s_ALUSrc <= '0';
    s_signorzero <= '1';
    alu_control <= "0000";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- lw $14, 36($25) #0x7FFFFFFF
    s_reg_dest <= '0'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '1';
    s_mem_store <= '0';   
    s_rs  <= "11001";
    s_rt <= "01110";
    s_Imm  <= "0000000000100110";
    s_rd <= "00000";
    s_ALUSrc <= '1';
    s_signorzero <= '1';
    alu_control <= "0000";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;

    -- add $12, $14, $14 # 0x0x7FFFFFFF + 0x0x7FFFFFFF (should be overflow)
    s_reg_dest <= '1'; 
    s_RST <= '0';
    s_reg_we  <= '1';  
    s_mem_load <= '0';
    s_mem_store <= '0';   
    s_rs  <= "01110";
    s_rt <= "01110";
    s_Imm  <= "0000000000000100";
    s_rd <= "01100";
    s_ALUSrc <= '0';
    s_signorzero <= '1';
    alu_control <= "0000";
    s_Shamt <= "00000";
    s_LorR <= '0';
    s_LogOrAri <= '0';
    s_shiftOrnot <= '0';
    wait for cCLK_PER;





  wait;
  end process;

  
end behavior;