library IEEE;
use IEEE.std_logic_1164.all;

entity nMuxStructural is
	generic(N : integer := 32);
	port(i_A : in std_logic_vector(N-1 downto 0);
		i_B : in std_logic_vector(N-1 downto 0);
		i_S : in std_logic;
		o_F : out std_logic_vector(N-1 downto 0));

end nMuxStructural;

architecture structure of nMuxStructural is

component invg
  port(i_A  : in std_logic;
       o_F  : out std_logic);
end component;

component org2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component andg2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

signal notS : std_logic_vector(N-1 downto 0);
signal i0andnotS : std_logic_vector(N-1 downto 0);
signal i1andS : std_logic_vector(N-1 downto 0);

begin
	
	G1: for i in 0 to N-1 generate
	inv_0: invg
		port map(i_S, notS(i));
		
	and_0: andg2
		port map(notS(i), i_A(i), i0andnotS(i));

	and_1: andg2
		port map(i_S,i_B(i),i1andS(i));

	or_0: org2
		port map(i0andnotS(i), i1andS(i), o_F(i));
	end generate;

end structure;
