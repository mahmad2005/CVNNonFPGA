----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/23/2023 01:38:56 AM
-- Design Name: 
-- Module Name: reluAct - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use work.nn_package.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reluAct is
  Port ( x : in signed (N-1 downto 0);
       y : out signed (N-1 downto 0);
       CLK : in STD_LOGIC );
end reluAct;

architecture Behavioral of reluAct is
    constant reluConst : signed(N-1 downto 0) := (others => '0');
begin
    y <= (others => '0') when (x < reluConst) else x;

end Behavioral;
