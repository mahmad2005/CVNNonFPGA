----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/23/2023 01:50:00 AM
-- Design Name: 
-- Module Name: n_output - Behavioral
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

entity n_output is
  Port ( 
        clk : in std_logic;
        x, w : in a_array;
        bi : in signed(N-1 downto 0);
        sum_out : out signed(N-1 downto 0));
end n_output;

architecture Behavioral of n_output is

    component mult is
        port ( a : in SIGNED (N-1 downto 0);
               b : in SIGNED (N-1 downto 0);
               c : out SIGNED (N-1 downto 0)--;
               --clk : in std_logic
               );
    end component;
    
    component adder
        port (
            A : in signed(N-1 downto 0);
            B : in signed(N-1 downto 0);
            C : out signed(N-1 downto 0)
        );
    end component;
    
    constant Stage_1 : integer := 10;
    constant Stage_2 : integer := 5;
    constant Stage_3 : integer := 2;
    
    type a_array_Stage_1 is array(0 to Stage_1-1) of signed(N-1 downto 0); -- Array of hidden activation function 
    type a_array_Stage_2 is array(0 to Stage_2-1) of signed(N-1 downto 0);
    type a_array_Stage_3 is array(0 to Stage_3-1) of signed(N-1 downto 0);
    
    signal mult_sum_1 : a_array_Stage_1;
    signal mult_sum_2 : a_array_Stage_2;
    signal mult_sum_3 : a_array_Stage_3;
    
    signal sum_r_1, sum_r_2, sum_r_3 : signed(N-1 downto 0);
    
    signal mult_array : a_array;
    signal sum : signed(N-1 downto 0);
    signal bi_1 : signed(N-1 downto 0);

begin

process(clk)
begin
    if (rising_edge(clk))then
        sum <= sum_r_3;
        bi_1<=bi;
        
     end if;
end process;

	multgen : for i in 0 to NUM_L1-1 generate
    begin
        mult_unit: mult
        port map (
                    --clk=>clk,
                    a=>x(i),
                    b=>w(i), 
                    c=>mult_array(i)
                  );
    end generate;
    
    -- XW summation per batch
    addergen_1 : for i in 0 to Stage_1-1 generate
        begin               
             mult_sum_1(i) <= mult_array(2*i)+ mult_array(2*i+1);        
    end generate;
    
    addergen_2 : for i in 0 to Stage_2-1 generate
        begin               
             mult_sum_2(i) <= mult_sum_1(2*i)+ mult_sum_1(2*i+1);        
    end generate;
    
    addergen_3 : for i in 0 to Stage_3-1 generate
        begin               
             mult_sum_3(i) <= mult_sum_2(2*i)+ mult_sum_2(2*i+1);        
    end generate;
    
    sum_r_1 <= mult_sum_3(0)+mult_sum_3(1);
    sum_r_2 <= sum_r_1+mult_sum_2(4);
    sum_r_3 <= sum_r_2+bi;
    
    sum_out <= resize(sum, N);

end Behavioral;