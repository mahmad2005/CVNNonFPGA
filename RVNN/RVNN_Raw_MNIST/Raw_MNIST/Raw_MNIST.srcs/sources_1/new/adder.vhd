library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.nn_package.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity adder is
    Port ( A : in signed (N-1 downto 0);
           B : in signed (N-1 downto 0);
           C : out signed (N-1 downto 0));
end adder;

architecture Behavioral of adder is
--    signal temp : signed(N-1 downto 0); 
begin

C <= A+B;

end Behavioral;