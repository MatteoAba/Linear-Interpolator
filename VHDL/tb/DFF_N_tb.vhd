library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity DFF_N_tb is
    end DFF_N_tb;

architecture rtl of DFF_N_tb is

    constant clk_period     : time := 100 ns;
    constant NBit    : positive := 16;

    component DFF_N
        generic (NBit : positive := 16);
        port (
            clk     : in std_logic;
            a_rst_n : in std_logic;
            en      : in std_logic;
            D       : in std_logic_vector(NBit - 1 downto 0);
            Q       : out std_logic_vector(NBit - 1 downto 0)
        );
    end component;

    signal clk          : std_logic := '0';
    signal d_ext        : std_logic_vector(NBit-1 downto 0) := (others => '0');
    signal q_ext        : std_logic_vector(NBit-1 downto 0) := (others => '0');
    signal rst_n_ext    : std_logic := '1';
    signal en_ext       : std_logic := '1';
    signal testing      : boolean := true;

    begin
        clk <= not clk after clk_period/2 when testing else '0';

        dut: DFF_N
        generic map (NBit => NBit        )
        port map(
            D           => d_ext,
            Q           => q_ext,
            a_rst_n     => rst_n_ext,
            en          => en_ext,
            clk         => clk
        );

        stimulus : process 
			begin
			d_ext 	    <= (others => '0');
			rst_n_ext 	<= '1';
			en_ext      <= '1';
			wait until rising_edge(clk);
			d_ext 	    <= x"0081";     -- 129
			en_ext      <= '0';
            wait until rising_edge(clk);
            en_ext      <= '1';
			wait until rising_edge(clk);
			d_ext 	    <= x"FFFF";     -- 65535
            wait until rising_edge(clk);
            rst_n_ext 	<= '0';
			wait for 500 ns;
			testing  <= false;
            
		end process;
end rtl;