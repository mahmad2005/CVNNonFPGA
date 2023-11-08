library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_package.all;

entity nn_tb is
--  Port ( );
end nn_tb;

architecture Behavioral of nn_tb is
component nn is
    Port ( 
        clk: in std_logic;
        x_in: in batch_x_array;
        x_in_imag: in batch_x_array;
        y_out: out y_array;
        y_out_imag: out y_array);
end component;

component mult is
    Port ( a : in SIGNED (N-1 downto 0);
           b : in SIGNED (N-1 downto 0);
           c : out SIGNED (N-1 downto 0)--;
           --clk : in std_logic
           );
end component;

--component MaxIndexFinder is
--    port (
--            magnitude : in  y_array;  -- Input magnitude array
--            max_index : out integer range 0 to NUM_Y-1
--        );
--end component;

 --type mag_array is array(0 to NUM_Y-1) of signed(N-1 downto 0);
 signal magnitude_r : y_array;
 signal magnitude_i : y_array;
 signal magnitude : y_array;

signal clk : std_logic;
signal x : batch_x_array;
signal x_imag : batch_x_array;
signal y : y_array;
signal y_imag : y_array;

signal max_index : integer range 0 to NUM_Y-1;

begin

--    InputGen: for i in 0 to 128-1 generate
--    begin
--        x(i)<= to_signed(integer(input_1(i)*ONE),N);
--        x_imag(i)<= to_signed(integer(input_1_i(i)*ONE),N);
--    end generate;

process
begin
    for j in 0 to NUMBER_OF_BATCH-1 loop
        for i in 0 to BATCH_SIZE-1 loop
            x(i)<= to_signed(integer(input_1(i+j*BATCH_SIZE)*ONE),N);
            x_imag(i)<= to_signed(integer(input_1_i(i+j*BATCH_SIZE)*ONE),N);
        end loop;
    wait for 20ns;
    end loop;
end process;

process
begin
clk <= '0';
wait for 10ns;
clk <= '1';
wait for 10ns;
end process;

--process
--begin
--for i in 0 to 127 loop
--	x(i)<= to_signed(integer(input_1(i)*ONE),N);
----	x(1)<= to_signed(integer(input_2(i)*ONE),N);
----	x(2)<= to_signed(integer(input_3(i)*ONE),N);
	
--	x_imag(i)<= to_signed(integer(input_1_i(i)*ONE),N);
----	x_imag(1)<= to_signed(integer(input_2_i(i)*ONE),N);
----	x_imag(2)<= to_signed(integer(input_3_i(i)*ONE),N);
--	wait for 20ns;
--	end loop;
--end process;

NN_unit: nn
    port map (clk=>clk, x_in => x, x_in_imag => x_imag, y_out => y, y_out_imag => y_imag);


multgen : for i in 0 to NUM_Y-1 generate
    mult_unit_real: mult
        port map (a => y(i),
                  b => y(i),
                  c => magnitude_r(i)
                  );
    mult_unit_imag: mult
    port map (a => y_imag(i),
              b => y_imag(i),
              c => magnitude_i(i)
              );
   end generate;

addgen : for i in 0 to NUM_Y-1 generate
    magnitude(i) <= magnitude_r(i) + magnitude_i(i);
    end generate;     

--maxfind : MaxIndexFinder
--    port map (magnitude => magnitude , max_index =>max_index);

end Behavioral;
