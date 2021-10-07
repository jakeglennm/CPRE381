library IEEE;
use IEEE.std_logic_1164.all;


entity Einstein is

  port(iCLK             : in std_logic;
       iM 		            : in integer;
       oE 		            : out integer);

end Einstein;

architecture structure of Einstein is
  
  -- Describe the component entities as defined in Adder.vhd 
  -- and Multiplier.vhd (not strictly necessary).
  component Adder
    port(iCLK           : in std_logic;
         iA             : in integer;
         iB             : in integer;
         oC             : out integer);
  end component;

  component Multiplier
    port(iCLK           : in std_logic;
         iA             : in integer;
         iB             : in integer;
         oC             : out integer);
  end component;

  -- Arbitrary constants for the c
  constant cA : integer := 9487;

  -- Signals to store c^2
  signal sVALUE_cC : integer;
 

begin

  
  ---------------------------------------------------------------------------
  -- Calculate c^2 then m * c^2
  ---------------------------------------------------------------------------
  g_Mult1: Multiplier
    port MAP(iCLK             => iCLK,
             iA               => cA,
             iB               => cA,
             oC               => sVALUE_cC);

  g_Mult2: Multiplier
    port MAP(iCLK             => iCLK,
             iA               => sVALUE_cC,
             iB               => iM,
             oC               => oE);
      
end structure;