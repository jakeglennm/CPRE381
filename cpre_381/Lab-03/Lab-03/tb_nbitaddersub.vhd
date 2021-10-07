library IEEE;
use IEEE.std_logic_1164.all;

entity tb_nbitaddersub is
 
end tb_nbitaddersub;

architecture structure of tb_nbitaddersub is 

component nbitadder_sub
generic(N : integer := 32);
   port(i_X0  : in std_logic_vector(N-1 downto 0);
       i_X1  : in std_logic_vector(N-1 downto 0);
       i_nAdd_Sub : in std_logic;
       i_Ci  : in std_logic;
       o_Co  : out std_logic;
       o_So  : out std_logic_vector(N-1 downto 0));
end component;

signal s_X0,s_X1, s_S1: std_logic_vector(31 downto 0);
signal s_AddorSub: std_logic;
signal s_Co,s_Ci: std_logic;

begin

adder1 : nbitadder_sub
port map(i_X0  => s_X0,
		i_X1  => s_X1,	
		i_nAdd_Sub  => s_AddorSub,
		i_Ci  => s_Ci,
		o_Co  => s_Co,		
		o_So  => s_S1);

process
  begin

    s_X1 <= "00000000000000000000010000000000";
    s_X0 <= "00000000000000000000000000000001";
    s_AddorSub <= '0';
    s_Ci <= '0';
    wait for 100 ns;

    s_X1 <= "00000000000000000000010000000000";
    s_X0 <= "00000000000000000000000000000001";
    s_AddorSub <= '1';
    s_Ci <= '1';
    wait for 100 ns;


  end process;


end structure;
