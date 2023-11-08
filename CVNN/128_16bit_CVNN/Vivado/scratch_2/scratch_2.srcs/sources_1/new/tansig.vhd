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

    constant reluConst : signed(N-1 downto 0) := (others => '0');
begin

    y <= (others => '0') when (x < reluConst) else x;
    y_i <= (others => '0') when (x_i < reluConst) else x_i;
         
end Behavioral;


