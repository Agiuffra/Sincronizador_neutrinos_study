-- =======================================================================
-- Reset Detector - Proyecto Neutrinos ( ZynQ7000 AC7020C )
-- =======================================================================
-- Bloque que detecta la interrupcion de los receptores de RF. Este tiene 
-- un AND, pues espera a que las tres senales esten activas para que tenga
-- una salida en alta.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RST_DTCTR is
    Port ( RF1 : in std_logic;  -- Senal de entrada 1
           RF2 : in std_logic;  -- Senal de entrada 2
           RF3 : in std_logic;  -- Senal de entrada 3
           ISR : out std_logic); -- Salida de interrupcion
end RST_DTCTR;

architecture Behavioral of RST_DTCTR is

begin

    ISR <= RF1 and RF2 and RF3;

end Behavioral;
