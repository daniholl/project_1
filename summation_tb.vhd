library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

-- Writing a simple testbench for a program for addition.

entity testbench is
end entity;


architecture rtl of testbench is

  component summation is
  port
  (
   clk                  : in std_logic;
   din_data             : in signed(7 downto 0);
   din_valid            : in std_logic;
   din_final            : in std_logic;
  
   dout_summation       : out signed(10 downto 0);
   dout_summation_valid : out std_logic
  );
  end component;

  constant NUM_ITERATIONS         : integer := 8;
  constant SPACING_BETWEEN_VALIDS : integer := 6;

  signal clock_period : time      := 20 ns;
  signal clk          : std_logic := '0';

  signal counter      : unsigned(4 downto 0) := (others => '0');
  signal spacing      : std_logic_vector(SPACING_BETWEEN_VALIDS - 1 downto 0) := (0 => '1', others => '0');
  signal din          : signed(7 downto 0) := to_signed(1, 8);
  signal din_valid    : std_logic;
  signal din_valid_r  : std_logic := '0';
  signal din_finished : std_logic := '0';

  signal dout_data    : signed(10 downto 0);
  signal dout_valid   : std_logic;

begin

  -- Writing the clock function
  clock_process :process
  begin
    clk <= '0';
    wait for clock_period/2;
    clk <= '1';
    wait for clock_period/2;
  end process;

  spacing_pro : process(clk)
  begin
    if rising_edge(clk) then
      spacing <= spacing(SPACING_BETWEEN_VALIDS - 2 downto 0) & spacing(SPACING_BETWEEN_VALIDS - 1);
    end if;
  end process;

  din_valid <= spacing(3) and not din_finished;

  -- Counting the number of iterations we have produced to send out finished flag.
 end_pro : process(clk)
 begin
   if rising_edge(clk) then
    if din_finished <= '0' then
      din_valid_r <= din_valid;
     if din_valid ='1' then
       counter <= counter + to_unsigned(1, counter'length);
       din <= din + to_signed(5, din'length); -- Adding in a change in data at this point. We should get 1, 6, 11, 16, 21, 26, etc...
     end if;
      if counter = NUM_ITERATIONS-1 and din_valid_r = '1' then
        counter <= (others => '0');
        din_finished <= '1';
      end if;
     end if;
   end if;
 end process;

  summation_inst : summation
  port map
  (
    clk                  => clk,
    din_data             => din,
    din_valid            => din_valid_r,
    din_final            => din_finished,

    dout_summation       => dout_data,
    dout_summation_valid => dout_valid
  );

end architecture;



  



  