library IEEE;
use IEEE.std_logic_1164.all;

entity barrelshifter is
  port(i_A  : in std_logic_vector(31 downto 0);
       i_Shamt: in std_logic_vector(4 downto 0);
       i_LorR: in std_logic; -- '0' is left
       i_LogOrAri: in std_logic; --'0' is logical
       o_Y  : out std_logic_vector(31 downto 0));

end barrelshifter;

architecture structure of barrelshifter is

component onebitshifter
  port(i_A0  : in std_logic_vector(31 downto 0);
       i_Shamt0: in std_logic;
       i_LorR: in std_logic; -- '0' is left
       i_LogOrAri: in std_logic; --'0' is logical
       o_Y0  : out std_logic_vector(31 downto 0));
end component;

component twobitshifter
  port(i_A1  : in std_logic_vector(31 downto 0);
       i_Shamt1: in std_logic;
       i_LorR: in std_logic; -- '0' is left
       i_LogOrAri: in std_logic; --'0' is logical
       o_Y1  : out std_logic_vector(31 downto 0));
end component;

component fourbitshifter
  port(i_A2  : in std_logic_vector(31 downto 0);
       i_Shamt2: in std_logic;
       i_LorR: in std_logic; -- '0' is left
       i_LogOrAri: in std_logic; --'0' is logical
       o_Y2  : out std_logic_vector(31 downto 0));
end component;

component eightbitshifter
  port(i_A3  : in std_logic_vector(31 downto 0);
       i_Shamt3: in std_logic;
       i_LorR: in std_logic; -- '0' is left
       i_LogOrAri: in std_logic; --'0' is logical
       o_Y3  : out std_logic_vector(31 downto 0));
end component;

component sixteenbitshifter
  port(i_A4  : in std_logic_vector(31 downto 0);
       i_Shamt4: in std_logic;
       i_LorR: in std_logic; -- '0' is left
       i_LogOrAri: in std_logic; --'0' is logical
       o_Y4  : out std_logic_vector(31 downto 0));
end component;

-- signals go here
signal A,Y0,Y1,Y2,Y3  : std_logic_vector(31 downto 0);
 
begin 

A <= i_A;

shift_1: onebitshifter
    port map(i_A0  => A,
		  i_Shamt0   => i_Shamt(0),
		  i_LorR  => i_LorR,
		  i_LogOrAri => i_LogOrAri,
  	          o_Y0  => Y0);

shift_2: twobitshifter
    port map(i_A1  => Y0,
		  i_Shamt1   => i_Shamt(1),
		  i_LorR  => i_LorR,
		  i_LogOrAri => i_LogOrAri,
  	          o_Y1  => Y1);

shift_3: fourbitshifter
    port map(i_A2  => Y1,
		  i_Shamt2   => i_Shamt(2),
		  i_LorR  => i_LorR,
		  i_LogOrAri => i_LogOrAri,
  	          o_Y2  => Y2);

shift_4: eightbitshifter
    port map(i_A3  => Y2,
		  i_Shamt3   => i_Shamt(3),
		  i_LorR  => i_LorR,
		  i_LogOrAri => i_LogOrAri,
  	          o_Y3  => Y3);

shift_5: sixteenbitshifter
    port map(i_A4  => Y3,
		  i_Shamt4   => i_Shamt(4),
		  i_LorR  => i_LorR,
		  i_LogOrAri => i_LogOrAri,
  	          o_Y4  => o_Y);


end structure;