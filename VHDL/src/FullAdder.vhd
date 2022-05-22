library IEEE;
use IEEE.std_logic_1164.all;

---------------------------------------------------------
-- Entity
---------------------------------------------------------

entity FullAdder is
    port (
        a    : in  std_logic;
        b    : in  std_logic;
        Cin  : in  std_logic;
        S    : out std_logic;
        Cout : out std_logic
    );
end FullAdder;

---------------------------------------------------------
-- Architecture
---------------------------------------------------------

architecture rtl of fullAdder is 
begin

	S    <= a xor b xor Cin;
	Cout <= (a and b) or (a and Cin) or (b and Cin);

end rtl;
