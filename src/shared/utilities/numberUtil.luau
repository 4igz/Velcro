local numberUtil = {}

local suffixes = {
	{ 10 ^ 69, "Uvg" }, -- Unvigintillion
	{ 10 ^ 66, "Utg" }, -- Unsexdecillion
	{ 10 ^ 63, "Vg" }, -- Vigintillion
	{ 10 ^ 60, "Nvg" }, -- Novemdecillion
	{ 10 ^ 57, "Ovg" }, -- Octodecillion
	{ 10 ^ 54, "Spg" }, -- Septendecillion
	{ 10 ^ 51, "Sdg" }, -- Sedecillion
	{ 10 ^ 48, "Qdg" }, -- Quindecillion
	{ 10 ^ 42, "Tdc" }, -- Tredecillion
	{ 10 ^ 39, "Ddc" }, -- Duodecillion
	{ 10 ^ 36, "Ud" }, -- Undecillion
	{ 10 ^ 33, "Dc" }, -- Decillion
	{ 10 ^ 30, "No" }, -- Nonillion
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
	return string.format("%.2f", n)
end

return numberUtil
