library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

---------------------------------------------------------
-- Entity
---------------------------------------------------------

entity DFF_N is
    generic (NBit : positive := 16);
    port (
        clk     : in  std_logic;
		a_rst_n : in  std_logic;
		en      : in  std_logic;
    	D       : in  std_logic_vector(NBit - 1 downto 0);
		Q       : out std_logic_vector(NBit - 1 downto 0)
    );
end DFF_N;

---------------------------------------------------------
-- Architecture
---------------------------------------------------------

architecture rtl of DFF_N is

begin
    -- flip-flop sequential logic, asyncronous reset
    DDF_N_PROC: process(clk, a_rst_n)
        begin
            if(a_rst_n = '0') then
                Q <= (others => '0');
            elsif(rising_edge(clk)) then
                if(en = '1') then
                    Q <= D;
                end if;
            end if;
        end process;
end rtl;