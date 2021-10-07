library IEEE;
use IEEE.std_logic_1164.all;

entity tb_nbitaddersubalu is
 
end tb_nbitaddersubalu;

architecture structure of tb_nbitaddersubalu is 

component nbitadder_sub_ALU
  port(i_X0  : in std_logic_vector(31 downto 0);
       i_X1  : in std_logic_vector(31 downto 0);
       i_nAdd_Sub : in std_logic;
       i_ALUSrc : in std_logic;
       i_Imm : std_logic_vector(31 downto 0);
       i_Ci  : in std_logic;
       o_Co  : out std_logic;
       o_So  : out std_logic_vector(31 downto 0));
end component;

signal s_X0,s_X1,s_Imm, s_S1: std_logic_vector(31 downto 0);
signal s_AddorSub,s_ALUSrc: std_logic;
signal s_Co,s_Ci: std_logic;

begin

adder1 : nbitadder_sub_ALU
port map(i_X0  => s_X0,
		i_X1  => s_X1,	
		i_nAdd_Sub  => s_AddorSub,
		i_ALUSrc => s_ALUSrc,
		i_Imm => s_Imm,
		i_Ci  => s_Ci,
		o_Co  => s_Co,		
		o_So  => s_S1);

process
  begin
-------------------------------------------------------
--test add and subtarct
    s_X0 <= "00000000000000000000010000000000";
    s_X1 <= "00000000000000000000000000000001";
    s_AddorSub <= '0';
    s_ALUSrc <= '0';
    s_Imm <= "00000000000000000000000000000011";
    s_Ci <= '0'; -- value doesn't matter
    wait for 100 ns;

    s_X0 <= "00000000000000000000010000000000";
    s_X1 <= "00000000000000000000000000000001";
    s_AddorSub <= '1';
    s_ALUSrc <= '0';
    s_Imm <= "00000000000000000000000000000011";
    s_Ci <= '0';
    wait for 100 ns;

---------------------------------------------------------
--test add and subtract with immediate
    s_X0 <= "00000000000000000000010000000000";
    s_X1 <= "00000000000000000000000000000001";
    s_AddorSub <= '0';
    s_ALUSrc <= '1';
    s_Imm <= "00000000000000000000000000000011";
    s_Ci <= '0'; -- value doesn't matter
    wait for 100 ns;

    s_X0 <= "00000000000000000000010000000000";
    s_X1 <= "00000000000000000000000000000001";
    s_AddorSub <= '1';
    s_ALUSrc <= '1';
    s_Imm <= "00000000000000000000000000000011";
    s_Ci <= '0';
    wait for 100 ns;

---------------------------------------------------------
--test add and subtract with immediate
    s_X0 <= "00000000000000000000000000000000";
    s_X1 <= "00000000000000000000000000000001";
    s_AddorSub <= '0';
    s_ALUSrc <= '1';
    s_Imm <= "01111111111111111111111111111111";
    s_Ci <= '0'; -- value doesn't matter
    wait for 100 ns;

    s_X0 <= "10000000000000000000000000000000";
    s_X1 <= "00000000000000000000000000000001";
    s_AddorSub <= '1';
    s_ALUSrc <= '1';
    s_Imm <= "01111111111111111111111111111111";
    s_Ci <= '0'; -- value doesn't matter
    wait for 100 ns;

---------------------------------------------------------

  end process;


end structure;