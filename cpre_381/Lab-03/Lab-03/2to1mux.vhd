library IEEE;
use IEEE.std_logic_1164.all;

entity twoto1mux is
  port(i_X0  : in std_logic;
       i_X1  : in std_logic;
       i_Sel: in std_logic;
       o_Y  : out std_logic);

end twoto1mux;

architecture structure of twoto1mux is

component invg
   port(i_A          : in std_logic;
       o_F          : out std_logic);
end component;

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

  signal sNotS : std_logic;

  signal sX0andnotS : std_logic;

  signal sX1andS    : std_logic;
 
begin 
  
 gNot: invg
    port map(
	     i_A               => i_Sel,
             o_F               => sNotS);

 gAnd1: andg2
    port map(
	     i_A               => i_X0,
	     i_B	       => sNotS,
             o_F               => sX0andnotS);

 gAnd2: andg2
    port map(
	     i_A               => i_X1,
	     i_B	       => i_Sel,
             o_F               => sX1andS);

 gOr: org2
    port map(
	     i_A               => sX1andS,
	     i_B	       => sX0andnotS,
             o_F               => o_Y);


end structure;