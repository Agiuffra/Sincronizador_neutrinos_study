-- =======================================================================
-- Time Stamp Controller - Proyecto Neutrinos ( ZynQ7000 AC7020C )
-- =======================================================================
-- Proyecto TOP donde se llama a todas las instancias del time stamp control.
-- -----------------------------------------------------------------------
-- Autor:   Alessandro Giuffra Lovera
--          Universidad de Ingenieria y Tecnologia - UTEC
--          01/2025

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity TS_CTRL is
    Port ( 
        CLK         : in std_logic;         -- Clock
        S1, S2, S3  : in std_logic;         -- Senales de interrupcion
        UART_TX_o   : out std_logic;        -- Salida UART serial
        LED1        : out std_logic := '1'  -- LED embebido para debug
    );
end TS_CTRL;

architecture Behavioral of TS_CTRL is

    component UART is
        Port (
            SEND        : in std_logic; 
            DATA        : in std_logic_vector ( 7 downto 0 );
            CLK         : in std_logic;
            READY       : out std_logic;
            UART_TX_o   : out std_logic
        );
    end component;

    component FT_CNTR is
        Port (
            CLK : in std_logic;                         -- Clock      
            EN  : in std_logic;                         -- Enable     
            -- RST : in std_logic;                              -- Reset   
            ISR : in std_logic;                         -- Interruptor
            CNT : out std_logic_vector ( 31 downto 0 )  -- Cuenta en paralelo
        );
    end component;
    
    component RST_DTCTR is
        Port (
            RF1 : in std_logic;     -- Senal de entrada 1
            RF2 : in std_logic;     -- Senal de entrada 2
            RF3 : in std_logic;     -- Senal de entrada 3
            ISR : out std_logic     -- Salida de interrupcion
        );
    end component;

    signal s_CLK        : std_logic := '0'; 
    signal BYTE         : std_logic_vector ( 3 downto 0 ) := (others => '0');
    
    signal s_SEND       : std_logic := '0'; 
    signal s_READY      : std_logic := '0'; 
    signal s_UART_TX_o  : std_logic := '0'; 
    signal s_DATA       : std_logic_vector ( 7 downto 0 ) := (others => '0');
    
    signal s_EN         : std_logic := '0'; 
    signal s_ISR        : std_logic := '0'; 
    signal s_CNT        : std_logic_vector ( 31 downto 0 ) := (others => '0');
    
    signal s_RF1        : std_logic := '0'; 
    signal s_RF2        : std_logic := '0'; 
    signal s_RF3        : std_logic := '0';
    
    constant DATA_SIZE  : std_logic_vector ( 3 downto 0 ) := x"4";
    
    type state_type is (IDLE, LOAD_DATA, SEND_DATA, WAIT_START, WAIT_READY); -- Estados de la FSM
    signal state : state_type := IDLE;

begin

    s_CLK       <= CLK;
    s_RF1       <= S1;
    s_RF2       <= S2;
    s_RF3       <= S3;
    UART_TX_o   <= s_UART_TX_o;

    UART01: UART port map (
        SEND        => s_SEND,
        DATA        => s_DATA,
        CLK         => s_CLK,
        READY       => s_READY,
        UART_TX_o   => s_UART_TX_o
    );
    
    RST01:  RST_DTCTR port map (
        RF1 => s_RF1,
        RF2 => s_RF2,
        RF3 => s_RF3,
        ISR => s_ISR
    );
    
    CNTR01: FT_CNTR port map (
        CLK => s_CLK,      
        EN  => s_EN, 
        ISR => s_ISR,
        CNT => s_CNT
    );
    
    SM01: process (s_CLK, s_SEND, BYTE)
    begin
        if ( rising_edge ( s_CLK ) ) then
            case state is
                
                when IDLE =>
                    if ( s_ISR = '1' ) then
                        BYTE    <= x"0";
                        state   <= LOAD_DATA;
                    end if;
                    
                when LOAD_DATA =>
                    if ( BYTE < DATA_SIZE ) then
                        LED1    <= '0';
                        s_SEND  <= '1';
                        state   <= SEND_DATA;
                    else
                        state   <= IDLE;
                    end if;
                
                when SEND_DATA =>
                    if ( s_READY = '1' ) then
                        s_SEND  <= '0';
                        state   <= WAIT_START;
                    end if;
                
                when WAIT_START =>
                    if ( s_UART_TX_o = '0' ) then
                        state   <= WAIT_READY;
                    end if;
                
                when WAIT_READY =>
                    if ( s_READY = '1' ) then
                        LED1    <= '1';
                        BYTE    <= BYTE + 1;
                        state   <= LOAD_DATA;
                    end if;
                
                when others =>
                    state   <= IDLE;
                
            end case;
        end if; 
    end process;
    
    s_DATA  <=  s_CNT ( 31 downto 24 ) when ( BYTE = x"00" ) else
                s_CNT ( 23 downto 16 ) when ( BYTE = x"01" ) else
                s_CNT ( 15 downto  8 ) when ( BYTE = x"02" ) else
                s_CNT (  7 downto  0 ) when ( BYTE = x"03" ) else
                x"FF";

end Behavioral;
