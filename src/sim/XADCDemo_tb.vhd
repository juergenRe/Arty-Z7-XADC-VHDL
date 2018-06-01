----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/26/2018 05:52:13 PM
-- Design Name: 
-- Module Name: XADCDemo_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity XADCDemo_tb is
--  Port ( );
end XADCDemo_tb;

architecture Behavioral of XADCDemo_tb is
component XADCDemo is
    Port ( clk          : in STD_LOGIC;
           sw           : in STD_LOGIC_VECTOR (1 downto 0);
           data_out     : out STD_LOGIC_VECTOR (7 downto 0);
           led          : out STD_LOGIC_VECTOR (1 downto 0);
--           v_p          : in STD_LOGIC;
--           v_n          : in STD_LOGIC;
           xa_n         : in STD_LOGIC_VECTOR (1 downto 0);
           xa_p         : in STD_LOGIC_VECTOR (1 downto 0));
end component;

-- inputs
signal clk:         std_logic := '0';
signal sw:          STD_LOGIC_VECTOR (1 downto 0);
signal xa_n:        STD_LOGIC_VECTOR (1 downto 0);
signal xa_p:        STD_LOGIC_VECTOR (1 downto 0);

--outputs
signal led:         STD_LOGIC_VECTOR (1 downto 0);
signal data_out:    STD_LOGIC_VECTOR (7 downto 0);

-- clock period
constant clock_period: time := 10ns;

begin
-- instantiate UUT
dut: XADCDemo
    port map(
        clk     => clk,
        sw      => sw,
        data_out=> data_out,
        led     => led,
--        v_p     => '0',
--        v_n     => '0',
        xa_n    => xa_n,
        xa_p    => xa_p
    );

clk_process: process
begin
    clk <= '0';
    wait for clock_period/2;
    clk <= '1';
    wait for clock_period/2;
end process;

-- stimulus process
stim_proc: process
begin
      wait for 100 ns;
      sw(0) <= '0';
      sw(1) <= '0';
      wait for 3us;
      sw(0) <= '1';
      wait for 10us;
      sw(1) <= '1';
      wait for 100us;
      sw(0) <= '0';
      sw(1) <= '0';
      
end process;
end Behavioral;
