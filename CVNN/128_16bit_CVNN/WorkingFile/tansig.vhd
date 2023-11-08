library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_package.all;

entity tansig is
--	Generic ( N : integer := 32;
--			  F : integer := 18);
    Port ( x : in signed (N-1 downto 0);
           x_i : in signed (N-1 downto 0);
           y : out signed (N-1 downto 0);
           y_i : out signed (N-1 downto 0);
           CLK : in STD_LOGIC);
end tansig;

architecture Behavioral of tansig is
--	constant ONE : real := 2.0**F;
--    constant one_s : signed(N-1 downto 0) := to_signed(integer(1.0*ONE), N);
--    constant neg_one_s : signed(N-1 downto 0) := to_signed(integer(-1.0*ONE), N);
--    constant L : signed(N-1 downto 0) := to_signed(integer(2.0*ONE), N);
--    constant neg_L : signed(N-1 downto 0) := to_signed(integer(-2.0*ONE), N);
    
    
    
--    signal z1,z1_1,z_1 : signed(N-1 downto 0);
--    signal H: signed (2*N-1 downto 0);
--    signal neg : std_logic;
    
    constant reluConst : signed(N-1 downto 0) := (others => '0');
--    signal temp_real : signed(N-1 downto 0);
--    signal temp_imag : signed(N-1 downto 0);
begin
--process(CLK)
--begin
--if(rising_edge(CLK))then
--    z1_1 <= z1;
--    z_1 <= x;
--end if;
--end process;
--    neg <= x(N-1);
    
--    z1 <= one_s + shift_right(x, 2) when neg = '1' else
--          one_s - shift_right(x, 2);
    
--    H <= z_1*z1_1;

--    y <= one_s when z_1 > L else
--         neg_one_s when z_1 < neg_L else
--         H(N+F-1 downto F);
    
--    y <= (others => '0') when (x < reluConst or x_i < reluConst) else x;
--    y_i <= (others => '0') when (x < reluConst or x_i < reluConst) else x_i;

    y <= (others => '0') when (x < reluConst) else x;
    y_i <= (others => '0') when (x_i < reluConst) else x_i;
         
end Behavioral;


