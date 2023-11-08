library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_package.all;

-- Complex Multiplication
--(a + bi) * (c + di) = (ac - bd) + (ad + bc)i

entity mult_complex is
    Port ( a_real : in SIGNED (N-1 downto 0);
           a_imag : in SIGNED (N-1 downto 0);
           b_real : in SIGNED (N-1 downto 0);
           b_imag : in SIGNED (N-1 downto 0);
           c_real : out SIGNED (N-1 downto 0);
           c_imag : out SIGNED (N-1 downto 0)--;
           --clk : in std_logic
           );
end mult_complex;

architecture Behavioral of mult_complex is
    signal temp1: SIGNED (2*N-1 downto 0);
    signal temp2: SIGNED (2*N-1 downto 0);
	signal temp3: SIGNED (2*N-1 downto 0);
	
	signal temp4: SIGNED (2*N-1 downto 0);
    signal temp5: SIGNED (2*N-1 downto 0);
	signal temp6: SIGNED (2*N-1 downto 0);
begin
    
    
    temp1 <= a_real*b_real;
	temp2 <= a_imag * b_imag;
	temp3 <= temp1 - (temp2);
    c_real <= temp3(2*N-1-I downto F);
	
	
	temp4 <= a_imag*b_real;
	temp5 <= b_imag * a_real;
	temp6 <= temp4 + temp5;
    c_imag <= temp6(2*N-1-I downto F);
	

end Behavioral;