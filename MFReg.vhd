library IEEE;
use IEEE.std_logic_1164.all;


entity MFReg is
    port (
        x0: in BIT;
        x1: in BIT;
        x2: in BIT;
        x3: in BIT;
        z0: in BIT;
        z1: in BIT;
        z2: in BIT;
        z3: in BIT;
        y0: in BIT; 
        y1: in BIT;
        y2: in BIT;
        en: in BIT;
        clk: in BIT; 
        clr: in BIT;
        q0: buffer BIT;
        q1: buffer BIT;
        q2: buffer BIT;
        q3: buffer BIT
    );
end MFReg;


architecture MFReg_arch of MFReg is

    signal s1: INTEGER range 0 to 4;
    signal s2: INTEGER range 0 to 8;
    signal s3: INTEGER range 0 to 12;

    component CoZ1
        port (
            D0: in BIT;
            D1: in BIT;
            Y: in BIT;
            F: out INTEGER range 0 to 4
        );
    end component;

    component CoZ2
        port (
            D0: in BIT;
            D1: in BIT;
            D2: in BIT;
            D3: in BIT;
            Y: in BIT;
            F: out INTEGER range 0 to 8
        );
    end component;

    component SM
        port (
            A: in INTEGER range 0 to 4;
            B: in INTEGER range 0 to 8;
            S: out INTEGER range 0 to 12
        );
    end component;

    component RG
        port (
            SM: in INTEGER range 0 to 12;
            D0: in BIT;
            D1: in BIT;
            D2: in BIT;
            D3: in BIT;
            Y0: in BIT;
            Y1: in BIT;
            Y2: in BIT;
            EN: in BIT;
            CLK: in BIT;
            CLR: in BIT;
            Q0: buffer BIT;
            Q1: buffer BIT;
            Q2: buffer BIT;
            Q3: buffer BIT
        );
    end component;

begin

    OCoZ1: CoZ1
        port map (
            D0 =>x0,
            D1 =>x3,
            Y => y0,
            F => s1
        );

    OCoZ2: CoZ2
        port map (
            D0 =>z0,
            D1 =>z1,
            D2 =>z2,
            D3 =>z3,
            Y => y0,
            F => s2
        );

    OSM: SM
        port map (
            A => s1,
            B=> s2,
            S => s3
        );

    ORG: RG
        port map (
            SM =>s3,
            D0 => x0,
            D1 => x1,
            D2 => x2,
            D3 => x3,
            Y0 => y0,
            Y1 => y1,
            Y2 => y2,
            EN => en,
            CLK => clk,
            CLR => clr,
            Q0 => q0,
            Q1 => q1,
            Q2 => q2,
            Q3 => q3
        );

end MFReg_arch;


entity CoZ1 is
    port (
        D0: in BIT;
        D1: in BIT;
        Y: in BIT;
        F: out INTEGER range 0 to 4
    );
end CoZ1;


architecture CoZ1_arch of CoZ1 is
begin
process (D0, D1, Y)
    variable D: BIT_VECTOR (1 downto 0);
    begin
    if Y='1' then
        D:= D1 & D0;
        case D is
            when "00" => F<= 4;
            when "01" => F<= 2;
            when "10" => F<= 2;
            when "11" => F<= 0;
        end case;
    else
        case D0 is
            when '0' => F <= 0;
            when '1' => F <= 1;
        end case;
    end if;
end process;
end CoZ1_arch;


entity CoZ2 is
    port (
        D0: in BIT;
        D1: in BIT;
        D2: in BIT;
        D3: in BIT;
        Y: in BIT;
        F: out INTEGER range 0 to 8
    );
end CoZ2;


architecture CoZ2_arch of CoZ2 is
begin
process (D0, D1, D2, D3, Y)
    variable D: BIT_VECTOR (3 downto 0);
    begin
    if Y='1' then
        D := D3 & D2 & D1 & D0;
        case D is
            when "0000" => F<= 8;
            when "0001" => F<= 6;
            when "0010" => F<= 2;
            when "0011" => F<= 4;
            when "0100" => F<= 4;
            when "0101" => F<= 2;
            when "0110" => F<= 2;
            when "0111" => F<= 2;
            when "1000" => F<= 6;
            when "1001" => F<= 4;
            when "1010" => F<= 2;
            when "1011" => F<= 2;
            when "1100" => F<= 4;
            when "1101" => F<= 2;
            when "1110" => F<= 2;
            when "1111" => F<= 0;
        end case;
    else
        case D0 is
            when '0' => F <= 0;
            when '1' => F <= 1;
        end case;
    end if;
end process;
end CoZ2_arch;


entity SM is
    port (
        A: in INTEGER range 0 to 4;
        B: in INTEGER range 0 to 8;
        S: out INTEGER range 0 to 12
    );
end SM;


architecture SM_arch of SM is
begin
    S <= A + B;
end SM_arch;


entity RG is
    port (
        SM: in INTEGER range 0 to 12;
        D0: in BIT;
        D1: in BIT;
        D2: in BIT;
        D3: in BIT;
        Y0: in BIT;
        Y1: in BIT;
        Y2: in BIT;
        EN: in BIT;
        CLK: in BIT;
        CLR: in BIT;
        Q0: buffer BIT;
        Q1: buffer BIT;
        Q2: buffer BIT;
        Q3: buffer BIT
    );
end RG;


architecture RG_arch of RG is
begin
process (CLR, EN, CLK)
variable Y: BIT_VECTOR (2 downto 0);
begin
    if CLR='1' then
        Q0 <= '0';
        Q1 <= '0';
        Q2 <= '0';
        Q3 <= '0';
    elsif EN = '0' then
        null;
    elsif CLK'event and CLK='1' then
        Y := Y0 & Y1 & Y2;
        if Y = "000" then
            Q0 <= D0;
            Q1 <= D1;
            Q2 <= D2;
            Q3 <= D3;
        elsif Y = "001" then
            if SM = 1 then
                Q0 <= Q1;
                Q1 <= Q2;
                Q2 <= Q3;
                Q3 <= '0';
            elsif SM = 2 then
                Q0 <= Q2;
                Q1 <= Q3;
                Q2 <= '0';
                Q3 <= '0';
            end if;
        elsif Y = "010" then
            Q0 <= Q3;
            Q1 <= Q0;
            Q2 <= Q1;
        elsif Y = "011" then
            Q0 <= Q0 and D0;
            Q1 <= Q1 and D1;
            Q2 <= Q2 and D2;
            Q3 <= Q3 and D3;
        elsif Y = "100" then
            Q0 <= not Q0;
            Q1 <= not Q1;
            Q2 <= not Q2;
            Q3 <= not Q3;
        elsif Y = "101" then
            Q0 <= Q0 or D0;
            Q1 <= Q1 or D1;
            Q2 <= Q2 or D2;
            Q3 <= Q3 or D3;
        elsif Y = "110" or Y = "111" then
            Q0 <= '0';
            case SM is
                when 2 | 6 | 10 => Q1 <= '1';
                when others => Q1 <= '0';
            end case;
            case SM is
                when 4 | 6 | 12 => Q2 <= '1';
                when others => Q2 <= '0';
            end case;
            case SM is
                when 8 | 10 | 12 => Q3 <= '1';
                when others => Q3 <= '0';
            end case;
        end if;
    end if;
end process;
end RG_arch;
