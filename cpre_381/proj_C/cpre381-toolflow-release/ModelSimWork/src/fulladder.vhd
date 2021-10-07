library IEEE;
use IEEE.std_logic_1164.all;

entity fullAdder is
    port(i_A : in std_logic;
       i_B : in std_logic;
	   i_C : in std_logic;
       o_S : out std_logic;
	   o_C : out std_logic);

end fullAdder;

architecture structure of fullAdder is

component xorg2
	port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
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

signal AandB : std_logic;
signal CandA : std_logic;
signal CandB : std_logic;
signal CxorB : std_logic;
signal Oror : std_logic;


begin

xorg_0: xorg2
	port map(i_A => i_B,
			i_B => i_C,
			o_F => CxorB);

xorg_1: xorg2
	port map(i_A => i_A,
			i_B => CxorB,
			o_F => o_S);
	
and_0: andg2
	port map(i_A => i_B,
			i_B => i_A,
			o_F => AandB);

and_1: andg2
	port map(i_A => i_A,
			i_B => i_C,
			o_F => CandA);
			
and_2: andg2
	port map(i_A => i_C,
			i_B => i_B,
			o_F => CandB);

or_0: org2
	port map(i_A => AandB,
			i_B => CandA,
			o_F => Oror);

or_1: org2
	port map(i_A => CandB,
			i_B => Oror,
			o_F => o_C);

end structure;
