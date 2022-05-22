library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity LinearInterpolator_tb is
    end LinearInterpolator_tb;

architecture rtl of LinearInterpolator_tb is

    constant clk_period     : time := 100 ns;
    constant NBit           : positive := 16;

    component LinearInterpolator
        generic (NBit : positive := 16);
        port (
            clk         : in  std_logic;
            a_rst_n     : in  std_logic;
            signal_in   : in  std_logic_vector(NBit - 1 downto 0);
            signal_out  : out std_logic_vector(NBit - 1 downto 0)
        );
    end component;

    signal clk              : std_logic := '1';
    signal a_rst_n_ext      : std_logic := '0';
    signal sig_ext          : std_logic_vector(NBit-1 downto 0) :=  x"0000";
    signal res_ext          : std_logic_vector(NBit-1 downto 0);
    signal testing          : boolean := true;

    begin
        clk <= not clk after clk_period/2 when testing else '0';

        dut: LinearInterpolator
            generic map (NBit => NBit)
            port map(
                clk         => clk,
                a_rst_n     => a_rst_n_ext,
                signal_in   => sig_ext,
                signal_out  => res_ext
            );

        stimulus : process 
			begin
            wait for 150 ns;
			a_rst_n_ext <= '1';
            wait for 250 ns;    -- 73
            sig_ext     <= x"0049";
            wait for 400 ns;    -- 88
            sig_ext     <= x"0058";
            wait for 400 ns;    -- 46
            sig_ext     <= x"002E";
            wait for 400 ns;    -- 89
            sig_ext     <= x"0059";
            wait for 400 ns;    -- 93
            sig_ext     <= x"005D";
			wait for 400 ns;    -- 30
            sig_ext     <= x"001E";
			wait for 400 ns;    -- 67
            sig_ext     <= x"0043";
			wait for 400 ns;    -- 55
            sig_ext     <= x"0037";
			wait for 400 ns;    -- 82
            sig_ext     <= x"0052";
			wait for 400 ns;    -- 41
            sig_ext     <= x"0029";
			wait for 400 ns;    -- 41
            sig_ext     <= x"0029";
			wait for 400 ns;    -- 65535
            sig_ext     <= x"FFFF";
			wait for 400 ns;    -- 65535
            sig_ext     <= x"FFFF";
			wait for 500 ns;
			testing  <= false;
		end process;
end rtl;