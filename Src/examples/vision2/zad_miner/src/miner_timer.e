note
	description: "Object representing the timer"
	author: "Jocelyn FIAT"
	version: "1.2"
	date: "$Date$"
	revision: "$Revision$"

class
	MINER_TIMER

create
	make

feature -- Initialization

	make (label_time: EV_LABEL)
			-- Creation routine
		do
			label := label_time
			change := False
			reset
		end

	reset
		do
			time := 0
		end

	stop
		do
			change := False
		end

	start
		do
			change := True
			reset
		end

	label: EV_LABEL

	time: INTEGER

	change: BOOLEAN

feature -- Implementation

	execute (arg: INTEGER)
		local
			delai: INTEGER_REF
			t_text: STRING
			hour, min, sec: INTEGER
		do
			if (change = True)
			then
				delai := arg
				time := time + ( delai.item // 100 )
				hour := (time // 10 // 3600)
				min := (time // 10 // 60) \\ 60
				sec := ( time // 10) \\ 60

				create t_text.make(0)
				t_text.append (hour.out)
				t_text.append (":")
				if (min <10) then
					t_text.append ("0")
				end
				t_text.append (min.out)
				t_text.append (":")
				if (sec <10) then
					t_text.append ("0")
				end
				t_text.append (sec.out)

				label.set_text (t_text)
			end
		end

end -- class MINER_TIMER

--|-------------------------------------------------------------------------
--| Eiffel Mine Sweeper -- ZaDoR (c) --
--| version 1.2 (july 2001)
--|
--| by Jocelyn FIAT
--| email: jocelyn.fiat@ifrance.com
--|
--| freely distributable
--|-------------------------------------------------------------------------

