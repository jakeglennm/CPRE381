library IEEE;
use IEEE.std_logic_1164.all;

entity twobitshifter is
  port(i_A1  : in std_logic_vector(31 downto 0);
       i_Shamt1: in std_logic;
       i_LorR: in std_logic; -- '0' is left
       i_LogOrAri: in std_logic; --'0' is logical
       o_Y1  : out std_logic_vector(31 downto 0));

end twobitshifter;

architecture structure of twobitshifter is

component twoto1mux
  port(i_X0  : in std_logic;
       i_X1  : in std_logic;
       i_Sel: in std_logic;
       o_Y  : out std_logic);
end component;

-- signals go here
signal inputs  : std_logic_vector(31 downto 0);
signal sign_bit : std_logic;
 
begin 

sign_bit <= i_A1(31);

proc: process (i_LorR,i_A1, i_LogOrAri,sign_bit,inputs)
	begin
	if (i_LorR = '0') then 
		if(i_LogOrAri = '0') then --shift left logical
			inputs(0) <= '0';
			inputs(1) <= '0';
			loop_1: for k in 2 to 31 loop
				inputs(k)<= i_A1(k-2);
			end loop;
		else --shift left arithmetic(same as logical)
			inputs(0) <= '0';
			inputs(1) <= '0';
			loop_2: for k in 2 to 31 loop
				inputs(k)<= i_A1(k-2);
			end loop;
			end if;
       else  --(i_LorR = '1')
		if(i_LogOrAri = '0') then --shift right logical
			loop_3: for k in 0 to 29 loop
				inputs(k)<= i_A1(k+2);
			end loop;
			inputs(30) <= '0';
			inputs(31) <= '0';
		else --shift right arithmetic
			inputs(30) <= sign_bit;
			inputs(31) <= sign_bit;
			loop_4: for k in 0 to 29 loop
				inputs(k)<= i_A1(k+2);
			end loop;
			
			end if;
	end if;
end process proc;

G1: for i in 0 to 31 generate 
  mux_i: twoto1mux
    port map(i_X0  => i_A1(i),
		  i_X1   => inputs(i),
		  i_Sel  => i_Shamt1,
  	          o_Y  => o_Y1(i));
end generate;

end structure;