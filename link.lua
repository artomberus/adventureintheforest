require "fmt"

if not instead.atleast(3, 2) then
	std.dprint("Warning: link module is not functional on this INSTEAD version")
	function instead.clipboard()
		return false
	end
end

obj {
	nam = '$link';
	act = function(s, w)
		if instead.clipboard() ~= w then
			std.p ('{@link ', w, '|', w, '}')
		else
			if ru then std.p(fmt.u (w) ..' [в буфере обмена]') end;
			if en then std.p(fmt.u (w) ..' [in clipboard]') end;
			if ua then std.p(fmt.u (w) ..' [в буфері обміну]') end;
		end
	end;
}

obj {
	nam = '@link';
	act = function(s, w)
		instead.clipboard(w)
	end;
}
