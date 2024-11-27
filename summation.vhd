library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Writing a simple to determine the total of a group of inputted values.

entity summation is
  port
  (
    clk                  : in std_logic;
    din_data             : in signed(7 downto 0);
    din_valid            : in std_logic;
    din_final            : in std_logic;

    dout_summation       : out signed(10 downto 0);
    dout_summation_valid : out std_logic
  );
end entity;


architecture rtl of summation is

  signal rolling_sum  : signed(10 downto 0) := (others => '0');
  signal din_final_r  : std_logic;
  signal din_final_rr : std_logic;

begin
  summing_pro : process(clk) is
  begin
    if rising_edge(clk) then
      din_final_r <= din_final;
      din_final_rr <= din_final_r;
      dout_summation_valid <= din_final_rr;
      if din_valid = '1' then
        rolling_sum <= rolling_sum + din_data;
      end if;

      if din_final_rr = '1' then
        dout_summation <= rolling_sum;
        rolling_sum <= (others => '0');
      end if;
    end if;
  end process;
  
end architecture;



