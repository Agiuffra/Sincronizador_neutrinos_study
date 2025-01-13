-- =======================================================================
-- Fine Time Counter - Proyecto Neutrinos ( ZynQ7000 AC7020C )
-- =======================================================================
-- Bloque que realiza la cuenta fina en base al cristal del FPGA. Siendo el
-- cristal de 50 MHz, con error de 20 ppm, tendria una cuenta cada 20 ns. 
-- El I/O solo consiste en el CLK (pin U18), un RST y un ISR como entradas
-- y una salida de 4 bytes con la cuenta. CLK recibe la oscilacion del cristal
-- de 50 MHz, RST solo resetea la cuenta, ISR envia la cuenta por el output
-- CNT y resetea la cuenta.
-- -----------------------------------------------------------------------
-- Autor:   Alessandro Giuffra Lovera
--          Universidad de Ingenieria y Tecnologia - UTEC
--          01/2025

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity FT_CNTR is
    Port ( CLK : in std_logic;                              -- Clock
           EN  : in std_logic := '1';                       -- Enable
           RST : in std_logic;                              -- Reset
           ISR : in std_logic;                              -- Interruptor de cuenta
           CNT : out std_logic_vector ( 31 downto 0 ) := ( others => '0' ) );    -- Salida con la cuenta 4 bytes (4 294 967 296) igual a 85 segundos
end FT_CNTR;

architecture Behavioral of FT_CNTR is

    signal CNT_BUFFER : unsigned ( 31 downto 0 ) := ( others => '0' );    -- Buffer de la cuenta

begin

    process ( CLK, RST, ISR )
    -- process ( CLK, ISR )
    begin
        if ( RST = '1' ) then
            CNT_BUFFER <= ( others => '0' );
        elsif (ISR = '1') then
            CNT <= std_logic_vector(CNT_BUFFER);
            CNT_BUFFER <= ( others => '0' );
        elsif ( rising_edge( CLK ) ) then
            if ( EN = '1' ) then
                CNT_BUFFER <= CNT_BUFFER + 1;
            end if;
        end if;
    end process;

end Behavioral;
