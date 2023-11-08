library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity purelin is
	Generic ( N : integer := 32);
    Port ( x : in signed(N-1 downto 0);
           y : out signed(N-1 downto 0);
           clk : std_logic);
end purelin;

architecture Behavioral of purelin is

begin
process(clk)
begin
if (rising_edge(clk))then
    y <= x;
end if;
end process;
end Behavioral;
