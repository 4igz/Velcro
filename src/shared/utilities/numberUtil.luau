local numberUtil = {}

local suffixes = {
	{ 10 ^ 69, "uvg" }, -- Unvigintillion
	{ 10 ^ 66, "utg" }, -- Unsexdecillion
	{ 10 ^ 63, "vg" }, -- Vigintillion
	{ 10 ^ 60, "nvg" }, -- Novemdecillion
	{ 10 ^ 57, "ovg" }, -- Octodecillion
	{ 10 ^ 54, "spg" }, -- Septendecillion
	{ 10 ^ 51, "sdg" }, -- Sedecillion
	{ 10 ^ 48, "qdg" }, -- Quindecillion
	{ 10 ^ 42, "tdc" }, -- Tredecillion
	{ 10 ^ 39, "ddc" }, -- Duodecillion
	{ 10 ^ 36, "ud" }, -- Undecillion
	{ 10 ^ 33, "dc" }, -- Decillion
	{ 10 ^ 30, "no" }, -- Nonillion
	{ 10 ^ 27, "Oc" }, -- Octillion
	{ 10 ^ 24, "Sp" }, -- Septillion
	{ 10 ^ 21, "Sx" }, -- Sextillion
	{ 10 ^ 18, "Qn" }, -- Quintillion
	{ 10 ^ 15, "Qd" }, -- Quadrillion
	{ 10 ^ 12, "T" }, -- Trillion
	{ 10 ^ 9, "B" }, -- Billion
	{ 10 ^ 6, "M" }, -- Million
	{ 10 ^ 3, "K" }, -- Thousand
}

function numberUtil.simplifyNumber(n)
	for i, v in suffixes do
		if n >= v[1] then
			return string.format("%.2f%s", n / v[1], v[2])
		end
	end
	return math.floor(n)
end

return numberUtil
