library IEEE;
use IEEE.std_logic_1164.all;

entity notOrg32 is

  port(i_A          : in std_logic_vector(31 downto 0);
       o_F          : out std_logic);

end notOrg32;

architecture dataflow of notOrg32 is

signal o_t,t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16, d0, d1 : std_logic;

begin

	t1 <= i_A(1) or i_A(0);
	t2 <= i_A(3) or i_A(2);
	t3 <= i_A(5) or i_A(4);
	t4 <= i_A(7) or i_A(6);
	t5 <= i_A(9) or i_A(8);
	t6 <= i_A(11) or i_A(10);
	t7 <= i_A(13) or i_A(12);
	t8 <= i_A(15) or i_A(14);
	t9 <= i_A(17) or i_A(16);
	t10 <= i_A(19) or i_A(18);
	t11 <= i_A(21) or i_A(20);
	t12 <= i_A(23) or i_A(22);
	t13 <= i_A(25) or i_A(24);
	t14 <= i_A(27) or i_A(26);
	t15 <= i_A(29) or i_A(28);
	t16 <= i_A(31) or i_A(30);
	
	d0 <= ((t1 or t2) or (t3 or t4)) or ((t5 or t6) or (t7 or t8));
	d1 <= ((t9 or t10) or (t11 or t12)) or ((t13 or t14) or (t15 or t16));
	o_t <= d0 or d1;
	o_F <= not o_t;
  
end dataflow;
