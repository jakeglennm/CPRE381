library IEEE;
use IEEE.std_logic_1164.all;

entity tb_dmem is
 generic(gCLK_HPER   : time := 50 ns);
end tb_dmem;

architecture structure of tb_dmem is

constant cCLK_PER  : time := gCLK_HPER * 2;

component mem
generic 
	(
		DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 10
	);

	port 
	(
		clk		: in std_logic;
		addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
		data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);
end component;

signal clock, write_enable : std_logic;
signal address :std_logic_vector(9 downto 0); 
signal s_data, s_q : std_logic_vector(31 downto 0);

begin

dmem : mem
port map(clk  => clock,
		  addr => address,
		data => s_data, 
  	        we  => write_enable,
		q => s_q);

P_CLK: process
  begin
    clock <= '0';
    wait for gCLK_HPER;
    clock <= '1';
    wait for gCLK_HPER;
  end process;

P_TB: process
  begin

-----------------------------
--read from memory, store it in prev_q, then 
    address <= "0000000000"; --read from first 10 values(address 0)
    s_data <= "00000000000000000000000000000000";
    write_enable   <= '0';
    wait for cCLK_PER;
    

    address <= "0100000000"; --write starting at 0x100
    s_data <= "00000000000000000000000000000001";
    write_enable   <= '1';
    wait for cCLK_PER;
-----------------------------
    address <= "0000000001"; --read from first 10 values(address 1)
    s_data <= "00000000000000000000000000000000";
    write_enable   <= '0';
    wait for cCLK_PER;

    address <= "0100000001"; --write to 0x101
    s_data <= "00000000000000000000000000000010";
    write_enable   <= '1';
    wait for cCLK_PER;
-----------------------------
    address <= "0000000010"; --read from first 10 values(address 2)
    s_data <= "00000000000000000000000000000000";
    write_enable   <= '0';
    wait for cCLK_PER;

    address <= "0100000010"; --write to 0x102
    s_data <= "11111111111111111111111111111101";
    write_enable   <= '1';
    wait for cCLK_PER;
-----------------------------
    address <= "0000000011"; --read from first 10 values(address 3)
    s_data <= "00000000000000000000000000000000";
    write_enable   <= '0';
    wait for cCLK_PER;

    address <= "0100000011"; --write to 0x103
    s_data <= "00000000000000000000000000000100";
    write_enable   <= '1';
    wait for cCLK_PER;
-----------------------------
    address <= "0000000100"; --read from first 10 values(address 4)
    s_data <= "00000000000000000000000000000000";
    write_enable   <= '0';
    wait for cCLK_PER;

    address <= "0100000100"; --write to 0x104
    s_data <= "11111111111111111111111111111011";
    write_enable   <= '1';
    wait for cCLK_PER;
-----------------------------
    address <= "0000000101"; --read from first 10 values(address 5)
    s_data <= "00000000000000000000000000000000";
    write_enable   <= '0';
    wait for cCLK_PER;

    address <= "0100000101"; --write to 0x105
    s_data <= "00000000000000000000000000000110";
    write_enable   <= '1';
    wait for cCLK_PER;
-----------------------------
    address <= "0000000110"; --read from first 10 values(address 6)
    s_data <= "00000000000000000000000000000000";
    write_enable   <= '0';
    wait for cCLK_PER;

    address <= "0100000110"; --write to 0x106
    s_data <= "11111111111111111111111111111001";
    write_enable   <= '1';
    wait for cCLK_PER;
-----------------------------
    address <= "0000000111"; --read from first 10 values(address 7)
    s_data <= "00000000000000000000000000000000";
    write_enable   <= '0';
    wait for cCLK_PER;

    address <= "0100000111"; --write to 0x107
    s_data <= "00000000000000000000000000001000";
    write_enable   <= '1';
    wait for cCLK_PER;
-----------------------------
    address <= "0000001000"; --read from first 10 values(address 8)
    s_data <= "00000000000000000000000000000000";
    write_enable   <= '0';
    wait for cCLK_PER;

    address <= "0100001000"; --write to 0x108
    s_data <= "11111111111111111111111111110111";
    write_enable   <= '1';
    wait for cCLK_PER;
-----------------------------
    address <= "0000001001"; --read from first 10 values(address 9)
    s_data <= "00000000000000000000000000000000";
    write_enable   <= '0';
    wait for cCLK_PER;

    address <= "0100001001"; --write to 0x109
    s_data <= "00000000000000000000000000001010";
    write_enable   <= '1';
    wait for cCLK_PER;
-----------------------------

  end process;

-- mem load -infile dmem.hex -format hex /tb_dmem/dmem/ram
end structure;