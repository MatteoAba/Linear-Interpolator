library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity RippleCarryAdder_tb is
    end RippleCarryAdder_tb;

architecture rtl of RippleCarryAdder_tb is

    constant clk_period     : time := 100 ns;
    constant NBit    : positive := 16;

    component RippleCarryAdder
        generic (NBit : positive := 16        );
        port (
            A    : in  std_logic_vector(NBit - 1 downto 0);
            B    : in  std_logic_vector(NBit - 1 downto 0);
            Cin  : in  std_logic;
            S    : out std_logic_vector(NBit - 1 downto 0);
            Cout : out std_logic
        );
    end component;

    signal clk          : std_logic := '0';
    signal a_ext        : std_logic_vector(NBit-1 downto 0) := (others => '0');
    signal b_ext        : std_logic_vector(NBit-1 downto 0) := (others => '0');
    signal c_in_ext     : std_logic := '0';
    signal s_ext        : std_logic_vector(NBit-1 downto 0);
    signal c_out_ext    : std_logic;
    signal testing      : boolean := true;

    begin
        clk <= not clk after clk_period/2 when testing else '0';

        dut: RippleCarryAdder
        generic map (
            NBit => NBit
        )
        port map(
            A       => a_ext,
            B       => b_ext,
            Cin     => c_in_ext,
            S       => s_ext,
            Cout    => c_out_ext
        );

        stimulus : process 
			begin
			a_ext 	 <= (others => '0');
			b_ext 	 <= (others => '0');
			c_in_ext <= '0';
			wait for 200 ns;                -- 6 + 38
			a_ext 	 <= x"0006";
			b_ext 	 <= x"0026";
			c_in_ext <= '0';
			wait until rising_edge(clk);    -- 118 + 20
			a_ext 	 <= x"0076";
			b_ext 	 <= x"0014";
			c_in_ext <= '0';
			wait until rising_edge(clk);    -- 192 + 3
			a_ext 	 <= x"00C0";
			b_ext 	 <= x"0003";
			c_in_ext <= '1';
			wait for 1008 ns;               -- overflow
			a_ext 	 <= x"FFFF";
			b_ext 	 <= x"FFFF";
			c_in_ext <= '0';
			wait for 500 ns;
			testing  <= false;
		end process;
end rtl;