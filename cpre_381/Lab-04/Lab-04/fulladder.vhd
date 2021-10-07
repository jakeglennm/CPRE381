library IEEE;
use IEEE.std_logic_1164.all;

entity fulladder is
  port(i_X0  : in std_logic;
       i_X1  : in std_logic;
       i_Ci  : in std_logic;
       o_Co  : out std_logic;
       o_So  : out std_logic);

end fulladder;

architecture structure of fulladder is 

component andg2
   port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component org2
   port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component xorg2
   port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

  signal AxorB : std_logic;

  signal AandB : std_logic;

  signal AxorBandCi    : std_logic;

begin

gXor1 : xorg2
   port map(
	     i_A               => i_X0,
	     i_B	       => i_X1,
             o_F               => AxorB);

gXor2 : xorg2
   port map(
	     i_A               => i_Ci,
	     i_B	       => AxorB,
             o_F               => o_So);

gAnd1: andg2
    port map(
	     i_A               => i_X0,
	     i_B	       => i_X1,
             o_F               => AandB);

gAnd2: andg2
    port map(
	     i_A               => i_Ci,
	     i_B	       => AxorB,
             o_F               => AxorBandCi);

gOr: org2
    port map(
	     i_A               => AxorBandCi,
	     i_B	       => AandB,
             o_F               => o_Co);


end structure;