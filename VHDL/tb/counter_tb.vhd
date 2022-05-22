library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity counter_tb is
    end counter_tb;

architecture rtl of counter_tb is

    constant clk_period     : time := 100 ns;
    constant NBit           : positive := 2;

    component Counter
        generic (NBit : positive := 2);
        port (
            clk     : in  std_logic;
            a_rst_n : in  std_logic;
            dout    : out std_logic_vector(NBit - 1 downto 0)
        );
    end component;

    signal clk              : std_logic := '0';
    signal a_rst_n_ext      : std_logic := '1';
    signal dout_ext         : std_logic_vector(NBit-1 downto 0) := (others => '0');
    signal testing          : boolean := true;

    begin
        clk <= not clk after clk_period/2 when testing else '0';

        dut: Counter
        generic map (NBit => NBit)
        port map(
            clk     => clk,
            a_rst_n => a_rst_n_ext,
            dout    => dout_ext
        );

        stimulus : process 
			begin
            a_rst_n_ext <= '1';
			wait for 500 ns;
			a_rst_n_ext <= '0';
            wait for 750 ns;
			a_rst_n_ext <= '1';
			wait for 5500 ns;
			testing  <= false;
		end process;
end rtl;