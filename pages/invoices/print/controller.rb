
include Direct

def on_full(path, request)
	request.controller[:invoice] = Financier::Invoice.fetch(Financier::DB, request[:id])
end

def on_plain(path, request)
	request.controller[:invoice] = Financier::Invoice.fetch(Financier::DB, request[:id])
end

