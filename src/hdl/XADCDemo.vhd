----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.05.2018 18:46:50
-- Design Name: 
-- Module Name: Top - Behavioral
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
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- ad0 corresponds to AD8/AD9 pair
-- ad12 corresponds to AD6/AD7 pair
-- !!! The sequence of analog input signals must follow the sequence of enabled 
-- analog inputs of the xadc macro. Otherwise routing will fail!!

entity XADCDemo is
    Port ( 
           clk      : in STD_LOGIC;
           sw       : in STD_LOGIC_VECTOR (1 downto 0);
           led      : out STD_LOGIC_vector(1 downto 0);
           data_out : out STD_LOGIC_VECTOR (7 downto 0);
--           v_p      : in STD_LOGIC;
--           v_n      : in STD_LOGIC;
           xa_p     : in STD_LOGIC_vector(1 downto 0);
           xa_n     : in STD_LOGIC_vector(1 downto 0)
          );
end XADCDemo;

architecture Behavioral of XADCDemo is

attribute mark_debug:   string;
attribute keep:         string;

COMPONENT xadc_wiz_0
  PORT (
    di_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    daddr_in : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    den_in : IN STD_LOGIC;
    dwe_in : IN STD_LOGIC;
    drdy_out : OUT STD_LOGIC;
    do_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    dclk_in : IN STD_LOGIC;
    vp_in : IN STD_LOGIC;
    vn_in : IN STD_LOGIC;
    vauxp0 : IN STD_LOGIC;
    vauxn0 : IN STD_LOGIC;
    vauxp12 : IN STD_LOGIC;
    vauxn12 : IN STD_LOGIC;
    channel_out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    eoc_out : OUT STD_LOGIC;
    alarm_out : OUT STD_LOGIC;
    eos_out : OUT STD_LOGIC;
    busy_out : OUT STD_LOGIC
  );
END COMPONENT;
constant pwmMax:        std_logic_vector(11 downto 0) := x"FE6";
constant chan0_addr:    std_logic_vector(4 downto 0) := "10000";  -- x10
constant chan1_addr:    std_logic_vector(4 downto 0) := "11100";  -- x14

signal di_in:           std_logic_vector(15 downto 0);
signal data:            std_logic_vector(15 downto 0);
signal data0_reg:       std_logic_vector(11 downto 0);
signal data1_reg:       std_logic_vector(11 downto 0);
signal daddr_in:        std_logic_vector(6 downto 0);
signal channel_out:     std_logic_vector(4 downto 0);
signal den_in:          std_logic;
signal dataReady:       std_logic;
signal convDone:        std_logic;
signal pwmCnt:          std_logic_vector(11 downto 0) := x"000";

begin

xadc_inst : xadc_wiz_0
  PORT MAP (
    di_in => di_in,
    daddr_in => daddr_in,
    den_in => den_in,
    dwe_in => '0',
    drdy_out => dataReady,
    do_out => data,
    dclk_in => clk,
    vp_in => '0',
    vn_in => '0',
    vauxp0 => xa_p(0),
    vauxn0 => xa_n(0),
    vauxp12 => xa_p(1),
    vauxn12 => xa_n(1),
    channel_out => channel_out,
    eoc_out => convDone,
    alarm_out => open,
    eos_out => open,
    busy_out => open
  );
  
den_proc: process(clk)
begin
    if clk'event and clk = '1' then
        den_in <= convDone  and (sw(0) or sw(1));
    end if;
end process;

set_data_reg: process(clk, dataReady)
begin
    if clk'event and clk = '1' then
        if dataReady = '1' then
            case channel_out is
                when chan0_addr =>      -- reading from AD8/AD9 inputs
                    data1_reg <= data(15 downto 4);
                when chan1_addr =>      -- reading from AD6/AD7 inputs
                    data0_reg <= data(15 downto 4);
                when others =>
            end case;  
--            data0_reg <= data(15 downto 4);
        end if;
    end if;
end process set_data_reg;

di_in <= x"0000";
--led <= data0_reg(0) xor data0_reg(3) xor data0_reg(5) xor data0_reg(7) xor data0_reg(9) xor data0_reg(11);
daddr_in <= "00" & channel_out;

--    ///////////////////////////////////////////////////////////////////
--    //LED PWM
--    //////////////////////////////////////////////////////////////////  
pwm_proc: process(clk)
begin
    if clk'event and clk = '1' then
        if pwmCnt < pwmMax then
            pwmCnt <= pwmCnt + 1;
        else
            pwmCnt <= x"000";
        end if;
    end if;
end process pwm_proc;

led(0) <= sw(0) when (pwmCnt < data0_reg) else '0';
led(1) <= sw(1) when (pwmCnt < data1_reg) else '0';

data_out <= dataReady & "00" & channel_out;

end Behavioral;
